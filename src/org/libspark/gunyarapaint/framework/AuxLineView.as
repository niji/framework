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
