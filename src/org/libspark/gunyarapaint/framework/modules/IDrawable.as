package org.libspark.gunyarapaint.framework.modules
{
    /**
     * 描写モジュールに必要なメソッドを定義したインターフェース。利用は外部から可能だが、実装は内部で行われる。
     * 
     */
    public interface IDrawable
    {
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
         * 最後に移動した位置を保存する
         * 
         * @param x x座標
         * @param y y座標
         */
        function saveCoordinate(x:Number, y:Number):void;
        
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
         * モジュール名を返す
         * 
         * @return name
         */        
        function get name():String;
        
        function set keyA(value:Boolean):void;
        function set keyQ(value:Boolean):void;
        function set shouldStartAfterDrawing(value:Boolean):void;
        function set shouldStartBeforeDrawing(value:Boolean):void;
        
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