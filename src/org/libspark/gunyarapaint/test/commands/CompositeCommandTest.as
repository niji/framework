package org.libspark.gunyarapaint.test.commands
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.commands.CompositeCommand;
    import org.libspark.gunyarapaint.commands.ICommand;
    import org.libspark.gunyarapaint.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.test.FakePainter;

    public class CompositeCommandTest
    {
        [Test]
        public function 描写コマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new CompositeCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            command.write(bytes, {});
            bytes.position = 0;
            Assert.assertEquals(CompositeCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertTrue(FakePainter.didComposite);
            Assert.assertTrue(FakePainter.didEndDrawing);
            Assert.assertTrue(canvas.didPushUndo);
        }
    }
}