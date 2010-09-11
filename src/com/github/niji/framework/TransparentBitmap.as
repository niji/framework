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
package com.github.niji.framework
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    
    /**
     * 一番下に表示する透明画像の代替となるビットマップ画像のクラスです
     * 
     * @see flash.display.Bitmap
     */
    public final class TransparentBitmap extends Bitmap
    {
        /**
         * 透明画像として表示するための描画を予め行った状態で生成します
         *
         * @param rect 画像の幅及び高さを予め設定した Rectangle オブジェクト
         * @param pixelSnapping
         * @param smoothing
         */
        public function TransparentBitmap(rect:Rectangle, pixelSnapping:String = "auto", smoothing:Boolean = false)
        {
            var w:uint = rect.width;
            var h:uint = rect.height;
            var bitmapData:BitmapData = new BitmapData(w, h, false);
            bitmapData.lock();
            for (var i:uint = 0; i < w; i++) {
                for (var j:uint = 0; j < h; j++) {
                    bitmapData.setPixel(i, j, ((i ^ j) & 1) ? 0x999999 : 0xffffff);
                }
            }
            bitmapData.unlock();
            super(bitmapData, pixelSnapping, smoothing);
        }
    }
}
