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
package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * @private
     * 
     */
    public final class BezierCurveCommand implements ICommand
    {
        public static const ID:uint = 28;
        
        public function BezierCurveCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_anchorX = bytes.readShort();
            m_anchorY = bytes.readShort();
            m_controlX = bytes.readShort();
            m_controlY = bytes.readShort();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var anchorX:int = args.anchorX;
            var anchorY:int = args.anchorY;
            var controlX:int = args.controlX;
            var controlY:int = args.controlY;
            bytes.writeByte(commandID);
            bytes.writeShort(anchorX);
            bytes.writeShort(anchorY);
            bytes.writeShort(controlX);
            bytes.writeShort(controlY);
            m_anchorX = anchorX;
            m_anchorY = anchorY;
            m_controlX = controlX;
            m_controlY = controlY;
        }
        
        public function execute(painter:Painter):void
        {
            // TODO: implement this
        }
        
        public function reset():void
        {
            m_anchorX = 0;
            m_anchorY = 0;
            m_controlX = 0;
            m_controlY = 0;
        }
        
        public function toString():String
        {
            return "[BezierCurveCommand"
                + " anchorX=" + m_anchorX
                + ", anchorY=" + m_anchorY
                + ", controlX=" + m_controlX
                + ", controlY=" + m_controlY
                + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_anchorX:int;
        private var m_anchorY:int;
        private var m_controlX:int;
        private var m_controlY:int;
    }
}
