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
    import org.libspark.gunyarapaint.framework.Pen;
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.FloodFillCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    /**
     * 透明塗りつぶし描写ツールの実装
     */
    public final class TransparentFloodFill extends CanvasModule implements ICanvasModule
    {
        public static const TRANSPARENT_FLOOD_FILL:String = PREFIX + "transparentFloodFill";
        
        public function TransparentFloodFill(recorder:Recorder)
        {
            super(recorder);
        }
        
        /**
         * @inheritDoc
         */
        public function start(x:Number, y:Number):void
        {
            var pen:Pen = m_recorder.pen;
            validateLayerState();
            m_alpha = pen.alpha;
            m_color = pen.color;
            alpha = 0;
            color = 0;
            m_recorder.commitCommand(
                MoveToCommand.ID,
                getArgumentsFromCoordinate(x, y)
            );
            m_recorder.commitCommand(
                FloodFillCommand.ID,
                {}
            );
        }
        
        /**
         * @inheritDoc
         */
        public function move(x:Number, y:Number):void
        {
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            alpha = m_alpha;
            color = m_color;
            saveCoordinate(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
            alpha = m_alpha;
            color = m_color;
        }
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return TRANSPARENT_FLOOD_FILL;
        }
        
        private var m_alpha:Number;
        private var m_color:uint;
    }
}