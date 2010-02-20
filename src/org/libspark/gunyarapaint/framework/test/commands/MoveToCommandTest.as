package org.libspark.gunyarapaint.framework.test.commands
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    import org.libspark.gunyarapaint.framework.test.FakeCanvasContext;
    import org.libspark.gunyarapaint.framework.test.FakePaintEngine;

    public class MoveToCommandTest
    {
        [Test]
        public function xまたはyが7ビットを超えているなら圧縮を実行しない():void
        {
            assert(64, -65);
            assert(-65, 64);
        }
        
        [Test]
        public function xまたはyが7ビット以下であればshortに圧縮():void
        {
            assert(63, -64);
            assert(-64, 63);
        }
        
        private function assert(x:int, y:int):void
        {
            var bytes:ByteArray = new ByteArray();
            var command:MoveToCommand = new MoveToCommand();
            var canvas:FakeCanvasContext = new FakeCanvasContext();
            var args:Object = { "x": x, "y": y };
            command.write(bytes, args);
            bytes.position = 0;
            var byte:uint = bytes.readUnsignedByte();
            if (byte & 0x80 || byte & 0x40)
                command.compressedValue = byte;
            else
                Assert.assertEquals(MoveToCommand.ID, byte);
            command.read(bytes);
            command.execute(canvas);
            Assert.assertEquals(args.x, FakePaintEngine.point.x);
            Assert.assertEquals(args.y, FakePaintEngine.point.y);
        }
    }
}