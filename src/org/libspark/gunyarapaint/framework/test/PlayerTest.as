package org.libspark.gunyarapaint.framework.test
{
    import flash.utils.ByteArray;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.Player;

    public class PlayerTest
    {
        [Test]
        public function プレイヤーが再生されるとplayingがtrueになる():void
        {
            var player:Player = player;
            player.start();
            Assert.assertTrue(player.playing);
            player.stop();
        }
        
        [Test]
        public function プレイヤーが停止されるとplayingがfalseになる():void
        {
            var player:Player = player;
            player.start();
            player.stop();
            Assert.assertFalse(player.playing);
        }
        
        [Test(expects="org.libspark.gunyarapaint.framework.errors.InvalidSignatureError")]
        public function 正しい署名が入っていないログを読み込むと例外を送出する():void
        {
            var bytes:ByteArray = new ByteArray();
            var canvas:Player = new Player();
            // 14bytes は最低でも埋める
            bytes.writeUTFBytes("12345678901234");
            bytes.position = 0;
            canvas.load(bytes);
        }
        
        [Test(expects="org.libspark.gunyarapaint.framework.errors.NotSupportedVersionError")]
        public function サポートしないバージョンのログを読み込むと例外を送出する():void
        {
            var bytes:ByteArray = createLog("0.0.0");
            var canvas:Player = new Player();
            canvas.load(bytes);
        }
        
        [Test]
        public function バージョン0_1_0まではPainterV1が使われること():void
        {
            var bytes:ByteArray = createLog("0.1.0");
            var canvas:Player = new Player();
            canvas.load(bytes);
            Assert.assertEquals(10, canvas.version);
            // internal 参照なので、 オブジェクトを文字列化して比較する
            Assert.assertEquals("[object PainterV1]", canvas.painter + "");
        }
        
        [Test]
        public function バージョン0_2_0以降はPainterV2が使われること():void
        {
            var bytes:ByteArray = createLog("0.2.0");
            var canvas:Player = new Player();
            canvas.load(bytes);
            Assert.assertEquals(20, canvas.version);
            // internal 参照なので、 オブジェクトを文字列化して比較する
            Assert.assertEquals("[object PainterV2]", canvas.painter + "");
        }
        
        private function createLog(version:String):ByteArray
        {
            var bytes:ByteArray = new ByteArray();
            // シグネチャ
            bytes.writeUTFBytes("GUNYARA_PAINT:");
            // バージョン番号
            bytes.writeUTFBytes(version + ":");
            // 画像の幅
            bytes.writeShort(123);
            // 画像の高さ
            bytes.writeShort(321);
            // 最大巻き戻し回数
            bytes.writeShort(16);
            // 読み込みする必要があるので最初の位置に戻す
            bytes.position = 0;
            return bytes;
        }
        
        private function get player():Player
        {
            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes("GUNYARA_PAINT:0.1.0:");
            bytes.writeShort(1);
            bytes.writeShort(1);
            bytes.writeShort(1);
            bytes.position = 0;
            var player:Player = new Player();
            player.load(bytes);
            player.duration = 10000;
            return player;
        }
    }
}