package org.libspark.gunyarapaint.framework.modules
{
    import flash.geom.Point;
    
    import org.libspark.gunyarapaint.framework.LayerBitmap;
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.HorizontalMirrorCommand;
    import org.libspark.gunyarapaint.framework.commands.PenCommand;
    import org.libspark.gunyarapaint.framework.commands.RedoCommand;
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
        
        /**
         * 最後に移動した座標を保存する
         * 
         * @param x
         * @param y
         */
        public function saveCoordinate(x:Number, y:Number):void
        {
            s_coordinateXWithButtonDown = s_coordinateX;
            s_coordinateYWithButtonDown = s_coordinateY;
            s_coordinateXWithButtonUp = x;
            s_coordinateYWithButtonUp = y;
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
            if (s_shouldStartAfterDrawing) {
                s_coordinateX = s_coordinateXWithButtonUp;
                s_coordinateY = s_coordinateYWithButtonUp;
            }
            else if (s_shouldStartBeforeDrawing) {
                s_coordinateX = s_coordinateXWithButtonDown;
                s_coordinateY = s_coordinateYWithButtonDown;
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
            m_drawing = false;
        }
        
        /**
         * A ボタンがクリックされているかを設定する
         * 
         * @param value 
         */
        public function set keyA(value:Boolean):void
        {
            s_keyA = value;
        }
        
        /**
         * Q ボタンがクリックされているかを設定する
         * 
         * @param value 
         */
        public function set keyQ(value:Boolean):void
        {
            s_keyQ = value;
        }
        
        /**
         * 開始座標を描写終了後の座標に設定するかどうか (R)
         * 
         * @param value 
         */
        public function set shouldStartAfterDrawing(value:Boolean):void
        {
            s_shouldStartAfterDrawing = value;
        }
        
        /**
         * 開始座標を描写開始時の座標に設定するかどうか (T)
         * 
         * @param value 
         */
        public function set shouldStartBeforeDrawing(value:Boolean):void
        {
            s_shouldStartBeforeDrawing = value;
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
        
        protected function get key_A():Boolean
        {
            return s_keyA;
        }
        
        protected function get key_Q():Boolean
        {
            return s_keyQ;
        }
        
        private static var s_coordinateX:Number = 0;
        private static var s_coordinateY:Number = 0;
        private static var s_coordinateXWithButtonUp:Number = 0;
        private static var s_coordinateYWithButtonUp:Number = 0;
        private static var s_coordinateXWithButtonDown:Number = 0;
        private static var s_coordinateYWithButtonDown:Number = 0;
        private static var s_keyA:Boolean = false;
        private static var s_keyQ:Boolean = false;
        private static var s_shouldStartBeforeDrawing:Boolean = false;
        private static var s_shouldStartAfterDrawing:Boolean = false;
        protected var m_recorder:Recorder;
        protected var m_drawing:Boolean;
        protected var m_drawingLine:Boolean;
    }
}