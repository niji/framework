package org.libspark.gunyarapaint.framework.test.commands
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.commands.RedoCommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;

    public class RedoCommandTest
    {
        [Test]
        public function やり直しコマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new RedoCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            command.write(bytes, {});
            bytes.position = 0;
            Assert.assertEquals(RedoCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertTrue(canvas.didRedo);
        }
    }
}