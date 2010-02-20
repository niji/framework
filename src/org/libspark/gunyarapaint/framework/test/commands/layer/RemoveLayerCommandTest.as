package org.libspark.gunyarapaint.framework.test.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.commands.layer.RemoveLayerCommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakeLayerBitmapCollection;

    public class RemoveLayerCommandTest
    {
        [Test]
        public function レイヤー削除コマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new RemoveLayerCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            command.write(bytes, {});
            bytes.position = 0;
            Assert.assertEquals(RemoveLayerCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertTrue(FakeLayerBitmapCollection.didRemoveLayer);
            Assert.assertTrue(canvas.didPushUndoIfNeed);
        }
    }
}