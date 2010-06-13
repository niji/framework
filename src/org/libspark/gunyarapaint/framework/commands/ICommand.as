package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * コマンドオブジェクトに必要なメソッドを定義したインターフェース
     * 
     */
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
         * @param painter キャンバス
         */
        function execute(painter:Painter):void;
        
        /**
         * 現在のインスタンスの描写状態をリセットする
         * 
         */
        function reset():void;
        
        /**
         * デバッグ用の文字列を返す
         * 
         */ 
        function toString():String;
        
        /**
         * コマンド特有の ID を返す.
         * 
         * <p>
         * ICommand を継承するクラスはこれとは別に定数 ID を定義しているので、
         * そちらを代わりに取得する事が可能。実際、このメソッドは定数 ID を返す処理をしている。
         * </p>
         * 
         * @return コマンドのID
         */        
        function get commandID():uint;
    }
}
