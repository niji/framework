package org.libspark.gunyarapaint.framework.test
{
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.LayerBitmapCollection;

    public class LayerBitmapContainerTest
    {
        public const WIDTH:int = 123;
        public const HEIGHT:int = 321;
        
        [Test]
        public function レイヤーコンテナの作成():void
        {
            var lc:LayerBitmapCollection = layerContainer;
            Assert.assertStrictlyEquals(1, lc.count);
            Assert.assertStrictlyEquals(WIDTH, lc.currentLayer.width);
            Assert.assertStrictlyEquals(HEIGHT, lc.currentLayer.height);
        }
        
        [Test]
        public function レイヤーの追加():void
        {
            var lc:LayerBitmapCollection = layerContainer;
            lc.add();
            Assert.assertStrictlyEquals(2, lc.count);
        }
        
        [Test]
        public function レイヤーのコピー():void
        {
            var lc:LayerBitmapCollection = layerContainer;
            lc.copy();
            Assert.assertStrictlyEquals(2, lc.count);
        }
        
        [Test]
        public function レイヤーの交換():void
        {
            var lc:LayerBitmapCollection = layerContainer;
            lc.add();
            lc.at(0).name = "foo";
            lc.at(1).name = "bar";
            lc.swap(0, 1);
            Assert.assertStrictlyEquals("bar", lc.at(0).name);
            Assert.assertStrictlyEquals("foo", lc.at(1).name);
        }
        
        [Test]
        public function レイヤーの統合():void
        {
            var lc:LayerBitmapCollection = layerContainer;
            lc.add();
            lc.at(0).alpha = 0.5;
            lc.merge();
            Assert.assertStrictlyEquals(1, lc.count);
            Assert.assertStrictlyEquals(1.0, lc.at(0).alpha);
        }
        
        [Test(expects="org.libspark.gunyarapaint.framework.errors.MergeLayersError")]
        public function 両方のレイヤーが可視でなければ統合が失敗する():void
        {
            var lc:LayerBitmapCollection = layerContainer;
            lc.add();
            lc.at(0).visible = false;
            lc.at(1).visible = false;
            lc.merge();
        }
        
        [Test]
        public function レイヤーの削除():void
        {
            var lc:LayerBitmapCollection = layerContainer;
            lc.add();
            lc.remove();
            Assert.assertStrictlyEquals(1, lc.count);
        }
        
        private function get layerContainer():LayerBitmapCollection
        {
            return new LayerBitmapCollection(WIDTH, HEIGHT);
        }
    }
}