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
    
    import flash.errors.IllegalOperationError;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
    /**
     * @private
     * 
     */
    public final class CompatibilityCommand implements ICommand
    {
        public static const ID:uint = 29;
        
        public function CompatibilityCommand()
        {
            reset();
        }
        
        public function read(bytes:IDataInput):void
        {
            m_type = bytes.readUnsignedByte();
            m_value = bytes.readBoolean();
        }
        
        public function write(bytes:IDataOutput, args:Object):void
        {
            var type:uint = args.type;
            var value:Boolean = args.value;
            bytes.writeByte(commandID);
            bytes.writeByte(type);
            bytes.writeBoolean(value);
            m_type = type;
            m_value = value;
        }
        
        public function execute(painter:Painter):void
        {
            switch (m_type) {
                case Painter.COMPATIBILITY_UNDO_LAYER:
                    painter.enableUndoLayer = m_value;
                    break;
                case Painter.COMPATIBILITY_BIG_PIXEL:
                    painter.enableBigPixel = m_value;
                    break;
                default:
                    throw new ArgumentError();
                    break;
            }
        }
        
        public function reset():void
        {
            m_type = 0;
            m_value = false;
        }
        
        public function toString():String
        {
            var ret:String = "[CompatibilityCommand ";
            switch (m_type) {
                case Painter.COMPATIBILITY_UNDO_LAYER:
                    ret += "undoLayer=";
                    break;
                case Painter.COMPATIBILITY_BIG_PIXEL:
                    ret += "bigPixel=";
                    break;
                default:
                    throw new IllegalOperationError();
            }
            ret += m_value + "]";
            return ret;
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_type:uint;
        private var m_value:Boolean;
    }
}
