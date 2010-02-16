package org.libspark.gunyarapaint.test.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.commands.ICommand;
    import org.libspark.gunyarapaint.commands.layer.CreateLayerCommand;
    import org.libspark.gunyarapaint.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.test.FakeLayerBitmapCollection;

    public class CreateLayerCommandTest
    {
        [Test]
        public function レイヤー作成コマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new CreateLayerCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            command.write(bytes, {});
            bytes.position = 0;
            Assert.assertEquals(CreateLayerCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertTrue(FakeLayerBitmapCollection.didAddLayer);
            Assert.assertTrue(canvas.didPushUndoIfNeed);
        }
    }
}