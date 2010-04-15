package org.libspark.gunyarapaint.framework.modules
{
    import flash.geom.Point;
    
    import org.libspark.gunyarapaint.framework.LayerBitmap;
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.CompatibilityCommand;
    import org.libspark.gunyarapaint.framework.commands.HorizontalMirrorCommand;
    import org.libspark.gunyarapaint.framework.commands.PenCommand;
    import org.libspark.gunyarapaint.framework.commands.RedoCommand;
    import org.libspark.gunyarapaint.framework.commands.ResetAllCommand;
    import org.libspark.gunyarapaint.framework.commands.UndoCommand;
    import org.libspark.gunyarapaint.framework.commands.VerticalMirrorCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.CopyLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.CreateLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.MergeLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.RemoveLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerAlphaCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerBlendModeCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerIndexCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SwapLayerCommand;
    import org.libspark.gunyarapaint.framework.errors.InvisibleLayerError;
    import org.libspark.gunyarapaint.framework.errors.LockedLayerError;

    public class CanvasModule
    {
        public function CanvasModule(recorder:Recorder)
        {
            m_recorder = recorder;
        }
        
        public function undo():void
        {
            m_recorder.commitCommand(UndoCommand.ID, {});
        }
        
        public function redo():void
        {
            m_recorder.commitCommand(RedoCommand.ID, {});
        }
        
        public function horizontalMirror(index:uint):void
        {
            m_recorder.commitCommand(
                HorizontalMirrorCommand.ID,
                {
                    "index": index
                }
            );
        }
        
        public function verticalMirror(index:uint):void
        {
            m_recorder.commitCommand(
                VerticalMirrorCommand.ID,
                {
                    "index": index
                }
            );
        }
        
        public function copyLayer():void
        {
            m_recorder.commitCommand(
                CopyLayerCommand.ID,
                {}
            );
        }
        
        public function createLayer():void
        {
            m_recorder.commitCommand(
                CreateLayerCommand.ID,
                {}
            );
        }
        
        public function mergeLayers():void
        {
            m_recorder.commitCommand(
                MergeLayerCommand.ID,
                {}
            );
        }
        
        public function removeLayer():void
        {
            m_recorder.commitCommand(
                RemoveLayerCommand.ID,
                {}
            );
        }
        
        public function swapLayers(from:uint, to:uint):void
        {
            m_recorder.commitCommand(
                SwapLayerCommand.ID,
                {
                    "from": from,
                    "to": to
                }
            );
        }
        
        public function setCompatibility(type:uint, value:Boolean):void
        {
            m_recorder.commitCommand(
                CompatibilityCommand.ID,
                {
                    "type": type,
                    "value": value
                }
            );
        }
        
        public function reset():void
        {
            m_recorder.commitCommand(ResetAllCommand.ID, {});
        }
        
        /**
         * 始点と終点を取得する(現在は単体テスト用に使われているのみ)
         * 
         * @param start 始点
         * @param end 終点
         */
        public function getLineSegment(start:Point, end:Point):void
        {
            start.x = s_startPointX;
            start.y = s_startPointY;
            end.x = s_endPointX;
            end.y = s_endPointY;
        }
        
        /**
         * 始点と終点の座標を保存する
         * 
         * @param x
         * @param y
         */
        protected function saveCoordinate(x:Number, y:Number):void
        {
            s_startPointX = s_coordinateX;
            s_startPointY = s_coordinateY;
            s_endPointX = x;
            s_endPointY = y;
        }
        
        /**
         * 現在のレイヤーの状態を検証する
         * 
         * @throws InvisibleLayerError 現在のレイヤーが不可視の場合
         * @throws LockedLayerError 現在のレイヤーがロックされている場合
         */
        protected function validateLayerState():void
        {
            var layer:LayerBitmap = m_recorder.layers.currentLayer;
            if (!layer.visible)
                throw new InvisibleLayerError();
            else if (layer.locked)
                throw new LockedLayerError();
        }
        
        /**
         * 現在の座標を設定する
         * 
         * @param x x座標
         * @param y y座標
         */
        protected function setCoordinate(x:Number, y:Number):void
        {
            if (s_shouldDrawFromEndPoint) {
                s_coordinateX = s_endPointX;
                s_coordinateY = s_endPointY;
            }
            else if (s_shouldDrawFromStartPoint) {
                s_coordinateX = s_startPointX;
                s_coordinateY = s_startPointY;
            }
            else {
                s_coordinateX = x;
                s_coordinateY = y;
            }
        }
        
        /**
         * 指定された座標が現在の座標と一致するかを確認する
         * 
         * @param x x座標
         * @param y y座標
         * @return 同じである場合は true
         */        
        protected function equalsCoordinate(x:uint, y:uint):Boolean
        {
            var from:Point = new Point(s_coordinateX, s_coordinateY);
            var to:Point = new Point(x, y);
            m_recorder.correctCoordinate(from);
            m_recorder.correctCoordinate(to);
            return from.equals(to);
        }
        
        /**
         * 現在の座標から ICommand#write に渡す引数に変換する
         * 
         */
        protected function getArgumentsFromCurrentCoordinate():Object
        {
            return getArgumentsFromCoordinate(s_coordinateX, s_coordinateY);
        }
        
        /**
         * 指定された座標から ICommand#write に渡す引数に変換する
         * 
         * @param x x座標
         * @param y y座標
         * @return args プロパティxとyで構成されるオブジェクト
         */
        protected function getArgumentsFromCoordinate(x:Number, y:Number):Object
        {
            var coordinate:Point = new Point(x, y);
            m_recorder.correctCoordinate(coordinate);
            var args:Object = {
                "x": coordinate.x,
                "y": coordinate.y
            };
            return args;
        }
        
        /**
         * 描写処理を終了する
         * 
         */
        protected function stopDrawing():void
        {
            m_recorder.stopDrawingSession();
        }
        
        public function set shouldDrawCircleClockwise(value:Boolean):void
        {
            s_shouldDrawCircleClockwise = value;
        }
        
        public function set shouldDrawCircleCounterClockwise(value:Boolean):void
        {
            s_shouldDrawCircleCounterClockwise = value;
        }
        
        public function set shouldDrawFromStartPoint(value:Boolean):void
        {
            s_shouldDrawFromStartPoint = value;
        }
        
        public function set shouldDrawFromEndPoint(value:Boolean):void
        {
            s_shouldDrawFromEndPoint = value;
        }
        
        public function set alpha(value:Number):void
        {
            m_recorder.commitCommand(
                PenCommand.ID,
                {
                    "type": PenCommand.ALPHA,
                    "alpha": value
                }
            );
        }
        
        public function set blendMode(value:String):void
        {
            
            m_recorder.commitCommand(
                PenCommand.ID,
                {
                    "type": PenCommand.BLEND_MODE,
                    "blendMode": value
                }
            );
        }
        
        public function set color(value:uint):void
        {
            m_recorder.commitCommand(
                PenCommand.ID,
                {
                    "type": PenCommand.COLOR,
                    "color": value
                }
            );
        }
        
        public function set thickness(value:uint):void
        {
            m_recorder.commitCommand(
                PenCommand.ID,
                {
                    "type": PenCommand.THICKNESS,
                    "thickness": value
                }
            );
        }
        
        public function set layerAlpha(value:Number):void
        {
            m_recorder.commitCommand(
                SetLayerAlphaCommand.ID,
                {
                    "alpha": value
                }
            );
        }
        
        public function set layerBlendMode(value:String):void
        {
            m_recorder.commitCommand(
                SetLayerBlendModeCommand.ID,
                {
                    "blendMode": value
                }
            );
        }
        
        public function set layerIndex(value:uint):void
        {
            m_recorder.commitCommand(
                SetLayerIndexCommand.ID,
                {
                    "index": value
                }
            );
        }
        
        protected function get coordinateX():Number
        {
            return s_coordinateX;
        }
        
        protected function get coordinateY():Number
        {
            return s_coordinateY;
        }
        
        protected function getShouldDrawCircleClockwise():Boolean
        {
            return s_shouldDrawCircleClockwise;
        }
        
        protected function getShouldDrawCircleCounterClockwise():Boolean
        {
            return s_shouldDrawCircleCounterClockwise;
        }
        
        private static var s_coordinateX:Number = 0;
        private static var s_coordinateY:Number = 0;
        private static var s_startPointX:Number = 0;
        private static var s_startPointY:Number = 0;
        private static var s_endPointX:Number = 0;
        private static var s_endPointY:Number = 0;
        private static var s_shouldDrawCircleClockwise:Boolean = false;
        private static var s_shouldDrawCircleCounterClockwise:Boolean = false;
        private static var s_shouldDrawFromStartPoint:Boolean = false;
        private static var s_shouldDrawFromEndPoint:Boolean = false;
        protected var m_recorder:Recorder;
    }
}
