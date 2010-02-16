package org.libspark.gunyarapaint
{
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Painter
    {
        public function Painter(width:int, height:int, engine:PaintEngine)
        {
            m_paintEngine = engine;
            m_layers = new LayerBitmapCollection(width, height);
            m_altDrawingSprite = null;
            m_horizontalMirrorMatrix = new Matrix(-1, 0, 0, 1, width, 0);
            m_verticalMirrorMatrix = new Matrix(1, 0, 0, -1, 0, height);
        }
        
        /**
         * 連結されたレイヤー画像とメタデータから復元する
         * 
         * @param layerBitmaps 縦に連結されたレイヤー画像
         * @param metadata メタデータ
         */
        public function restore(layerBitmaps:BitmapData, metadata:Object):void
        {
            var width:uint = metadata.width;
            var height:uint = metadata.height;
            var layerCount:uint = layerBitmaps.height / height;
            var destination:Point = new Point(0, 0);
            var rectangle:Rectangle = new Rectangle(0, 0, width, height);
            var sprite:Sprite = m_layers.spriteToView;
            m_layers.clear();
            for (var i:uint = 0; i < layerCount; i++) {
                var bitmapData:BitmapData = new BitmapData(width, height);
                bitmapData.copyPixels(layerBitmaps, rectangle, destination);
                rectangle.y = i * height;
                var layerBitmap:LayerBitmap = new LayerBitmap(bitmapData);
                m_layers.layers.push(layerBitmap);
                sprite.addChild(layerBitmap);
            }
        }
        
        /**
         * 現在位置を変更する
         * 
         * PainterEngine クラスにある moveTo の委譲
         * 
         * @param x 移動先となる X 座標
         * @param y 移動先となる Y 座標
         */
        public function moveTo(x:Number, y:Number):void
        {
            m_paintEngine.moveTo(roundPixel(x), roundPixel(y));
        }
        
        /**
         * 現在位置から指定された位置まで線を描写する
         * 
         * PainterEngine クラスにある lineTo の委譲
         * 
         * @param x 描写先となる X 座標
         * @param y 描写先となる Y 座標
         */
        public function lineTo(x:Number, y:Number):void
        {
            m_paintEngine.lineTo(roundPixel(x), roundPixel(y));
        }
        
        /**
         * 矩形を描写する
         * 
         * PainterEngine クラスにある drawRect の委譲
         * 
         * @param x 基準点となる X 座標
         * @param y 基準点となる Y 座標
         * @param width 幅
         * @param height 高さ
         */
        public function drawRect(x:Number, y:Number,
                                 width:uint, height:uint):void
        {
            m_paintEngine.drawRect(x, y, width, height);
        }
        
        /**
         * 楕円を描写する
         * 
         * PainterEngine クラスにある drawEllipse の委譲
         * 
         * @param x 基準点となる X 座標
         * @param y 基準点となる Y 座標
         * @param width 幅
         * @param height 高さ
         */
        public function drawEllipse(x:Number, y:Number,
                                    width:uint, height:uint):void
        {
            m_paintEngine.drawEllipse(x, y, width, height);
        }
        
        /**
         * 塗りつぶしを開始する
         * 
         * PainterEngine クラスにある beginFill の委譲
         * 
         * @param color 塗りつぶす色
         * @param alpha 透明度
         */
        public function beginFill(color:uint, alpha:Number):void
        {
            m_paintEngine.beginFill(color, alpha);
        }
        
        /**
         * 現在の位置から円弧を描写する
         * 
         * PainterEngine クラスにある drawCircle の委譲
         * 
         * @param radius 半径
         */
        public function drawCircle(radius:Number):void
        {
            m_paintEngine.drawCircle(radius);
        }
        
        /**
         * 塗りつぶしを終了する
         * 
         * PainterEngine クラスにある endFill の委譲
         * 
         */
        public function endFill():void
        {
            m_paintEngine.endFill();
        }
        
        public function resetPen():void
        {
            m_paintEngine.resetPen();
        }
        
        public function clear():void
        {
            m_paintEngine.clear();
        }
        
        /**
         * PainterEngine クラスに描写された中身を現在のレイヤーに反映させる
         * 
         *  Pen クラスのブレンドモードを適用する
         * 
         */
        public function composite():void
        {
            // undoBuffer に入っているLayerBitmapを上書きしない為にコピーしてから作業する
            // これは floodFill 及び setPixel も同様
            var newLayer:LayerBitmap = m_layers.currentLayer.clone();
            newLayer.compositeFrom(
                m_paintEngine.shape,
                m_paintEngine.pen.blendMode
            );
            m_layers.setCurrentLayer(newLayer);
            m_layers.compositeAll();
        }
        
        /**
         * 塗りつぶしを行う 
         * 
         * PainterEngine クラスの現在位置と Pen クラスの色を適用する
         * 
         */
        public function floodFill():void
        {
            var newLayer:LayerBitmap = m_layers.currentLayer.clone();
            newLayer.floodFill(
                m_paintEngine.x,
                m_paintEngine.y,
                m_paintEngine.pen.argb
            );
            m_layers.setCurrentLayer(newLayer);
            m_layers.compositeAll();
        }
        
        /**
         * 1 ピクセルを描写する
         * 
         * 現在の Pen クラスの色を適用する
         * 
         * @param x 描写先となる X 座標
         * @param y 描写先となる Y 座標
         */
        public function setPixel(x:int, y:int):void
        {
            var newLayer:LayerBitmap = m_layers.currentLayer.clone();
            newLayer.setPixel(x, y, m_paintEngine.pen.argb);
            m_layers.setCurrentLayer(newLayer);
            m_layers.compositeAll();
        }
        
        /**
         * 特定のピクセルの色を取得する(不透明度は取得しない)
         * 
         * @param x 取得先となる X 座標
         * @param y 取得先となる Y 座標
         * @return RGB 形式の色の値
         */
        public function getPixel(x:int, y:int):uint
        {
            // AAAARRRRGGGGBBBB
            var alpha:uint = m_layers.composited.getPixel32(x, y) >> 24 && 0xff;
            return alpha > 0 ? m_layers.composited.getPixel(x, y) : 0xffffff;
        }
        
        /**
         * 特定のピクセルの色を取得する
         * 
         * @param x 取得先となる X 座標
         * @param y 取得先となる Y 座標
         * @return ARGB 形式の色の値
         */
        public function getPixel32(x:int, y:int):uint
        {
            return layers.composited.getPixel32(x, y);
        }
        
        /**
         * レイヤーの可視状態を変更する
         * 
         * @param index レイヤー番号
         * @param visible 可視であるかどうか
         */
        public function setVisibleAt(index:int, visible:Boolean):void
        {
            m_layers[index].visible = visible;
            m_layers.compositeAll();
        }
        
        public function transformWithHorizontalMirrorAt(index:int):void
        {
            transformFromMatrixAt(index, m_horizontalMirrorMatrix);
        }
        
        public function transformWithVerticalMirrorAt(index:int):void
        {
            transformFromMatrixAt(index, m_verticalMirrorMatrix);
        }
        
        /**
         * 描写開始を宣言する
         * 
         * 全てのレイヤーに対してではなく、現在のレイヤーのみにブレンドモードが
         * 適用されるように Sprite の変更が行われる。
         */
        public function startDrawingSession():void
        {
            if (m_altDrawingSprite === null) {
                m_paintEngine.resetPen();
                var currentLayer:LayerBitmap = m_layers.currentLayer;
                var blendMode:String = currentLayer.blendMode;
                m_altDrawingSprite = new Sprite();
                m_altDrawingSprite.mouseEnabled = false;
                m_altDrawingSprite.blendMode =
                    blendMode == BlendMode.NORMAL ? BlendMode.LAYER : blendMode;
                m_altDrawingSprite.alpha = currentLayer.alpha;
                var tempLayer:LayerBitmap = currentLayer.clone(false);
                tempLayer.blendMode = BlendMode.NORMAL;
                tempLayer.alpha = 1.0;
                m_altDrawingSprite.addChild(tempLayer);
                m_altDrawingSprite.addChild(m_paintEngine.shape);
                var sprite:Sprite = m_layers.spriteToView;
                sprite.removeChild(currentLayer);
                sprite.addChildAt(m_altDrawingSprite, m_layers.currentIndex);
            }
        }
        
        /**
         * 描写終了を宣言する
         * 
         */
        public function stopDrawingSession():void
        {
            if (m_altDrawingSprite !== null) {
                var sprite:Sprite = m_layers.spriteToView;
                var currentLayer:LayerBitmap = m_layers.currentLayer;
                var blendMode:String = m_altDrawingSprite.blendMode;
                currentLayer.blendMode =
                    blendMode == BlendMode.LAYER ? BlendMode.NORMAL : blendMode;
                currentLayer.alpha = m_altDrawingSprite.alpha;
                sprite.removeChild(m_altDrawingSprite);
                sprite.addChildAt(currentLayer, m_layers.currentIndex);
                m_altDrawingSprite = null;
                m_paintEngine.clear();
            }
        }
        
        /**
         * 現在のピクセルを補正する
         * 
         * @param n ピクセル位置
         * @return 補正したピクセル
         */        
        public function roundPixel(n:Number):Number
        {
            return n;
        }
        
        private function transformFromMatrixAt(index:int, matrix:Matrix):void
        {
            if (index === 0xff) {
                var c:uint = m_layers.count;
                for (var i:uint = 0; i < c; i++) {
                    var layer:LayerBitmap = m_layers[i];
                    layer.transform.matrix = matrix;
                }
            }
            else {
                m_layers.currentLayer.transform.matrix = matrix;
            }
            m_layers.compositeAll();
        }
        
        private function saveUndo():Object
        {
            var count:uint = m_layers.count;
            var layers:Vector.<LayerBitmap> = new Vector.<LayerBitmap>(
                count, true
            );
            for (var i:uint = 0; i < count; i++) {
                var layer:LayerBitmap = m_layers.layers[i].clone(false);
                layers[i] = layer;
            }
            var undoData:Object = {};
            undoData.index = m_layers.currentIndex;
            undoData.layers = layers;
            return undoData;
        }
        
        private function restoreUndo(undoData:Object):void
        {
            var i:uint = 0;
            m_layers.clear();
            var count:uint = undoData.layers.length;
            var sprite:Sprite = m_layers.spriteToView;
            for (i = 0; i < count; i++) {
                var layer:LayerBitmap = undoData.layers[i].clone(false);
                m_layers.layers.push(layer);
                sprite.addChild(layer);
            }
            m_layers.currentIndex = undoData.index;
            m_layers.compositeAll();
        }
        
        public function get layers():LayerBitmapCollection
        {
            return m_layers;
        }
        
        public function get view():Sprite
        {
            return m_layers.spriteToView;
        }
        
        public function get pen():Pen
        {
            return m_paintEngine.pen;
        }
        
        /**
         * 現在のレイヤーの透明度を変更する
         * 
         * @param value
         */        
        public function set currentLayerAlpha(value:Number):void
        {
            m_layers.currentLayer.alpha = value;
            m_layers.compositeAll();
        }
        
        /**
         * 現在のブレンドモードを変更する
         * 
         * @param value
         */        
        public function set currentLayerBlendMode(value:String):void
        {
            m_layers.currentLayer.blendMode = value;
            m_layers.compositeAll();
        }
        
        public function set pen(value:Pen):void
        {
            m_paintEngine.pen = value;
        }
        
        internal function get undo():Object
        {
            return saveUndo();
        }
        
        internal function set undo(value:Object):void
        {
            restoreUndo(value);
        }
        
        protected var m_paintEngine:PaintEngine;
        protected var m_layers:LayerBitmapCollection;
        private var m_horizontalMirrorMatrix:Matrix;
        private var m_verticalMirrorMatrix:Matrix;
        private var m_altDrawingSprite:Sprite;
        private var m_shouldCopyBitmap:Boolean;
    }
}
