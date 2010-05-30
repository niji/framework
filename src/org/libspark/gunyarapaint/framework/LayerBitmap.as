package org.libspark.gunyarapaint.framework
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.IBitmapDrawable;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;
    
    /**
     * ビットマップによるレイヤー画像のオブジェクト
     * 
     */
    public final class LayerBitmap
    {
        public function LayerBitmap(bitmapData:BitmapData)
        {
            m_bitmap = new Bitmap();
            m_colorTransform = new ColorTransform(
                1.0,
                1.0,
                1.0,
                1.0,
                0,
                0,
                0,
                0
            );
            setBitmapData(bitmapData);
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
			// m_bitmapData.clone でアンドゥ内のビットマップ画像を保持するようにする
			// これは以下の floodFill や setPixel も同じ
            setBitmapData(m_bitmapData.clone());
            m_bitmapData.draw(source, null, null, blendMode);
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
            if (visible)
                dest.draw(bitmapData, null, m_colorTransform, blendMode);
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
            setBitmapData(transformed);
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
            setBitmapData(m_bitmapData.clone());
            m_bitmapData.floodFill(x, y, color);
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
            setBitmapData(m_bitmapData.clone());
            m_bitmapData.setPixel32(x, y, color);
        }
        
        /**
         * toJSON でシリアライズされたオブジェクトから復元する
         *
         */
        public function fromJSON(data:Object):void
        {
            alpha = data.alpha;
            blendMode = data.blendMode;
            locked = data.lock == "true";
            name = data.name;
            visible = data.visible == "true";
        }
        
        /**
         * 現在の画像データを除くメタ情報をJSON 形式に変換する
         *
         */
        public function toJSON():Object
        {
            return {
                "alpha": alpha,
                "blendMode": blendMode,
                "lock": locked ? "true" : "false",
                "name": name,
                "visible": visible ? "true" : "false"
            };
        }
        
        private function setBitmapData(value:BitmapData):void
        {
            m_bitmap.bitmapData = value;
            m_bitmapData = value;
        }

        /**
         * 現在の不透明度を取得する
         *
         */
        public function get alpha():Number
        {
            return m_bitmap.alpha;
        }
        
        /**
         * 現在のブレンドモードを取得する
         *
         */
        public function get blendMode():String
        {
            return m_bitmap.blendMode;
        }
        
        /**
         * DisplayObject の派生オブジェクトを取得する
         *
         */
        public function get displayObject():DisplayObject
        {
            return m_bitmap;
        }
        
        /**
         * 現在の画像の高さを取得する
         *
         */
        public function get height():uint
        {
            return m_bitmap.height;
        }
        
        /**
         * 現在の可視状態を取得する
         *
         */
        public function get visible():Boolean
        {
            return m_bitmap.visible;
        }
        
        /**
         * 現在の画像の幅を取得する
         *
         */
        public function get width():uint
        {
            return m_bitmap.width;
        }
        
        /**
         * 現在の不透明度を設定する
         *
         */
        public function set alpha(value:Number):void
        {
            m_bitmap.alpha = value;
            m_colorTransform.alphaMultiplier = value;
        }
        
        /**
         * 現在のブレンドモードを設定する
         *
         */
        public function set blendMode(value:String):void
        {
            m_bitmap.blendMode = value;
        }
        
        /**
         * 現在の可視状態を設定する
         *
         */
        public function set visible(value:Boolean):void
        {
            m_bitmap.visible = value;
        }
        
        internal function get newDisplayObject():DisplayObject
        {
            return new Bitmap(m_bitmapData);
        }
        
        internal function get bitmapData():BitmapData
        {
            return m_bitmapData;
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
        
        public var name:String;
        
        private var m_bitmap:Bitmap;
        
        private var m_bitmapData:BitmapData;
        
        private var m_colorTransform:ColorTransform;
    }
}
