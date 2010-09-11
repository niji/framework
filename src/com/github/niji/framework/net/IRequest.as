/*
    Copyright (c) 2008-2010, tasukuchan, hikarincl2
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name of the <organization> nor the
          names of its contributors may be used to endorse or promote products
          derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.github.niji.framework.net
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
