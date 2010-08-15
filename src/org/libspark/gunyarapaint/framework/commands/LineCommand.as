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
    import flash.geom.Point;
    
    /**
     * @private
     * 
     */
    internal class LineCommand
    {
        public function LineCommand()
        {
            reset();
        }
        
        public function reset():void
        {
            m_compressedValue = 0;
            resetCoordinates();
        }
        
        public static function resetCoordinates():void
        {
            s_readCoordinateX = 0;
            s_readCoordinateY = 0;
            s_writeCoordinateX = 0;
            s_writeCoordinateY = 0;
        }
        
        public function set compressedValue(value:int):void
        {
            m_compressedValue = value;
        }
        
        protected static var s_readCoordinateX:int;
        protected static var s_readCoordinateY:int;
        protected static var s_writeCoordinateX:int;
        protected static var s_writeCoordinateY:int;
        protected var m_compressedValue:uint;
    }
}
