package org.libspark.gunyarapaint.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.CanvasContext;

    public interface ICommand
    {
        /**
         * 描写ログを読み出す
         * 
         * @param bytes 描写ログ
         * @param segment 直線
         */
        function read(bytes:ByteArray):void;
        
        /**
         * 引数から描写ログを書き出す
         * 
         * @param bytes 描写ログ
         * @param segment 直線
         * @param args 引数
         */
        function write(bytes:ByteArray, args:Object):void;
        
        /**
         * キャンバスに描写を実行する
         * 
         * @param canvas キャンバス
         */
        function execute(canvas:CanvasContext):void;
        
        /**
         * 現在のインスタンスの描写状態をリセットする
         * 
         */
        function reset():void;
        
        /**
         * コマンド特有の ID を返す
         * 
         * ICommand を継承するクラスはこれとは別に定数 ID を定義しているので、
         * そちらを代わりに取得する事が可能。実際、このメソッドは定数 ID を返す処理をしている。
         * 
         * @return コマンドのID
         */        
        function get commandID():uint;
    }
}
