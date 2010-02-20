package org.libspark.gunyarapaint.framework.test.commands
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.commands.UndoCommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;

    public class UndoCommandTest
    {
        [Test]
        public function 巻き戻しコマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new UndoCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            command.write(bytes, {});
            bytes.position = 0;
            Assert.assertEquals(UndoCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertTrue(canvas.didUndo);
        }
    }
}