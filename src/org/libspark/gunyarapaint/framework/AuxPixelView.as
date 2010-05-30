package org.libspark.gunyarapaint.framework
{
    import flash.display.Graphics;
    import flash.geom.Rectangle;
    
    /**
     * ピクセル単位で表示する補助線のオブジェクト
     * 
     */
    public final class AuxPixelView extends AuxBitmap
    {
        public function AuxPixelView(rect:Rectangle)
        {
            super(rect);
        }
        
        public override function divide():void
        {
            var box:Graphics = m_box.graphics;
            var skew:Graphics = m_skew.graphics;
            var i:uint = 0;
			// 縦線を描く
            for (i = m_divideCount; i < width; i += m_divideCount) {
                box.moveTo(i, 0);
                box.lineTo(i, height);
            }
			// 横線を描く
            for (i = m_divideCount; i < height; i += m_divideCount) {
                box.moveTo(0, i);
                box.lineTo(width, i);
            }
            var max:uint = (m_rect.width > m_rect.height) ? m_rect.width : m_rect.height;
            max += m_divideCount - (max % m_divideCount);
            for (i = m_divideCount; i <= max; i += m_divideCount) {
                skew.moveTo(i - m_divideCount, 0);
                skew.lineTo(0, i - m_divideCount);
                skew.moveTo(max - (i - m_divideCount), 0);
                skew.lineTo(max, i - m_divideCount);
                skew.moveTo(max, max - i);
                skew.lineTo(max - i, max);
                skew.moveTo(0, max - i);
                skew.lineTo(i, max);
            }
            m_skew.scrollRect = m_rect;
        }
    }
}
