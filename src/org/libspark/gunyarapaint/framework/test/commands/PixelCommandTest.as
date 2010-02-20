package org.libspark.gunyarapaint.framework.test.commands
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.commands.PixelCommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakePainter;

    public class PixelCommandTest
    {
        [Test]
        public function ピクセルコマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new PixelCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            var args:Object = { "x": 1234, "y": 4321 };
            command.write(bytes, args);
            bytes.position = 0;
            Assert.assertEquals(PixelCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertEquals(args.x, FakePainter.coordinate.x);
            Assert.assertEquals(args.y, FakePainter.coordinate.y);
            Assert.assertTrue(canvas.didPushUndo);
        }
    }
}