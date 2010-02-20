package org.libspark.gunyarapaint.framework.test.commands
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.EndFillCommand;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakePaintEngine;

    public class EndFillComamndTest
    {
        [Test]
        public function 塗り終了コマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new EndFillCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            command.write(bytes, {});
            bytes.position = 0;
            Assert.assertEquals(EndFillCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertTrue(FakePaintEngine.filled);
            Assert.assertFalse(canvas.didPushUndo);
        }
    }
}