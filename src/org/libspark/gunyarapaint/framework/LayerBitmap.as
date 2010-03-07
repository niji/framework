package org.libspark.gunyarapaint.framework
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.IBitmapDrawable;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    
    /**
     * ビットマップによるレイヤー画像のオブジェクト
     * 
     */
    public final class LayerBitmap extends Bitmap
    {
        public function LayerBitmap(bitmapData:BitmapData)
        {
            this.bitmapData = bitmapData;
            name = "Layer" + index;
        }
        
        /**
         * レイヤーを複製する
         * 
         * @param bitmapDataCopy レイヤー画像のデータも複製するかどうか
         * @return 複製されたレイヤー (LayerBitmap)
         */
        public function clone(bitmapDataCopy:Boolean = true):LayerBitmap
        {
            var layer:LayerBitmap;
            if (bitmapDataCopy) {
                layer = new LayerBitmap(bitmapData.clone());
            }
            else {
                layer = new LayerBitmap(bitmapData);
            }
            layer.alpha = alpha;
            layer.blendMode = blendMode;
            layer.index = index;
            layer.locked = false;
            layer.name = name;
            layer.visible = visible;
            return layer;
        }
        
        /**
         * ソース元からレイヤーを合成する
         * 
         * @param source ソース元
         * @param blendMode ブレンドモード
         */
        public function compositeFrom(source:IBitmapDrawable,
                                      blendMode:String):void
        {
            bitmapData.draw(source, null, null, blendMode);
        }
        
        /**
         * レイヤーを BitmapData に描写する
         * 
         * <p>
         * 現在のレイヤーの透明度及びブレンドモードを用いられて合成される。
         * </p>
         * 
         * @param dest 描写先の BitmapData
         */
        public function compositeTo(dest:BitmapData):void
        {
            // 可視である場合のみ対象のBitmapDataに描写する
            if (visible) {
                s_colorTransform.alphaMultiplier = alpha;
                dest.draw(bitmapData, null, s_colorTransform, blendMode);
            }
        }
        
        /**
         * 現在のレイヤーにマトリックスオブジェクトを適用して変形させる
         * 
         * @param matrix マトリックスオブジェクト
         */
        public function applyMatrix(matrix:Matrix):void
        {
            var transformed:BitmapData = new BitmapData(width, height, true, 0x0);
            transformed.draw(bitmapData, matrix);
            bitmapData.dispose();
            bitmapData = transformed;
        }
        
        /**
         * 指定された位置にバケツツールを適用する
         * 
         * @param x 塗りつぶし先の X 座標
         * @param y 塗りつぶし先の Y 座標
         * @param color 塗りつぶす色
         */
        public function floodFill(x:Number, y:Number, color:uint):void
        {
            bitmapData.floodFill(x, y, color);
        }
        
        /**
         * 1 ピクセルを描写する
         * 
         * @param x 描写先の X 座標
         * @param y 描写先の Y 座標
         * @param color 適用する色
         */
        public function setPixel(x:Number, y:Number, color:uint):void
        {
            bitmapData.setPixel32(x, y, color);
        }
        
        /**
         * 現在のレイヤー番号
         * 
         * @default 0
         */        
        public var index:uint;
        
        /**
         * レイヤーがロックされているかどうか
         * 
         * @default false
         */        
        public var locked:Boolean;
        
        private static var s_colorTransform:ColorTransform = new ColorTransform(
            1.0,
            1.0,
            1.0,
            1.0,
            0,
            0,
            0,
            0
        );
    }
}
