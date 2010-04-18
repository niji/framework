package org.libspark.gunyarapaint.framework.modules
{
    /**
     * 描写モジュールに必要なメソッドを定義したインターフェース。利用は外部から可能だが、実装は内部で行われる。
     * ICanvasModule
     */
    public interface ICanvasModule
    {
        /**
         * 別のペンから切り替えた後に呼び出される
         * 
         */
        function load():void;
        
        /**
         * 別のペンに切り替える前に呼び出される
         * 
         */
        function unload():void;
        
        /**
         * 描写の開始をする
         * 
         * @param x x座標
         * @param y y座標
         */
        function start(x:Number, y:Number):void;
        
        /**
         * 座標位置を移動する
         * 
         * @param x x座標
         * @param y y座標
         */
        function move(x:Number, y:Number):void;
        
        /**
         * 描写を終了する
         * 
         * @param x x座標
         * @param y y座標
         */
        function stop(x:Number, y:Number):void;
        
        /**
         * 描写を中断する
         * 
         * @param x x座標
         * @param y y座標
         */
        function interrupt(x:Number, y:Number):void;
        
        /**
         * 巻き戻しを実行する 
         * 
         */
        function undo():void;
        
        /**
         * やり直しを実行する 
         * 
         */
        function redo():void;
        
        /**
         * 水平鏡面を作成する
         * 
         * @param index レイヤー番号
         */
        function horizontalMirror(index:uint):void;
        
        /**
         * 垂直鏡面を作成する
         * 
         * @param index レイヤー番号
         */
        function verticalMirror(index:uint):void;
        
        /**
         * レイヤーをコピーする
         * 
         */
        function copyLayer():void;
        
        /**
         * レイヤーを新しく作る
         * 
         */
        function createLayer():void;
        
        /**
         * レイヤーを統合する 
         * 
         */
        function mergeLayers():void;
        
        /**
         * レイヤーを削除する 
         * 
         */
        function removeLayer():void;
        
        /**
         * 指定されたレイヤー番号からレイヤー同士を交換する
         * 
         * @param from 交換元のレイヤー番号
         * @param to 交換先のレイヤー番号
         */
        function swapLayers(from:uint, to:uint):void;
        
        /**
         * 挙動の互換性オプションを設定する
         * 
         * @param type 互換性名
         * @param value 有効あるいは無効
         */
        function setCompatibility(type:uint, value:Boolean):void;
        
        /**
         * 座標位置を(0,0)に戻す
         * 
         */
        function reset():void;
        
        /**
         * 指定された座標からアルファ値を含む色を取り出す
         * 
         */
        function getPixel32(x:int, y:int):uint;
        
        /**
         * モジュール名を返す
         * 
         * @return name
         */        
        function get name():String;
        
        /**
         * 円の中心点を時計回りに描写するか設定する
         * 
         */
        function set shouldDrawCircleClockwise(value:Boolean):void;
        
        /**
         * 円の中心点を反時計回りに描写するかを設定する
         * 
         */
        function set shouldDrawCircleCounterClockwise(value:Boolean):void;
        
        /**
         * 描写開始時に終点固定を設定するかどうか (T)
         * 
         */
        function set shouldDrawFromStartPoint(value:Boolean):void;
        
        /**
         * 描写開始時に始点固定を設定するかどうか (R)
         * 
         */
        function set shouldDrawFromEndPoint(value:Boolean):void;
        
        /**
         * 不透明度を設定する
         * 
         * @param value 不透明度
         */
        function set alpha(value:Number):void;
        
        /**
         * ブレンドモードを設定する
         * 
         * @param value ブレンドモード名
         */
        function set blendMode(value:String):void;
        
        /**
         * ペンの色を設定する
         * 
         * @param value ARGB形式の32bitの符号なし整数
         */
        function set color(value:uint):void;
        
        /**
         * ペンの太さを設定する
         * 
         * @param value ペンの太さ
         */
        function set thickness(value:uint):void;
        
        /**
         * レイヤーの不透明度を設定する
         * 
         * @param value 不透明度
         */
        function set layerAlpha(value:Number):void;
        
        /**
         * レイヤーのブレンドモードを設定する
         * 
         * @param value ブレンドモード名
         */
        function set layerBlendMode(value:String):void;
        
        /**
         * 現在のレイヤー番号を設定する
         * 
         * @param value レイヤー番号
         */
        function set layerIndex(value:uint):void
    }
}