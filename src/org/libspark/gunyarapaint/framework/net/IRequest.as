package org.libspark.gunyarapaint.framework.net
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

	/**
	 * 描いた絵を投稿するために必要な通信を行うためのインターフェース
	 * 
	 */	
    public interface IRequest extends IEventDispatcher
    {
		/**
		 * 描いた絵を投稿する
		 * 
		 * @param url 投稿先
		 * @param parameters IParameters を実装したクラス
		 */		
        function post(url:String, parameters:IParameters):void;
		
		/**
		 * JSONなどの文字列データを取得する
		 * 
		 * @param url 取得先
		 */        
        function get(url:String):void;
        
		/**
		 * 画像などの Loader クラスで使用可能なバイナリデータを取得する
		 * 
		 * @param url 取得先
		 */		
        function load(url:String):void;
        
		/**
		 * Loader か URLLoader を返す。
		 * 
		 * Loader と URLLoader は継承関係に無いため、キャストする必要がある。
		 * そのため、両方共継承している EventDispacher クラスをひとまず返す
		 * 
		 * @return Loader または URLLoader のインスタンス
		 */		
        function get loader():EventDispatcher;
        
		/**
		 *　Loader か URLLoader のインスタンスを設定する。それ以外の場合は ArgumentError を送出する
		 *  
		 * @param value Loader か URLLoader のインスタンス
		 */		
        function set loader(value:EventDispatcher):void;
    }
}
