package org.libspark.gunyarapaint.framework.test.commands
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.HorizontalMirrorCommand;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakePainter;

    public class HorizontalMirrorCommandTest
    {
        [Test]
        public function 水平ミラー作成コマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new HorizontalMirrorCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            var args:Object = { "index": 42 };
            command.write(bytes, args);
            bytes.position = 0;
            Assert.assertEquals(HorizontalMirrorCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertEquals(args.index, FakePainter.layerIndex);
            Assert.assertFalse(canvas.didPushUndo);
        }
    }
}