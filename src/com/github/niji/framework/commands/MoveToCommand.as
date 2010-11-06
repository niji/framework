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
    public final class MoveToCommand extends LineCommand implements ICommand
    {
        public static const ID:uint = 1;
        
        public function MoveToCommand()
        {
            super();
        }
        
        public function read(bytes:IDataInput):void
        {
            var x:int = 0;
            var y:int = 0;
            if (m_compressedValue) {
                var short:uint = (m_compressedValue & 0xff) << 8 | bytes.readUnsignedByte();
                x = (short << 18) >> 25;
                y = (short << 25) >> 25;
                m_compressedValue = 0;
            }
            else {
                x = bytes.readShort();
                y = bytes.readShort();
            }
            s_readCoordinateX += x;
            s_readCoordinateY += y;
        }
        
        public function write(bytes:IDataOutput, args:Object):void
        {
            var dx:int = args.x - s_writeCoordinateX;
            var dy:int = args.y - s_writeCoordinateY;
            if (dx >= -64 && dx <= 63 && dy >= -64 && dy <= 63) {
                // dxもdyも7bitに収まる場合
                bytes.writeShort(0x4000 | (dx << 7) & 0x3f80 | dy & 0x7f);
            }
            else {
                bytes.writeByte(commandID);
                bytes.writeShort(dx);
                bytes.writeShort(dy);
            }
            s_writeCoordinateX = args.x;
            s_writeCoordinateY = args.y;
        }
        
        public function execute(painter:Painter):void
        {
            painter.moveTo(
                s_readCoordinateX || s_writeCoordinateX,
                s_readCoordinateY || s_writeCoordinateY
            );
            painter.startDrawing();
        }
        
        public function toString():String
        {
            return "[MoveToCommand"
                + " x=" + (s_readCoordinateX || s_writeCoordinateX)
                + ", y=" + (s_readCoordinateY || s_writeCoordinateY)
                + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}
