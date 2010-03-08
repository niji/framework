package org.libspark.gunyarapaint.framework
{
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.EventDispatcher;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import org.libspark.gunyarapaint.framework.errors.NotSupportedVersionError;
    import org.libspark.gunyarapaint.framework.events.UndoEvent;
    
    /**
     * 再生及び記録のための共通基盤
     * 
     * @todo: Painter の実装を取り入れる
     */
    public class CanvasContext extends EventDispatcher
    {
        /**
         * ログのバージョン番号
         * 
         */
        public static const PAINTER_LOG_VERSION:uint = 10;
        
        /**
         * ペインター自体のバージョン
         * 
         */
        public static const PAINTER_VERSION:uint = 20100301;
        
        /**
         * ペインターのバージョン文字列
         * 
         */
        public static const PAINTER_VERSION_STRING:String = "ver." + PAINTER_VERSION;
        
        public function CanvasContext(width:uint, height:uint, paintEngine:PaintEngine)
        {
            m_coordinate = new Point();
            m_layers = new LayerBitmapCollection(width, height);
            m_drawingSprite = new Sprite();
            m_drawingSprite.mouseEnabled = false;
            m_horizontalMirrorMatrix = new Matrix(-1, 0, 0, 1, width, 0);
            m_verticalMirrorMatrix = new Matrix(1, 0, 0, -1, 0, height);
            m_version = PAINTER_LOG_VERSION;
        }
        
        /**
         * お絵描き操作の巻き戻しを実行する
         */
        public function undo():void
        {
            m_undo.undo(this);
            if (hasEventListener(UndoEvent.UNDO))
                dispatchEvent(new UndoEvent(UndoEvent.UNDO, m_undo.undoCount, m_undo.redoCount));
        }
        
        /**
         * お絵描き操作のやり直しを実行する
         */
        public function redo():void
        {
            m_undo.redo(this);
            if (hasEventListener(UndoEvent.REDO))
                dispatchEvent(new UndoEvent(UndoEvent.REDO, m_undo.undoCount, m_undo.redoCount));
        }
        
        /**
         * 現在のお絵描き操作をアンドゥログを追加する
         */
        public function pushUndo():void
        {
            m_undo.push(this);
            if (hasEventListener(UndoEvent.PUSH))
                dispatchEvent(new UndoEvent(UndoEvent.PUSH, m_undo.undoCount, m_undo.redoCount));
        }
        
        /**
         * 必要であれば現在のお絵描き操作をアンドゥログに追加する
         * 
         * <p>
         * これはレイヤー操作もアンドゥログに含まれていた為、ログのバージョンが古いか、
         * レイヤー操作もアンドゥに含めてもいい選択が入っている場合にアンドゥログに追加する
         * </p>
         */
        public function pushUndoIfNeed():void
        {
            if (m_version <= 21)
                pushUndo();
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
         * <p>
         * PainterEngine クラスにある moveTo の委譲
         * </p>
         * 
         * @param x 移動先となる X 座標
         * @param y 移動先となる Y 座標
         */
        public function moveTo(x:Number, y:Number):void
        {
            m_paintEngine.moveTo(x, y);
        }
        
        /**
         * 現在位置から指定された位置まで線を描写する
         * 
         * <p>
         * PainterEngine クラスにある lineTo の委譲
         * </p>
         * 
         * @param x 描写先となる X 座標
         * @param y 描写先となる Y 座標
         */
        public function lineTo(x:Number, y:Number):void
        {
            m_paintEngine.lineTo(x, y);
        }
        
        /**
         * 矩形を描写する
         * 
         * <p>
         * PainterEngine クラスにある drawRect の委譲
         * </p>
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
         * <p>
         * PainterEngine クラスにある drawEllipse の委譲
         * </p>
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
         * <p>
         * PainterEngine クラスにある beginFill の委譲
         * </p>
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
         * <p>
         * PainterEngine クラスにある drawCircle の委譲
         * </p>
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
         * <p>
         * PainterEngine クラスにある endFill の委譲
         * </p>
         * 
         */
        public function endFill():void
        {
            m_paintEngine.endFill();
        }
        
        /**
         * ペンオブジェクトを初期状態にリセットする
         * 
         * <p>
         * PainterEngine クラスにある resetPen の委譲
         * </p>
         * 
         */
        public function resetPen():void
        {
            m_paintEngine.resetPen();
        }
        
        /**
         * 描写中の内容を消去する
         * 
         * <p>
         * PainterEngine クラスにある clear の委譲
         * </p>
         * 
         */
        public function clear():void
        {
            m_paintEngine.clear();
        }
        
        /**
         * PainterEngine クラスに描写された中身を現在のレイヤーに反映させる
         * 
         * <p>
         *  Pen クラスのブレンドモードを適用する
         * </p>
         * 
         */
        public function composite():void
        {
            // undoBuffer に入っているLayerBitmapを上書きしない為にコピーしてから作業する
            // これは floodFill 及び setPixel も同様
            m_layers.currentLayer.compositeFrom(
                m_paintEngine.shape,
                m_paintEngine.pen.blendMode
            );
            m_layers.compositeAll();
        }
        
        /**
         * 塗りつぶしを行う 
         * 
         * <p>
         * PainterEngine クラスの現在位置と Pen クラスの色を適用する
         * </p>
         * 
         */
        public function floodFill():void
        {
            m_layers.currentLayer.floodFill(
                m_paintEngine.x,
                m_paintEngine.y,
                m_paintEngine.pen.argb
            );
            m_layers.compositeAll();
        }
        
        /**
         * 1 ピクセルを描写する
         * 
         * <p>
         * 現在の Pen クラスの色を適用する
         * </p>
         * 
         * @param x 描写先となる X 座標
         * @param y 描写先となる Y 座標
         */
        public function setPixel(x:int, y:int):void
        {
            m_layers.currentLayer.setPixel(x, y, m_paintEngine.pen.argb);
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
        
        /**
         * 指定されたレイヤーに対して水平方向に鏡面処理を実行する
         * 
         * @param index レイヤー番号
         */
        public function transformWithHorizontalMirrorAt(index:int):void
        {
            transformFromMatrixAt(index, m_horizontalMirrorMatrix);
        }
        
        /**
         * 指定されたレイヤーに対して垂直方向に鏡面処理を実行する
         * 
         * @param index レイヤー番号
         */
        public function transformWithVerticalMirrorAt(index:int):void
        {
            transformFromMatrixAt(index, m_verticalMirrorMatrix);
        }
        
        /**
         * 描写開始を宣言する
         * 
         * <p>
         * 全てのレイヤーに対してではなく、現在のレイヤーのみにブレンドモードが
         * 適用されるように Sprite の変更が行われる。
         * </p>
         */
        public function startDrawingSession():void
        {
            if (m_tempLayer == null) {
                var currentLayer:LayerBitmap = m_layers.currentLayer;
                var blendMode:String = currentLayer.blendMode;
                m_paintEngine.resetPen();
                m_drawingSprite.blendMode =
                    blendMode == BlendMode.NORMAL ? BlendMode.LAYER : blendMode;
                m_drawingSprite.alpha = currentLayer.alpha;
                m_tempLayer = currentLayer.clone(false);
                m_tempLayer.blendMode = BlendMode.NORMAL;
                m_tempLayer.alpha = 1.0;
                m_drawingSprite.addChild(m_tempLayer);
                m_drawingSprite.addChild(m_paintEngine.shape);
                var sprite:Sprite = m_layers.spriteToView;
                sprite.removeChild(currentLayer);
                sprite.addChildAt(m_drawingSprite, m_layers.currentIndex);
            }
        }
        
        /**
         * 描写終了を宣言する
         * 
         */
        public function stopDrawingSession():void
        {
            if (m_tempLayer != null) {
                var sprite:Sprite = m_layers.spriteToView;
                var currentLayer:LayerBitmap = m_layers.currentLayer;
                var blendMode:String = m_drawingSprite.blendMode;
                currentLayer.blendMode =
                    blendMode == BlendMode.LAYER ? BlendMode.NORMAL : blendMode;
                currentLayer.alpha = m_drawingSprite.alpha;
                sprite.removeChild(m_drawingSprite);
                sprite.addChildAt(currentLayer, m_layers.currentIndex);
                m_paintEngine.clear();
                m_drawingSprite.removeChild(m_tempLayer);
                m_drawingSprite.removeChild(m_paintEngine.shape);
                m_tempLayer = null;
            }
        }
        
        public function correctCoordinate(coordinate:Point):void
        {
            m_paintEngine.correctCoordinate(coordinate);
        }
        
        protected function createPaintEngine(version:uint):PaintEngine
        {
            var shape:Shape = new Shape();
            if (version > 0 && version <= 10) {
                return new PaintEngineV1(shape);
            }
            else if (version > 10 && version <= 21) {
                return new PaintEngineV2(shape);
            }
            else {
                throw new NotSupportedVersionError(version.toString());
            }
        }
        
        private function transformFromMatrixAt(index:int, matrix:Matrix):void
        {
            if (index === 0xff) {
                var c:uint = m_layers.count;
                for (var i:uint = 0; i < c; i++) {
                    m_layers.at(i).applyMatrix(matrix);
                }
            }
            else {
                m_layers.currentLayer.applyMatrix(matrix);
            }
            m_layers.compositeAll();
        }
        
        internal function saveState():Object
        {
            var count:uint = m_layers.count;
            var layers:Vector.<LayerBitmap> = new Vector.<LayerBitmap>(
                count, true
            );
            for (var i:uint = 0; i < count; i++) {
                var layer:LayerBitmap = m_layers.layers[i].clone();
                layers[i] = layer;
            }
            var undoData:Object = {};
            undoData.index = m_layers.currentIndex;
            undoData.layers = layers;
            return undoData;
        }
        
        internal function restoreState(undoData:Object):void
        {
            var i:uint = 0;
            m_layers.clear();
            var count:uint = undoData.layers.length;
            var sprite:Sprite = m_layers.spriteToView;
            for (i = 0; i < count; i++) {
                var layer:LayerBitmap = undoData.layers[i].clone();
                m_layers.layers.push(layer);
                sprite.addChild(layer);
            }
            m_layers.currentIndex = undoData.index;
            m_layers.compositeAll();
        }
        
        /**
         * レイヤーオブジェクトを返す
         * 
         */
        public function get layers():LayerBitmapCollection
        {
            return m_layers;
        }
        
        /**
         * スプライトオブジェクトを返す
         * 
         */
        public function get view():Sprite
        {
            return m_layers.spriteToView;
        }
        
        /**
         * ペンオブジェクトを返す
         * 
         */
        public function get pen():Pen
        {
            return m_paintEngine.pen;
        }
        
        /**
         * 現在のお絵描きログのバージョンを返す
         * 
         * @return ログのバージョン
         */
        public function get version():uint
        {
            return m_version;
        }
        
        /**
         * 描写するキャンバスの幅を返す
         * 
         * @return 画像の幅
         */
        public function get width():uint
        {
            return m_width;
        }
        
        /**
         * 描写するキャンバスの高さを返す
         * 
         * @return 画像の高さ
         */
        public function get height():uint
        {
            return m_height;
        }
        
        /**
         * 現在のレイヤーの透明度を変更する
         * 
         */
        public function set currentLayerAlpha(value:Number):void
        {
            m_layers.currentLayer.alpha = value;
            m_layers.compositeAll();
        }
        
        /**
         * 現在のブレンドモードを変更する
         * 
         */
        public function set currentLayerBlendMode(value:String):void
        {
            m_layers.currentLayer.blendMode = value;
            m_layers.compositeAll();
        }
        
        /**
         * ペンオブジェクトを設定する
         * 
         */
        public function set pen(value:Pen):void
        {
            m_paintEngine.pen = value;
        }
        
        /**
         * UndoStack オブジェクトを設定する
         * 
         * @return ログのバージョン
         */
        internal function setUndo(value:UndoStack):void
        {
            m_undo = value;
        }
        
        private var m_paintEngine:PaintEngine;
        private var m_layers:LayerBitmapCollection;
        private var m_horizontalMirrorMatrix:Matrix;
        private var m_verticalMirrorMatrix:Matrix;
        private var m_drawingSprite:Sprite;
        private var m_tempLayer:LayerBitmap;
        private var m_shouldCopyBitmap:Boolean;
        private var m_version:uint;
        private var m_undo:UndoStack;
        private var m_coordinate:Point;
        private var m_width:uint;
        private var m_height:uint;
    }
}
