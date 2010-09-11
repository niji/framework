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
package com.github.niji.framework
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;

    public interface ILayer
    {
        /**
         * レイヤーを対象のレイヤーに描写します.
         * 
         * <p>現在のレイヤーの透明度及びブレンドモードを用いられて合成されます</p>
         * 
         * @param dest 描写先の BitmapData
         */
        function compositeTo(dest:ILayer):void;
        
        /**
         * レイヤーを BitmapData に描写します.
         * 
         * <p>現在のレイヤーの透明度及びブレンドモードを用いられて合成されます</p>
         * 
         * @param dest 描写先の BitmapData
         */
        function compositeBitmap(dest:BitmapData):void;
        
        /**
         * レイヤーを複製します
         * 
         * @param bitmapDataCopy レイヤー画像のデータも複製するかどうか
         * @return 複製されたレイヤー (ILayer)
         */
        function clone(bitmapDataCopy:Boolean = true):ILayer;
        
        /**
         * toJSON でシリアライズされたオブジェクトから復元します
         */
        function fromJSON(data:Object):void;
        
        /**
         * @private
         */
        function setIndex(index:uint):void;
        
        /**
         * 現在の画像データを除くメタ情報をJSON 形式に変換します
         */
        function toJSON():Object;
        
        /**
         * 現在の不透明度を取得します
         */
        function get alpha():Number;
        
        /**
         * 現在のブレンドモードを取得します
         * 
         * @see flash.display.BlendMode
         */
        function get blendMode():String;
        
        /**
         * DisplayObject の派生オブジェクトを取得します
         */
        function get displayObject():DisplayObject;
        
        /**
         * 現在の画像の高さを取得します
         */
        function get height():uint;
        
        /**
         * 現在のレイヤー番号を取得します
         */
        function get index():uint;
        
        /**
         * レイヤーがロックされているかを取得します
         */
        function get locked():Boolean;
        
        /**
         * レイヤー名を設定します
         */
        function get name():String;
        
        /**
         * 現在の可視状態を取得します
         */
        function get visible():Boolean;
        
        /**
         * 現在の画像の幅を取得します
         */
        function get width():uint;
        
        /**
         * @private
         */
        function get newDisplayObject():DisplayObject;
        
        /**
         * 現在の不透明度を設定します
         */
        function set alpha(value:Number):void;
        
        /**
         * 現在のブレンドモードを設定します
         * 
         * @see flash.display.BlendMode
         */
        function set blendMode(value:String):void;
        
        /**
         * レイヤーをロックするかを設定します
         */
        function set locked(value:Boolean):void;
        
        /**
         * レイヤー名を設定します
         */
        function set name(value:String):void;
        
        /**
         * 現在の可視状態を設定します
         */
        function set visible(value:Boolean):void;
    }
}
