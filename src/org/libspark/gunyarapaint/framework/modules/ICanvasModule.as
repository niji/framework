package org.libspark.gunyarapaint.framework.modules
{
    /**
     * 描写モジュールに必要なメソッドを定義したインターフェースです.
     * 
     * <p>
     * 主な実装はCanvasModuleで行われるため、実際に実装する必要があるのは
     * <ul>
     * <li>start</li>
     * <li>move</li>
     * <li>stop</li>
     * <li>interrupt</li>
     * </ul>
     * の４つのみです。
     * </p>
     * 
     * @see CanvasModule
     */
    public interface ICanvasModule
    {
        /**
         * 別のペンから切り替えた後に呼び出されます
         */
        function load():void;
        
        /**
         * 別のペンに切り替える前に呼び出されます
         */
        function unload():void;
        
        /**
         * 描写の開始します
         * 
         * @param x X座標
         * @param y Y座標
         */
        function start(x:Number, y:Number):void;
        
        /**
         * 座標位置を移動します
         * 
         * @param x X座標
         * @param y Y座標
         */
        function move(x:Number, y:Number):void;
        
        /**
         * 描写を終了します
         * 
         * @param x X座標
         * @param y Y座標
         */
        function stop(x:Number, y:Number):void;
        
        /**
         * 描写を中断します
         * 
         * @param x X座標
         * @param y Y座標
         */
        function interrupt(x:Number, y:Number):void;
        
        /**
         * 巻き戻しを実行します
         */
        function undo():void;
        
        /**
         * やり直しを実行します
         */
        function redo():void;
        
        /**
         * 水平鏡面を作成します
         * 
         * @param index レイヤー番号
         */
        function horizontalMirror(index:uint):void;
        
        /**
         * 垂直鏡面を作成します
         * 
         * @param index レイヤー番号
         */
        function verticalMirror(index:uint):void;
        
        /**
         * レイヤーをコピーします
         */
        function copyLayer():void;
        
        /**
         * レイヤーを新しく作成します
         */
        function createLayer():void;
        
        /**
         * レイヤーを統合します
         */
        function mergeLayers():void;
        
        /**
         * レイヤーを削除します
         */
        function removeLayer():void;
        
        /**
         * 指定されたレイヤー番号からレイヤー同士を交換します
         * 
         * @param from 交換元のレイヤー番号
         * @param to 交換先のレイヤー番号
         */
        function swapLayers(from:uint, to:uint):void;
        
        /**
         * 挙動の互換性オプションを設定します
         * 
         * @param type 互換性名
         * @param value 有効あるいは無効
         */
        function setCompatibility(type:uint, value:Boolean):void;
        
        /**
         * 座標位置を(0,0)に戻します
         */
        function reset():void;
        
        /**
         * 指定された座標からアルファ値を含む色を取り出します
         */
        function getPixel32(x:int, y:int):uint;
        
        /**
         * モジュール名を返します
         * 
         * @return name
         */        
        function get name():String;
        
        /**
         * 円の中心点を時計回りに描写するか設定します
         */
        function set shouldDrawCircleClockwise(value:Boolean):void;
        
        /**
         * 円の中心点を反時計回りに描写するかを設定します
         */
        function set shouldDrawCircleCounterClockwise(value:Boolean):void;
        
        /**
         * 描写開始時に終点固定を設定するかどうか (T)
         */
        function set shouldDrawFromStartPoint(value:Boolean):void;
        
        /**
         * 描写開始時に始点固定を設定するかどうか (R)
         */
        function set shouldDrawFromEndPoint(value:Boolean):void;
        
        /**
         * 不透明度を設定します
         * 
         * @param value 不透明度
         */
        function set alpha(value:Number):void;
        
        /**
         * ブレンドモードを設定します
         * 
         * @param value ブレンドモード名
         * @see flash.display.BlendMode
         */
        function set blendMode(value:String):void;
        
        /**
         * ペンの色を設定します
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
         * レイヤーの不透明度を設定します
         * 
         * @param value 不透明度
         */
        function set layerAlpha(value:Number):void;
        
        /**
         * レイヤーのブレンドモードを設定します
         * 
         * @param value ブレンドモード名
         * @see flash.display.BlendMode
         */
        function set layerBlendMode(value:String):void;
        
        /**
         * 現在のレイヤー番号を設定します
         * 
         * @param value レイヤー番号
         */
        function set layerIndex(value:uint):void
    }
}
