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
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
    public final class SetLayerAlphaCommand implements ICommand
    {
        public static const ID:uint = 22;
        
        public function SetLayerAlphaCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_alpha = bytes.readDouble();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var alpha:Number = args.alpha;
            if (m_alpha !== alpha) {
                bytes.writeByte(commandID);
                bytes.writeDouble(alpha);
                m_alpha = alpha;
            }
        }
        
        public function execute(painter:Painter):void
        {
            painter.currentLayerAlpha = m_alpha;
            painter.pushUndo();
        }
        
        public function reset():void
        {
            m_alpha = 0;
        }
        
        public function toString():String
        {
            return "[SetLayerAlphaCommand"
                + " alpha=" + m_alpha.toPrecision(4)
                + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_alpha:Number;
    }
}