package org.libspark.gunyarapaint.framework
{
    import flash.display.Shape;
    import flash.geom.Point;

    internal final class PaintEngineV1 extends PaintEngine
    {
        public function PaintEngineV1(shape:Shape)
        {
            super(shape);
        }
        
        public override function correctCoordinate(coordinate:Point):void
        {
            coordinate.x = int(coordinate.x + 0.5);
            coordinate.y = int(coordinate.y + 0.5);
        }
    }
}
