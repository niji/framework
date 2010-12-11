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
package com.github.niji.framework.aux
{
/// @endcond
    import flash.display.Graphics;
    import flash.geom.Rectangle;
    
    /**
     * 分割して表示する補助線のオブジェクト
     * 
     * @see AuxBitmap
     */
    public final class AuxLineView extends AuxBitmap
    {
        /**
         * 直線及び斜線を予め引いて、非表示にした状態で補助線画像を生成します
         */
        public function AuxLineView(rect:Rectangle)
        {
            super(rect);
        }
        
        /**
         * @inheritDoc
         */
        public override function divide():void
        {
            var box:Graphics = m_box.graphics;
            var skew:Graphics = m_skew.graphics;
            var width:Number = m_rect.width;
            var height:Number = m_rect.height;
            var sw:Number = width / m_divideCount;
            var sh:Number = height / m_divideCount;
            for (var i:uint = 0; i < m_divideCount; i++) {
                if (i > 0) {
                    box.moveTo(i * sw, 0);
                    box.lineTo(i * sw, height);
                    box.moveTo(0, i * sh);
                    box.lineTo(width, i * sh);
                    skew.moveTo(i * sw, 0);
                    skew.lineTo(0, i * sh);
                    skew.moveTo(width - (i * sw), 0);
                    skew.lineTo(width, i * sh);
                }
                skew.moveTo(width - ((i + 1) * sw), height);
                skew.lineTo(width, height - ((i + 1) * sh));
                skew.moveTo((i + 1) * sw, height);
                skew.lineTo(0, height - ((i + 1) * sh));
            }
        }
    }
}
