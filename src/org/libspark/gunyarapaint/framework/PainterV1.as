package org.libspark.gunyarapaint.framework
{
    internal final class PainterV1 extends Painter
    {
        public function PainterV1(width:int, height:int, engine:PaintEngine)
        {
            super(width, height, engine);
        }
        
        public override function roundPixel(n:Number):Number
        {
            return int(n) + ((m_paintEngine.pen.thickness % 2) ? 0.5 : 0);
        }
    }
}