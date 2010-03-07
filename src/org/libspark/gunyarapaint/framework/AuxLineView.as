package org.libspark.gunyarapaint.framework
{
    import flash.display.Graphics;
    import flash.geom.Rectangle;
    
    /**
     * 分割して表示する補助線のオブジェクト
     * 
     */
    public final class AuxLineView extends AuxBitmap
    {
        public function AuxLineView(rect:Rectangle)
        {
            super(rect);
        }
        
        public override function divide():void
        {
            var box:Graphics = m_box.graphics;
            var skew:Graphics = m_skew.graphics;
            var w:Number = m_rect.width;
            var h:Number = m_rect.height;
            var sw:Number = w / m_divideCount;
            var sh:Number = h / m_divideCount;
            for (var i:uint = 0; i < m_divideCount; i++) {
                if (i > 0) {
                    box.moveTo(i * sw, 0);
                    box.lineTo(i * sw, h);
                    box.moveTo(0, i * sh);
                    box.lineTo(w, i * sh);
                    skew.moveTo(i * sh, 0);
                    skew.lineTo(0, i * sh);
                    skew.moveTo(w - (i * sw), 0);
                    skew.lineTo(w, i * sh);
                }
                skew.moveTo(w - ((i + 1) * sw), h);
                skew.lineTo(h, h - ((i + 1) * sh));
                skew.moveTo((i + 1) * sw, h);
                skew.lineTo(0, h - ((i + 1) * sh));
            }
        }
    }
}