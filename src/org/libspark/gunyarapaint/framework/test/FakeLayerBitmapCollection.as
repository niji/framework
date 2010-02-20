package org.libspark.gunyarapaint.framework.test
{
    import flash.display.BitmapData;
    
    import org.libspark.gunyarapaint.framework.LayerBitmap;
    import org.libspark.gunyarapaint.framework.LayerBitmapCollection;
    
    public class FakeLayerBitmapCollection extends LayerBitmapCollection
    {
        public function FakeLayerBitmapCollection(width:int, height:int)
        {
            super(width, height);
            didAddLayer = false;
            didCopyLayer = false;
            didSwapLayerFrom = 0;
            didSwapLayerTo = 0;
            didMergeLayer = false;
            didRemoveLayer = false;
            layerBitmap = new LayerBitmap(new BitmapData(1, 1));
        }
        
        public override function add():void
        {
            didAddLayer = true;
        }
        
        public override function copy():void
        {
            didCopyLayer = true;
        }
        
        public override function swap(from:int, to:int):void
        {
            didSwapLayerFrom = from;
            didSwapLayerTo = to;
        }
        
        public override function merge():void
        {
            didMergeLayer = true;
        }
        
        public override function remove():void
        {
            didRemoveLayer = true;
        }
        
        public override function get currentLayer():LayerBitmap
        {
            return layerBitmap;
        }
        
        public static var didAddLayer:Boolean;
        public static var didCopyLayer:Boolean;
        public static var didSwapLayerFrom:uint;
        public static var didSwapLayerTo:uint;
        public static var didMergeLayer:Boolean;
        public static var didRemoveLayer:Boolean;
        public static var layerBitmap:LayerBitmap;
    }
}