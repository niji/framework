package org.libspark.gunyarapaint.framework.test
{
    import flash.display.BlendMode;
    import flash.geom.Point;
    
    import org.libspark.gunyarapaint.framework.PaintEngine;
    import org.libspark.gunyarapaint.framework.Painter;
    
    public class FakePainter extends Painter
    {
        public function FakePainter(width:int, height:int, engine:PaintEngine)
        {
            super(width, height, engine);
            m_layers = new FakeLayerBitmapCollection(width, height);
            didComposite = false;
            didFloodFill = false;
            didStartDrawing = false;
            didEndDrawing = false;
            coordinate = new Point();
            layerIndex = 0;
            layerVisible = true;
            layerAlpha = 0.0;
            layerBlendMode = BlendMode.NORMAL;
        }
        
        public override function composite():void
        {
            didComposite = true;
        }
        
        public override function floodFill():void
        {
            didFloodFill = true;
        }
        
        public override function setPixel(x:int, y:int):void
        {
            coordinate = new Point(x, y);
        }
        
        public override function setVisibleAt(index:int, visible:Boolean):void
        {
            layerIndex = index;
            layerVisible = visible;
        }
        
        public override function transformWithHorizontalMirrorAt(index:int):void
        {
            layerIndex = index;
        }
        
        public override function transformWithVerticalMirrorAt(index:int):void
        {
            layerIndex = index;
        }
        
        public override function startDrawingSession():void
        {
            didStartDrawing = true;
        }
        
        public override function stopDrawingSession():void
        {
            didEndDrawing = true;
        }
        
        public override function set currentLayerAlpha(alpha:Number):void
        {
            layerAlpha = alpha;
        }
        
        public override function set currentLayerBlendMode(blendMode:String):void
        {
            layerBlendMode = blendMode;
        }
        
        public static var didComposite:Boolean;
        public static var didFloodFill:Boolean;
        public static var coordinate:Point;
        public static var layerIndex:int;
        public static var layerVisible:Boolean;
        public static var didStartDrawing:Boolean;
        public static var didEndDrawing:Boolean;
        public static var layerAlpha:Number;
        public static var layerBlendMode:String;
    }
}