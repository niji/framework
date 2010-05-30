package org.libspark.gunyarapaint.framework
{
    import flash.display.Shape;
    import flash.geom.Point;
	
	/**
	 * @private
	 * 
	 * ログのバージョンが 0.2.1 から使用されるペイントエンジン
	 */
    internal final class PaintEngineV2 extends PaintEngine
    {
        public function PaintEngineV2(shape:Shape)
        {
            super(shape);
        }
        
        public override function correctCoordinate(coordinate:Point):void
        {
            var aux:Number = pen.thickness & 1 ? 0.5 : 0;
            var x:Number = coordinate.x;
            var y:Number = coordinate.y;
            coordinate.x = (x >= 0 ? int(x) : Math.floor(x)) + aux;
            coordinate.y = (y >= 0 ? int(y) : Math.floor(y)) + aux;
        }
    }
}
