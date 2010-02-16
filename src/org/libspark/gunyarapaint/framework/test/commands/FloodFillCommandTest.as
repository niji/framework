package org.libspark.gunyarapaint.test.commands
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.commands.FloodFillCommand;
    import org.libspark.gunyarapaint.commands.ICommand;
    import org.libspark.gunyarapaint.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.test.FakePainter;

    public class FloodFillCommandTest
    {
        [Test]
        public function 塗りつぶしコマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new FloodFillCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            command.write(bytes, {});
            bytes.position = 0;
            Assert.assertEquals(FloodFillCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertTrue(FakePainter.didFloodFill);
            Assert.assertTrue(FakePainter.didEndDrawing);
            Assert.assertTrue(canvas.didPushUndo);
        }
    }
}