package org.libspark.gunyarapaint.framework.test.commands.layer
{
    import flash.display.BlendMode;
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerBlendModeCommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakePainter;

    public class SetLayerBlendModeCommandTest
    {
        [Test]
        public function レイヤーのブレンドモードを設定するコマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new SetLayerBlendModeCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            var args:Object = { "blendMode": BlendMode.ADD };
            command.write(bytes, args);
            bytes.position = 0;
            Assert.assertEquals(SetLayerBlendModeCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertEquals(args.blendMode, FakePainter.layerBlendMode);
            Assert.assertTrue(canvas.didPushUndoIfNeed);
        }
    }
}