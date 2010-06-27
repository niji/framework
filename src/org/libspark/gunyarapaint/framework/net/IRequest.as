package org.libspark.gunyarapaint.framework.net
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

	/**
	 * 描いた絵を投稿するために必要な通信を行うためのインターフェースです
	 * 
	 */
    public interface IRequest extends IEventDispatcher
    {
		/**
		 * 描いた絵を投稿します
		 * 
		 * @param url 投稿先
		 * @param parameters IParameters を実装したクラス
		 */
        function post(url:String, parameters:IParameters):void;
		
		/**
		 * JSONなどの文字列データを取得します
		 * 
		 * @param url 取得先
		 */
        function get(url:String):void;
        
		/**
		 * 画像などの Loader クラスで使用可能なバイナリデータを取得します
		 * 
		 * @param url 取得先
		 */
        function load(url:String):void;
        
		/**
		 * Loader か URLLoader を返します.
		 * 
         * <p>
		 * Loader と URLLoader は継承関係に無いため、キャストする必要があります。
		 * そのため、両方共継承している EventDispacher クラスをひとまず返します。
         * </p>
		 * 
		 * @return Loader または URLLoader のインスタンス
         * @see flash.display.Loader
         * @see flash.net.URLLoader
		 */
        function get loader():EventDispatcher;
        
		/**
		 *　Loader か URLLoader のインスタンスを設定します.
         * 
         * <p>
         * Loader か URLLoader 以外のオブジェクトが設定された場合は
         * ArgumentError を送出します。
         * </p>
		 * 
		 * @param value Loader か URLLoader のインスタンス
         * @throws ArgumentError Loader または URLLoader 以外のクラスを設定しようとしたとき
         * @see flash.display.Loader
         * @see flash.net.URLLoader
		 */
        function set loader(value:EventDispatcher):void;
    }
}
