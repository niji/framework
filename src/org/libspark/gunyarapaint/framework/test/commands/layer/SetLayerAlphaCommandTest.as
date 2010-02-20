package org.libspark.gunyarapaint.framework.test.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerAlphaCommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakePainter;

    public class SetLayerAlphaCommandTest
    {
        [Test]
        public function レイヤーの透明度を設定するコマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new SetLayerAlphaCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            var args:Object = { "alpha": 0.314 };
            command.write(bytes, args);
            bytes.position = 0;
            Assert.assertEquals(SetLayerAlphaCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertEquals(args.alpha, FakePainter.layerAlpha);
            Assert.assertTrue(canvas.didPushUndoIfNeed);
        }
    }
}