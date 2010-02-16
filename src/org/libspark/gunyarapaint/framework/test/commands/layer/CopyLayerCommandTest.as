package org.libspark.gunyarapaint.test.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.commands.ICommand;
    import org.libspark.gunyarapaint.commands.layer.CopyLayerCommand;
    import org.libspark.gunyarapaint.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.test.FakeLayerBitmapCollection;

    public class CopyLayerCommandTest
    {
        [Test]
        public function レイヤーコピーコマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new CopyLayerCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            command.write(bytes, {});
            bytes.position = 0;
            Assert.assertEquals(CopyLayerCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertTrue(FakeLayerBitmapCollection.didCopyLayer);
            Assert.assertTrue(canvas.didPushUndoIfNeed);
        }
    }
}