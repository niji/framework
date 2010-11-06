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
/// @cond
package com.github.niji.framework.commands
{
/// @endcond
    import com.github.niji.framework.Painter;
    
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
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
        function read(bytes:IDataInput):void;
        
        /**
         * 引数から描写ログを書き出します
         * 
         * @param bytes 描写ログ
         * @param segment 直線
         * @param args 引数
         */
        function write(bytes:IDataOutput, args:Object):void;
        
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
