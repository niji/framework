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
package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
    public final class SwapLayerCommand implements ICommand
    {
        public static const ID:uint = 16;
        
        public function SwapLayerCommand()
        {
            reset();
        }
        
        public function read(bytes:IDataInput):void
        {
            m_from = bytes.readUnsignedByte();
            m_to = bytes.readUnsignedByte();
        }
        
        public function write(bytes:IDataOutput, args:Object):void
        {
            var from:int = args.from;
            var to:int = args.to;
            bytes.writeByte(commandID);
            bytes.writeByte(from);
            bytes.writeByte(to);
            m_from = from;
            m_to = to;
        }
        
        public function execute(painter:Painter):void
        {
            painter.layers.swap(m_from, m_to);
            painter.pushUndo();
        }
        
        public function reset():void
        {
            m_from = 0;
            m_to = 0;
        }
        
        public function toString():String
        {
            return "[SwapLayerCommand"
                + " from=" + m_from
                + ", to=" + m_to
                + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_from:int;
        private var m_to:int;
    }
}