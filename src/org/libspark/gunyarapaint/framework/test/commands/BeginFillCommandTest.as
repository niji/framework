package org.libspark.gunyarapaint.framework.test.commands
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.BeginFillCommand;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakePaintEngine;

    public class BeginFillCommandTest
    {
        [Test]
        public function 塗り開始コマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var args:Object = {
                "color": 0xffffff,
                "alpha": 1.0
            };
            var command:ICommand = new BeginFillCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            command.write(bytes, args);
            bytes.position = 0;
            Assert.assertEquals(BeginFillCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertEquals(args.alpha, FakePaintEngine.alpha);
            Assert.assertEquals(args.color, FakePaintEngine.color);
            Assert.assertFalse(canvas.didPushUndo);
        }
    }
}
