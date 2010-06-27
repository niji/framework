package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * コマンドオブジェクトに必要なメソッドを定義したインターフェースです
     */
    public interface ICommand
    {
        /**
         * 描写ログを読み出します
         * 
         * @param bytes 描写ログ
         * @param segment 直線
         */
        function read(bytes:ByteArray):void;
        
        /**
         * 引数から描写ログを書き出します
         * 
         * @param bytes 描写ログ
         * @param segment 直線
         * @param args 引数
         */
        function write(bytes:ByteArray, args:Object):void;
        
        /**
         * キャンバスに描写を実行します
         * 
         * @param painter ペインターオブジェクト
         * @see org.libspark.gunyarapaint.framework.Painter
         */
        function execute(painter:Painter):void;
        
        /**
         * 現在のインスタンスの描写状態をリセットします
         */
        function reset():void;
        
        /**
         * デバッグ用の文字列表現を返します
         */
        function toString():String;
        
        /**
         * コマンド特有の ID を返します.
         * 
         * <p>
         * ICommand を継承するクラスはこれとは別に定数 ID を常に定義しているので、
         * そちらを代わりに取得する事が可能です。
         * 実際、このメソッドは定数 ID を返す処理をしています。
         * </p>
         * 
         * @return コマンドのID
         */
        function get commandID():uint;
    }
}
