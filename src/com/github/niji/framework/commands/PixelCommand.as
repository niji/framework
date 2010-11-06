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
package com.github.niji.framework.commands
{
/// @endcond
    import com.github.niji.framework.Painter;
    
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
    /**
     * @private
     * 
     */
    public final class PixelCommand implements ICommand
    {
        public static const ID:uint = 23;
        
        public function PixelCommand()
        {
            reset();
        }
        
        public function read(bytes:IDataInput):void
        {
            m_x = Math.floor(bytes.readShort());
            m_y = Math.floor(bytes.readShort());
        }
        
        public function write(bytes:IDataOutput, args:Object):void
        {
            var x:int = Math.floor(args.x);
            var y:int = Math.floor(args.y);
            bytes.writeByte(commandID);
            bytes.writeShort(x);
            bytes.writeShort(y);
            m_x = x;
            m_y = y;
        }
        
        public function execute(painter:Painter):void
        {
            painter.setPixel(m_x, m_y);
            painter.pushUndo();
        }
        
        public function reset():void
        {
            m_x = 0;
            m_y = 0;
        }
        
        public function toString():String
        {
            return "[PixelCommand"
                + " x=" + m_x
                + ", y=" + m_y
                + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_x:int;
        private var m_y:int;
    }
}