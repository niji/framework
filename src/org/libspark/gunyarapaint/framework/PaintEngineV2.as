package org.libspark.gunyarapaint.framework
{
    import flash.display.Shape;
    import flash.geom.Point;

    internal final class PaintEngineV2 extends PaintEngine
    {
        public function PaintEngineV2(shape:Shape)
        {
            super(shape);
        }
        
        public override function correctCoordinate(coordinate:Point):void
        {
            var aux:Number = (pen.thickness % 2) ? 0.5 : 0;
            coordinate.x = int(coordinate.x) + aux;
            coordinate.y = int(coordinate.y) + aux;
        }
    }
}
