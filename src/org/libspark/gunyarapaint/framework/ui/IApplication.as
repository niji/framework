package org.libspark.gunyarapaint.framework.ui
{
    import flash.display.Sprite;
    
    import org.libspark.gunyarapaint.framework.LayerBitmapCollection;
    import org.libspark.gunyarapaint.framework.Pen;
    import org.libspark.gunyarapaint.framework.modules.IDrawable;
    
    /**
     * ペイントアプリケーションに必要なメソッドを定義したインターフェース
     * 
     */
    public interface IApplication
    {
        /**
         * 名前から描写モジュールを設定する
         * 
         */
        function setModule(value:String):void;
        
        /**
         * 描写モジュールを取得する
         * 
         */
        function get module():IDrawable;
        
        /**
         * レイヤーの配列を管理するオブジェクトを取得する
         * 
         */
        function get layers():LayerBitmapCollection;
        
        /**
         * ペンオブジェクトを取得する
         * 
         */
        function get pen():Pen;
        
        /**
         * 利用可能なブレンドモードを取得する
         * (dataProvider.toArray()での利用を想定している)
         * 
         */
        function get supportedBlendModes():Array;
        
        /**
         * キャンバスの幅を取得する
         * 
         */
        function get canvasWidth():uint;
        
        /**
         * キャンバスの高さを取得する
         * 
         */
        function get canvasHeight():uint;
        
        /**
         * キャンバスのスプライトオブジェクトを取得する
         * 
         */
        function get canvasView():Sprite;
    }
}