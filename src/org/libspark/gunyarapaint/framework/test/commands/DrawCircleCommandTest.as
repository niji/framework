package org.libspark.gunyarapaint.framework.test.commands
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.DrawCircleCommand;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakePaintEngine;

    public class DrawCircleCommandTest
    {
        [Test]
        public function 円弧を描写するコマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new DrawCircleCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            var args:Object = {
                "radius": Math.PI
            };
            command.write(bytes, args);
            bytes.position = 0;
            Assert.assertEquals(DrawCircleCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertEquals(args.radius, FakePaintEngine.radius);
            Assert.assertFalse(canvas.didPushUndo);
        }
    }
}