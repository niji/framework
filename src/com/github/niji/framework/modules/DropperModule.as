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
package com.github.niji.framework.modules
{
    import com.github.niji.framework.Recorder;
    import com.github.niji.framework.commands.PenCommand;
    
    /**
     * スポイトツールの実装
     */ 
    public final class DropperModule extends CanvasModule implements ICanvasModule
    {
        public static const DROPPER:String = PREFIX + "dropper";
        
        public function DropperModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        /**
         * @inheritDoc
         */
        public function start(x:Number, y:Number):void
        {
            drop(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function move(x:Number, y:Number):void
        {
            drop(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            drop(x, y);
            saveCoordinate(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function interrupt(x:Number, y:Number):void
        {
        }
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return DROPPER;
        }
        
        private function drop(x:Number, y:Number):void
        {
            var color:uint = m_recorder.getPixel(x, y);
            if (m_recorder.pen.color != color) {
                m_recorder.commitCommand(
                    PenCommand.ID,
                    {
                        "type": PenCommand.COLOR,
                        "color": m_recorder.getPixel(x, y)
                    }
                );
            }
        }
    }
}