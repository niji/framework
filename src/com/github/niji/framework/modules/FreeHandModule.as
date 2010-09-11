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
    import com.github.niji.framework.Pen;
    import com.github.niji.framework.Recorder;
    import com.github.niji.framework.commands.BeginFillCommand;
    import com.github.niji.framework.commands.CompositeCommand;
    import com.github.niji.framework.commands.DrawCircleCommand;
    import com.github.niji.framework.commands.EndFillCommand;
    import com.github.niji.framework.commands.LineToCommand;
    import com.github.niji.framework.commands.MoveToCommand;
    import com.github.niji.framework.commands.PenCommand;
    
    /**
     * 手描きツールの実装
     */
    public final class FreeHandModule extends CanvasModule implements ICanvasModule
    {
        public static const FREE_HAND:String = PREFIX + "freeHand";
        
        public function FreeHandModule(recorder:Recorder)
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
            m_recorder.commitCommand(
                MoveToCommand.ID,
                getArgumentsFromCoordinate(x, y)
            );
            m_drawedLine = false;
        }
        
        /**
         * @inheritDoc
         */
        public function move(x:Number, y:Number):void
        {
            m_recorder.commitCommand(
                LineToCommand.ID,
                getArgumentsFromCoordinate(x, y)
            );
            m_drawedLine = true;
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            if (!m_drawedLine) {
                var pen:Pen = m_recorder.pen;
                var tempAlpha:Number = pen.alpha;
                m_recorder.commitCommand(
                    PenCommand.ID,
                    {
                        "type": PenCommand.ALPHA,
                        "alpha": 0
                    }
                );
                m_recorder.commitCommand(
                    BeginFillCommand.ID,
                    {
                        "color": pen.color,
                        "alpha": tempAlpha
                    }
                );
                m_recorder.commitCommand(
                    DrawCircleCommand.ID,
                    { "radius": pen.thickness / 2 }
                );
                m_recorder.commitCommand(EndFillCommand.ID, {});
                m_recorder.commitCommand(
                    PenCommand.ID,
                    {
                        "type": PenCommand.ALPHA,
                        "alpha": tempAlpha
                    }
                );
            }
            m_recorder.commitCommand(
                CompositeCommand.ID,
                {}
            );
            saveCoordinate(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function interrupt(x:Number, y:Number):void
        {
            move(x, y);
            stop(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return FREE_HAND;
        }
        
        private var m_drawedLine:Boolean;
    }
}