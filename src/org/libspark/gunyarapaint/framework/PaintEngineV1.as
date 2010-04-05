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
            var x:Number = coordinate.x;
            var y:Number = coordinate.y;
            coordinate.x = x >= 0 ? int(x + 0.5) : Math.floor(x + 0.5);
            coordinate.y = y >= 0 ? int(y + 0.5) : Math.floor(y + 0.5);
        }
    }
}
