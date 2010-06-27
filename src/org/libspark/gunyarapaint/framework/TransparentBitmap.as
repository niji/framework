package org.libspark.gunyarapaint.framework
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
