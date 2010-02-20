package org.libspark.gunyarapaint.framework.test
{
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.LayerBitmap;

    public class LayerBitmapTest
    {
        [Test]
        public function レイヤーの作成():void
        {
            var layer:LayerBitmap = new LayerBitmap(smallBitmapData);
            Assert.assertTrue(layer is LayerBitmap);
        }
        
        [Test]
        public function レイヤーのクローン():void
        {
            var layer:LayerBitmap = layerToClone;
            var newLayer:LayerBitmap = layer.clone();
            Assert.assertStrictlyEquals(newLayer.alpha, layer.alpha);
            Assert.assertStrictlyEquals(newLayer.blendMode, layer.blendMode);
            Assert.assertStrictlyEquals(newLayer.index, layer.index);
            Assert.assertStrictlyEquals(newLayer.name, layer.name);
            Assert.assertStrictlyEquals(newLayer.visible, layer.visible);
        }
        
        [Test]
        public function 塗りつぶし():void
        {
            var bmd:BitmapData = bigBitmapData;
            var layer:LayerBitmap = new LayerBitmap(bmd);
            layer.floodFill(5, 5, 0);
            Assert.assertStrictlyEquals(0, bmd.getPixel32(5, 5));
            Assert.assertStrictlyEquals(0, bmd.getPixel32(0, 0));
        }
        
        [Test]
        public function ドットうち():void
        {
            var bmd:BitmapData = bigBitmapData;
            var layer:LayerBitmap = new LayerBitmap(bmd);
            layer.setPixel(5, 5, 0);
            Assert.assertStrictlyEquals(0, bmd.getPixel32(5, 5));
            Assert.assertStrictlyEquals(uint.MAX_VALUE, bmd.getPixel32(0, 0));
        }
        
        private function get layerToClone():LayerBitmap
        {
            var layer:LayerBitmap = new LayerBitmap(bigBitmapData);
            layer.alpha = 0.42;
            layer.blendMode = BlendMode.MULTIPLY;
            layer.index = 42;
            layer.name = "test";
            layer.visible = false;
            return layer;
        }
        
        private function get smallBitmapData():BitmapData
        {
            return new BitmapData(1, 1);
        }
        
        private function get bigBitmapData():BitmapData
        {
            return new BitmapData(10, 10);
        }
    }
}