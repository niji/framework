package org.libspark.gunyarapaint.framework.test.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.commands.layer.MergeLayerCommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakeLayerBitmapCollection;

    public class MergeLayerCommandTest
    {
        [Test]
        public function レイヤー統合コマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new MergeLayerCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            command.write(bytes, {});
            bytes.position = 0;
            Assert.assertEquals(MergeLayerCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertTrue(FakeLayerBitmapCollection.didMergeLayer);
            Assert.assertTrue(canvas.didPushUndoIfNeed);
        }
    }
}