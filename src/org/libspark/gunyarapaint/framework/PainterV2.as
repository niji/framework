package org.libspark.gunyarapaint.framework
{
    internal final class PainterV2 extends Painter
    {
        public function PainterV2(width:int, height:int, engine:PaintEngine)
        {
            super(width, height, engine);
        }
        
        public override function roundPixel(n:Number):Number
        {
            return int(n + 0.5);
        }
    }
}