package org.libspark.gunyarapaint.framework
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    
    public final class TransparentBitmap extends Bitmap
    {
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
