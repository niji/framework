package org.libspark.gunyarapaint.framework.test
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.Parser;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.commands.LineToCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    import org.libspark.gunyarapaint.framework.commands.RedoCommand;
    import org.libspark.gunyarapaint.framework.commands.UndoCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.CopyLayerCommand;

    public class ParserTest
    {
        [Test(expects="ArgumentError")]
        public function ログデータが26bytes未満の場合例外を送出する():void
        {
            var parser:Parser = new Parser(new ByteArray());
            parser.rewind();
        }
        
        [Test]
        public function ログをヘッダーを読み込んだ後の位置に変更する():void
        {
            var parser:Parser = new Parser(bytesWithDummyHeader);
            parser.rewind();
            Assert.assertEquals(Parser.EOH, parser.bytes.position);
        }
        
        [Test]
        public function 先読みを行う():void
        {
            var bytes:ByteArray = bytesWithDummyHeader;
            // 連続して巻き戻し及びやり直しが発生するのは4回
            bytes.writeByte(UndoCommand.ID);
            bytes.writeByte(RedoCommand.ID);
            bytes.writeByte(RedoCommand.ID);
            bytes.writeByte(UndoCommand.ID);
            // ここでリセットされる。次も連続して2回行われるが先ほどの4回を上回らないため更新されない
            bytes.writeByte(CopyLayerCommand.ID);
            bytes.writeByte(RedoCommand.ID);
            bytes.writeByte(UndoCommand.ID);
            var parser:Parser = new Parser(bytes);
            parser.loadCommands();
            parser.preload();
            Assert.assertEquals(4, parser.maxUndoCount);
            Assert.assertEquals(7, parser.count);
        }
        
        private function get bytesWithDummyHeader():ByteArray
        {
            var bytes:ByteArray = new ByteArray();
            // シグネチャ
            bytes.writeUTFBytes("GUNYARA_PAINT:");
            // バージョン番号
            bytes.writeUTFBytes("0.1.0:");
            // 画像の幅
            bytes.writeShort(123);
            // 画像の高さ
            bytes.writeShort(321);
            // 最大巻き戻し回数
            bytes.writeShort(16);
            return bytes;
        }
        
        private function dispatchCommand(method:String, command:ICommand):void
        {
            var parser:Parser = new Parser(new ByteArray());
            parser[method](command);
        }
    }
}