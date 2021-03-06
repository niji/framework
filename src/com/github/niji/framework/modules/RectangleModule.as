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
/// @cond
package com.github.niji.framework.modules
{
    /// @endcond
    import com.github.niji.framework.Recorder;
    import com.github.niji.framework.commands.CompositeCommand;
    import com.github.niji.framework.commands.DrawRectangleCommand;
    import com.github.niji.framework.commands.MoveToCommand;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    /**
     * 矩形描写ツールの実装
     */
    public final class RectangleModule extends CanvasModule implements ICanvasModule
    {
        public static const RECTANGLE:String = PREFIX + "rectangle";
        
        public function RectangleModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        /**
         * @inheritDoc
         */
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_recorder.startDrawing();
        }
        
        /**
         * @inheritDoc
         */
        public function move(x:Number, y:Number):void
        {
            var width:int = Math.floor(x - coordinateX);
            var height:int = Math.floor(y - coordinateY);
            m_recorder.clear();
            m_recorder.resetPen();
            m_recorder.moveTo(coordinateX, coordinateY);
            m_recorder.drawRect(width, height);
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            m_recorder.stopDrawing();
            if (!equalsCoordinate(x, y)) {
                var width:int = Math.floor(x - coordinateX);
                var height:int = Math.floor(y - coordinateY);
                m_recorder.commitCommand(
                    MoveToCommand.ID,
                    getArgumentsFromCoordinate(coordinateX, coordinateY)
                );
                m_recorder.commitCommand(
                    DrawRectangleCommand.ID,
                    { "width": width, "height": height }
                );
                m_recorder.commitCommand(
                    CompositeCommand.ID,
                    {}
                );
            }
            saveCoordinate(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
        }
        
        /**
         * 現在の矩形の大きさを取得します
         * 
         * @return Rectangle
         */
        public function getRectangle(x:Number, y:Number):Rectangle
        {
            if (m_recorder.isDrawing()) {
                var width:int = Math.floor(x - coordinateX);
                var height:int = Math.floor(y - coordinateY);
                return new Rectangle(0, 0, width, height);
            }
            else {
                return new Rectangle();
            }
        }
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return RECTANGLE;
        }
    }
}