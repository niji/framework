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
    import com.github.niji.framework.Pen;
    import com.github.niji.framework.Recorder;
    import com.github.niji.framework.commands.CompositeCommand;
    import com.github.niji.framework.commands.LineToCommand;
    import com.github.niji.framework.commands.MoveToCommand;
    
    import flash.display.BlendMode;
    
    /**
     * 透明直線描写ツールの実装
     */
    public final class TransparentLineModule extends CanvasModule implements ICanvasModule
    {
        public static const TRANSPARENT_LINE:String = PREFIX + "transparentLine";
        
        public function TransparentLineModule(recorder:Recorder)
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
            var pen:Pen = m_recorder.pen;
            var blendMode:String = pen.blendMode;
            pen.blendMode = BlendMode.ERASE;
            m_recorder.clear();
            m_recorder.resetPen();
            m_recorder.moveTo(coordinateX, coordinateY);
            m_recorder.lineTo(x, y);
            pen.blendMode = blendMode;
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            var pen:Pen = m_recorder.pen;
            var currentBlendMode:String = pen.blendMode;
            m_recorder.stopDrawing();
            if (!equalsCoordinate(x, y)) {
                var from:Object = getArgumentsFromCurrentCoordinate();
                var to:Object = getArgumentsFromCoordinate(x, y);
                blendMode = BlendMode.ERASE;
                m_recorder.commitCommand(MoveToCommand.ID, from);
                m_recorder.commitCommand(LineToCommand.ID, to);
                m_recorder.commitCommand(CompositeCommand.ID, {});
                blendMode = currentBlendMode;
            }
            pen.blendMode = currentBlendMode;
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
         * @inheritDoc
         */
        public function get name():String
        {
            return TRANSPARENT_LINE;
        }
    }
}
