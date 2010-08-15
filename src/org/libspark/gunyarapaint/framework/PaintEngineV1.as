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
package org.libspark.gunyarapaint.framework
{
    import flash.display.Shape;
    import flash.geom.Point;
	
	/**
	 * @private
	 * 
	 * ログのバージョンが 0.0.2 から 0.2.0 で使用されるペイントエンジン。
	 * 位置補正のアルゴリズムが異なっているが、現在となっては間違いとされている
	 */
    internal final class PaintEngineV1 extends PaintEngine
    {
        /**
         * @inheritDoc
         */
        public function PaintEngineV1(shape:Shape)
        {
            super(shape);
        }
        
        /**
         * @inheritDoc
         */
        public override function correctCoordinate(coordinate:Point):void
        {
            var x:Number = coordinate.x;
            var y:Number = coordinate.y;
            coordinate.x = x >= 0 ? int(x + 0.5) : Math.floor(x + 0.5);
            coordinate.y = y >= 0 ? int(y + 0.5) : Math.floor(y + 0.5);
        }
    }
}
