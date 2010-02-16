package org.libspark.gunyarapaint.modules
{
    import flash.errors.IllegalOperationError;
    
    import org.libspark.gunyarapaint.LayerBitmap;
    import org.libspark.gunyarapaint.Logger;
    import org.libspark.gunyarapaint.Painter;
    import org.libspark.gunyarapaint.Recorder;
    import org.libspark.gunyarapaint.commands.HorizontalMirrorCommand;
    import org.libspark.gunyarapaint.commands.ICommand;
    import org.libspark.gunyarapaint.commands.PenCommand;
    import org.libspark.gunyarapaint.commands.RedoCommand;
    import org.libspark.gunyarapaint.commands.UndoCommand;
    import org.libspark.gunyarapaint.commands.VerticalMirrorCommand;
    import org.libspark.gunyarapaint.commands.layer.CopyLayerCommand;
    import org.libspark.gunyarapaint.commands.layer.CreateLayerCommand;
    import org.libspark.gunyarapaint.commands.layer.MergeLayerCommand;
    import org.libspark.gunyarapaint.commands.layer.RemoveLayerCommand;
    import org.libspark.gunyarapaint.commands.layer.SetLayerAlphaCommand;
    import org.libspark.gunyarapaint.commands.layer.SetLayerBlendModeCommand;
    import org.libspark.gunyarapaint.commands.layer.SetLayerIndexCommand;
    import org.libspark.gunyarapaint.commands.layer.SwapLayerCommand;

    internal class DrawModule
    {
        public function DrawModule(recorder:Recorder)
        {
            m_recorder = recorder;
            m_logger = recorder.logger;
        }
        
        public function undo():void
        {
            commitCommand(m_logger.getCommand(UndoCommand.ID), {});
        }
        
        public function redo():void
        {
            commitCommand(m_logger.getCommand(RedoCommand.ID), {});
        }
        
        public function horizontalMirror(index:uint):void
        {
            commitCommand(
                m_logger.getCommand(HorizontalMirrorCommand.ID),
                {
                    "index": index
                }
            );
        }
        
        public function verticalMirror(index:uint):void
        {
            commitCommand(
                m_logger.getCommand(VerticalMirrorCommand.ID),
                {
                    "index": index
                }
            );
        }
        
        public function copyLayer():void
        {
            commitCommand(m_logger.getCommand(CopyLayerCommand.ID), {});
        }
        
        public function createLayer():void
        {
            commitCommand(m_logger.getCommand(CreateLayerCommand.ID), {});
        }
        
        public function mergeLayers():void
        {
            commitCommand(m_logger.getCommand(MergeLayerCommand.ID), {});
        }
        
        public function removeLayer():void
        {
            commitCommand(m_logger.getCommand(RemoveLayerCommand.ID), {});
        }
        
        public function swapLayers(from:uint, to:uint):void
        {
            commitCommand(
                m_logger.getCommand(SwapLayerCommand.ID),
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
         * 以下の状態であれば IllegalOperationError を送出する
         * - 現在のレイヤーが不可視
         * - 現在のレイヤーがロックされている
         * 
         */
        protected function validateLayerState():void
        {
            var layer:LayerBitmap = m_recorder.painter.layers.currentLayer;
            if (!layer.visible)
                throw new IllegalOperationError();
            else if (layer.locked)
                throw new IllegalOperationError();
        }
        
        /**
         * 現在の座標を設定する
         * 
         * @param x
         * @param y
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
         * コマンドの書き出し及び実行を同時に行う
         * 
         * @param command コマンドオブジェクト
         * @param args コマンドに対する引数
         */
        protected function commitCommand(command:ICommand, args:Object):void
        {
            command.write(m_recorder.logger.bytes, args);
            command.execute(m_recorder);
        }
        
        /**
         * 指定された座標が現在の座標と一致するかを確認する
         * 
         * @param x
         * @param y
         * @return 同じである場合は true
         */        
        protected function equalsCoordinate(x:Number, y:Number):Boolean
        {
            var painter:Painter = m_recorder.painter;
            return painter.roundPixel(x) == painter.roundPixel(s_coordinateX) &&
                painter.roundPixel(y) == painter.roundPixel(s_coordinateY);
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
         * @param x
         * @param y
         * @return args
         */
        protected function getArgumentsFromCoordinate(x:Number, y:Number):Object
        {
            var painter:Painter = m_recorder.painter;
            var args:Object = {
                "x": painter.roundPixel(x),
                "y": painter.roundPixel(y)
            };
            return args;
        }
        
        /**
         * 描写処理を終了する
         * 
         */
        protected function stopDrawing():void
        {
            m_recorder.painter.stopDrawingSession();
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
            commitCommand(
                m_logger.getCommand(PenCommand.ID),
                {
                    "type": PenCommand.ALPHA,
                    "alpha": value
                }
            );
        }
        
        public function set blendMode(value:String):void
        {
            
            commitCommand(
                m_logger.getCommand(PenCommand.ID),
                {
                    "type": PenCommand.BLEND_MODE,
                    "blendMode": value
                }
            );
        }
        
        public function set color(value:uint):void
        {
            commitCommand(
                m_logger.getCommand(PenCommand.ID),
                {
                    "type": PenCommand.COLOR,
                    "color": value
                }
            );
        }
        
        public function set thickness(value:uint):void
        {
            commitCommand(
                m_logger.getCommand(PenCommand.ID),
                {
                    "type": PenCommand.THICKNESS,
                    "thickness": value
                }
            );
        }
        
        public function set layerAlpha(value:Number):void
        {
            commitCommand(
                m_logger.getCommand(SetLayerAlphaCommand.ID),
                {
                    "alpha": value
                }
            );
        }
        
        public function set layerBlendMode(value:String):void
        {
            commitCommand(
                m_logger.getCommand(SetLayerBlendModeCommand.ID),
                {
                    "blendMode": value
                }
            );
        }
        
        public function set layerIndex(value:uint):void
        {
            commitCommand(
                m_logger.getCommand(SetLayerIndexCommand.ID),
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
        protected var m_logger:Logger;
        protected var m_drawing:Boolean;
        protected var m_drawingLine:Boolean;
    }
}