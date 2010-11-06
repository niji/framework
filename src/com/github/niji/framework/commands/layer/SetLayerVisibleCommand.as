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
package com.github.niji.framework.commands.layer
{
/// @endcond
    import com.github.niji.framework.Painter;
    import com.github.niji.framework.commands.ICommand;
    
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
    /**
     * @private
     * 
     */
    public final class SetLayerVisibleCommand implements ICommand
    {
        public static const ID:uint = 20;
        
        public function SetLayerVisibleCommand()
        {
            reset();
        }
        
        public function read(bytes:IDataInput):void
        {
            m_index = bytes.readUnsignedByte();
            m_visible = bytes.readBoolean();
        }
        
        public function write(bytes:IDataOutput, args:Object):void
        {
            var index:int = args.index;
            var visible:Boolean = args.visible;
            bytes.writeByte(commandID);
            bytes.writeByte(index);
            bytes.writeBoolean(visible);
            m_index = index;
            m_visible = visible;
        }
        
        public function execute(painter:Painter):void
        {
            painter.setVisibleAt(m_index, m_visible);
        }
        
        public function reset():void
        {
            m_index = 0;
            m_visible = true;
        }
        
        public function toString():String
        {
            return "[SetLayerVisibleCommand"
                + " index=" + m_index
                + ", visible=" + m_visible
                + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_index:uint;
        private var m_visible:Boolean;
    }
}