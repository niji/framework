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
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.IBitmapDrawable;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    
    import com.github.niji.framework.i18n.TranslatorRegistry;
    
    /**
     * ビットマップによるレイヤー画像のクラスです
     */
    public final class BitmapLayer extends Layer implements ILayer
    {
        /**
         * ビットマップ画像データを紐付けてレイヤーを生成します
         * 
         * @param bitmapData ビットマップの画像データ
         */
        public function BitmapLayer(bitmapData:BitmapData)
        {
            super();
            m_bitmap = new Bitmap();
            setBitmapData(bitmapData);
        }
        
        /**
         * レイヤーを複製します
         * 
         * @param bitmapDataCopy レイヤー画像のデータも複製するかどうか
         * @return 複製されたレイヤー (LayerBitmap)
         */
        public function clone(bitmapDataCopy:Boolean = true):ILayer
        {
            var layer:BitmapLayer;
            if (bitmapDataCopy) {
                layer = new BitmapLayer(bitmapData.clone());
            }
            else {
                layer = new BitmapLayer(bitmapData);
            }
            layer.alpha = alpha;
            layer.blendMode = blendMode;
            layer.locked = false;
            layer.name = name;
            layer.visible = visible;
            layer.setIndex(index);
            return layer;
        }
        
        /**
         * ソース元からレイヤーを合成します
         * 
         * @param source ソース元
         * @param blendMode ブレンドモード
         * @see flash.display.BlendMode
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
         * @inheritDoc
         */
        public function compositeBitmap(dest:BitmapData):void
        {
            // 可視である場合のみ対象のBitmapDataに描写する
            if (visible)
                dest.draw(bitmapData, null, m_colorTransform, blendMode);
        }
        
        /**
         * @inheritDoc
         */
        public function compositeTo(dest:ILayer):void
        {
            if (visible && dest.visible) {
                if (dest is BitmapLayer) {
                    BitmapLayer(dest).bitmapData.draw(m_bitmapData,
                        null, m_colorTransform, blendMode);
                }
                else {
                    throw new ArgumentError(
                        "Cannot composite BitmapLayer to VectorGraphicLayer");
                }
            }
        }
        
        /**
         * 現在のレイヤーにマトリックスオブジェクトを適用して変形させます
         * 
         * @param matrix マトリックスオブジェクト
         * @see flash.geom.Matrix
         */
        public function applyMatrix(matrix:Matrix):void
        {
            var transformed:BitmapData = new BitmapData(width, height, true, 0x0);
            transformed.draw(bitmapData, matrix);
            setBitmapData(transformed);
        }
        
        /**
         * 指定された位置にバケツツールを適用します
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
         * 1 ピクセルを描写します
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
        
        private function setBitmapData(value:BitmapData):void
        {
            m_bitmap.bitmapData = value;
            m_bitmapData = value;
        }

        /**
         * @inheritDoc
         */
        public override function get alpha():Number
        {
            return m_bitmap.alpha;
        }
        
        /**
         * @inheritDoc
         */
        public override function get blendMode():String
        {
            return m_bitmap.blendMode;
        }
        
        /**
         * @inheritDoc
         */
        public function get displayObject():DisplayObject
        {
            return m_bitmap;
        }
        
        /**
         * @inheritDoc
         */
        public function get height():uint
        {
            return m_bitmap.height;
        }
        
        /**
         * @inheritDoc
         */
        public override function get visible():Boolean
        {
            return m_bitmap.visible;
        }
        
        /**
         * @inheritDoc
         */
        public function get width():uint
        {
            return m_bitmap.width;
        }
        
        /**
         * @inheritDoc
         */
        public override function set alpha(value:Number):void
        {
            super.alpha = value;
            m_bitmap.alpha = value;
        }
        
        /**
         * @inheritDoc
         */
        public override function set blendMode(value:String):void
        {
            m_bitmap.blendMode = value;
        }
        
        /**
         * @inheritDoc
         */
        public override function set visible(value:Boolean):void
        {
            m_bitmap.visible = value;
        }
        
        /**
         * @private
         */
        public function get newDisplayObject():DisplayObject
        {
            return new Bitmap(m_bitmapData);
        }
        
        /**
         * @private
         */
        public function get bitmapData():BitmapData
        {
            return m_bitmapData;
        }
        
        private var m_bitmap:Bitmap;
        
        private var m_bitmapData:BitmapData;
    }
}
