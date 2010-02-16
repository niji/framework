package org.libspark.gunyarapaint.test.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.commands.ICommand;
    import org.libspark.gunyarapaint.commands.layer.SetLayerIndexCommand;
    import org.libspark.gunyarapaint.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.test.FakePainter;

    public class SetLayerIndexCommandTest
    {
        [Test]
        public function レイヤーのインデックスを設定するコマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new SetLayerIndexCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            var args:Object = { "index": 42 };
            command.write(bytes, args);
            bytes.position = 0;
            Assert.assertEquals(SetLayerIndexCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertEquals(args.index, canvas.painter.layers.currentIndex);
            Assert.assertFalse(canvas.didPushUndoIfNeed);
        }
    }
}