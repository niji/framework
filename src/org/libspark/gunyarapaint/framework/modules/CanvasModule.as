/*
    Copyright (c) 2008-2010, tasukuchan, hikarincl2
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name of the <organization> nor the
          names of its contributors may be used to endorse or promote products
          derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
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

    /**
     * ICanvasModuleの実装を助けるためのクラスです.
     * 
     * <p>
     * 大半の処理はここに集約されているため、
     * 基本的にすべてのメソッドを1から実装する必要はありません。
     * </p>
     */
    public class CanvasModule
    {
        internal static const PREFIX:String = "org.libspark.gunyarapaint.framework.modules.";
        
        public function CanvasModule(recorder:Recorder)
        {
            m_recorder = recorder;
        }
        
        /**
         * @copy ICanvasModule#load()
         */
        public function load():void
        {
        }
        
        /**
         * @copy ICanvasModule#unload()
         */
        public function unload():void
        {
        }
        
        /**
         * @copy ICanvasModule#undo()
         */
        public function undo():void
        {
            m_recorder.commitCommand(UndoCommand.ID, {});
        }
        
        /**
         * @copy ICanvasModule#redo()
         */
        public function redo():void
        {
            m_recorder.commitCommand(RedoCommand.ID, {});
        }
        
        /**
         * @copy ICanvasModule#horizontalMirror()
         */
        public function horizontalMirror(index:uint):void
        {
            m_recorder.commitCommand(
                HorizontalMirrorCommand.ID,
                {
                    "index": index
                }
            );
        }
        
        /**
         * @copy ICanvasModule#verticalMirror()
         */
        public function verticalMirror(index:uint):void
        {
            m_recorder.commitCommand(
                VerticalMirrorCommand.ID,
                {
                    "index": index
                }
            );
        }
        
        /**
         * @copy ICanvasModule#copyLayer()
         */
        public function copyLayer():void
        {
            m_recorder.commitCommand(
                CopyLayerCommand.ID,
                {}
            );
        }
        
        /**
         * @copy ICanvasModule#createLayer()
         */
        public function createLayer():void
        {
            m_recorder.commitCommand(
                CreateLayerCommand.ID,
                {}
            );
        }
        
        /**
         * @copy ICanvasModule#mergeLayers()
         */
        public function mergeLayers():void
        {
            m_recorder.commitCommand(
                MergeLayerCommand.ID,
                {}
            );
        }
        
        /**
         * @copy ICanvasModule#removeLayer()
         */
        public function removeLayer():void
        {
            m_recorder.commitCommand(
                RemoveLayerCommand.ID,
                {}
            );
        }
        
        /**
         * @copy ICanvasModule#swapLayers()
         */
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
         * @copy ICanvasModule#setCompatibility()
         */
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
        
        /**
         * @copy ICanvasModule#reset()
         */
        public function reset():void
        {
            m_recorder.commitCommand(ResetAllCommand.ID, {});
        }
        
        /**
         * @copy ICanvasModule#getPixel32()
         */
        public function getPixel32(x:int, y:int):uint
        {
            return m_recorder.getPixel32(x, y);
        }
        
        /**
         * 始点と終点を取得します(現在は単体テスト用に使われているのみ)
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
         * 始点と終点の座標を保存します
         * 
         * @param x 終点となるX座標
         * @param y 終点となるY座標
         */
        protected function saveCoordinate(x:Number, y:Number):void
        {
            s_startPointX = s_coordinateX;
            s_startPointY = s_coordinateY;
            s_endPointX = x;
            s_endPointY = y;
        }
        
        /**
         * 現在のレイヤーの状態を検証します
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
         * 現在の座標を設定します
         * 
         * @param x X座標
         * @param y Y座標
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
         * 指定された座標が現在の座標と一致するかを確認します
         * 
         * @param x X座標
         * @param y Y座標
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
         * 現在の座標から ICommand#write に渡す引数に変換します
         */
        protected function getArgumentsFromCurrentCoordinate():Object
        {
            return getArgumentsFromCoordinate(s_coordinateX, s_coordinateY);
        }
        
        /**
         * 指定された座標から ICommand#write に渡す引数に変換します
         * 
         * @param x X座標
         * @param y Y座標
         * @return args プロパティXとYで構成されるオブジェクト
         */
        protected function getArgumentsFromCoordinate(x:Number, y:Number):Object
        {
            var args:Object = {
                "x": x,
                "y": y
            };
            return args;
        }
        
        /**
         * 描写処理を終了します
         */
        protected function stopDrawing():void
        {
            m_recorder.stopDrawing();
        }
        
        /**
         * @copy ICanvasModule#shouldDrawCircleClockwise
         */
        public function set shouldDrawCircleClockwise(value:Boolean):void
        {
            s_shouldDrawCircleClockwise = value;
        }
        
        /**
         * @copy ICanvasModule#shouldDrawCircleCounterClockwise
         */
        public function set shouldDrawCircleCounterClockwise(value:Boolean):void
        {
            s_shouldDrawCircleCounterClockwise = value;
        }
        
        /**
         * @copy ICanvasModule#shouldDrawFromStartPoint
         */
        public function set shouldDrawFromStartPoint(value:Boolean):void
        {
            s_shouldDrawFromStartPoint = value;
        }
        
        /**
         * @copy ICanvasModule#shouldDrawFromEndPoint
         */
        public function set shouldDrawFromEndPoint(value:Boolean):void
        {
            s_shouldDrawFromEndPoint = value;
        }
        
        /**
         * @copy ICanvasModule#alpha
         */
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
        
        /**
         * @copy ICanvasModule#blendMode
         */
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
        
        /**
         * @copy ICanvasModule#color
         */
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
        
        /**
         * @copy ICanvasModule#thickness
         */
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
        
        /**
         * @copy ICanvasModule#layerAlpha
         */
        public function set layerAlpha(value:Number):void
        {
            m_recorder.commitCommand(
                SetLayerAlphaCommand.ID,
                {
                    "alpha": value
                }
            );
        }
        
        /**
         * @copy ICanvasModule#layerBlendMode
         */
        public function set layerBlendMode(value:String):void
        {
            m_recorder.commitCommand(
                SetLayerBlendModeCommand.ID,
                {
                    "blendMode": value
                }
            );
        }
        
        /**
         * @copy ICanvasModule#layerIndex
         */
        public function set layerIndex(value:uint):void
        {
            m_recorder.commitCommand(
                SetLayerIndexCommand.ID,
                {
                    "index": value
                }
            );
        }
        
        /**
         * 現在のX座標を取得します.
         * 
         * <p>
         * 内部は静的変数であるため、CanvasModuleを継承する全てのクラスに影響します
         * </p>
         */
        protected function get coordinateX():Number
        {
            return s_coordinateX;
        }
        
        /**
         * 現在のY座標を取得します.
         * 
         * <p>
         * 内部は静的変数であるため、CanvasModuleを継承する全てのクラスに影響します
         * </p>
         */
        protected function get coordinateY():Number
        {
            return s_coordinateY;
        }
        
        /**
         * 現在時計回りに描写しているかを取得します
         */
        protected function getShouldDrawCircleClockwise():Boolean
        {
            return s_shouldDrawCircleClockwise;
        }
        
        /**
         * 現在反時計回りで描写しているかを取得します
         */
        protected function getShouldDrawCircleCounterClockwise():Boolean
        {
            return s_shouldDrawCircleCounterClockwise;
        }
        
        /**
         * @private
         */
        protected var m_recorder:Recorder;
        
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
    }
}
