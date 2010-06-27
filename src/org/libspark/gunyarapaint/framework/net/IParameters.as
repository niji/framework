package org.libspark.gunyarapaint.framework.net
{
    import flash.utils.ByteArray;
	
	/**
	 * IRequest#post に渡す文字列化可能なインターフェースです
	 * 
	 */
    public interface IParameters
    {
		/**
		 * IParameters を実装したクラス内の複数のパラメータを文字列化します
		 * 
		 * @return IRequest#post に最適な文字列
		 */
        function serialize():ByteArray;
    }
}
