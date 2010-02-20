package org.libspark.gunyarapaint.framework.test.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SwapLayerCommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakeLayerBitmapCollection;

    public class SwapLayerCommandTest
    {
        [Test]
        public function レイヤー交換コマンドの実行():void
        {
            var bytes:ByteArray = new ByteArray();
            var command:ICommand = new SwapLayerCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            var args:Object = { "from": 42, "to": 24 };
            command.write(bytes, args);
            bytes.position = 0;
            Assert.assertEquals(SwapLayerCommand.ID, bytes.readByte());
            command.read(bytes);
            command.execute(canvas);
            Assert.assertEquals(args.from, FakeLayerBitmapCollection.didSwapLayerFrom);
            Assert.assertEquals(args.to, FakeLayerBitmapCollection.didSwapLayerTo);
            Assert.assertTrue(canvas.didPushUndoIfNeed);
        }
    }
}