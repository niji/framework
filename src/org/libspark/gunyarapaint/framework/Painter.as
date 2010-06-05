package org.libspark.gunyarapaint.framework
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.EventDispatcher;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import org.libspark.gunyarapaint.framework.errors.NotSupportedVersionError;
    
    /**
     * 再生及び記録のための共通基盤。実際の処理は Painter または PaintEngine に委譲する
     * 
     */
    public class Painter extends EventDispatcher
    {
        /**
         * ログのバージョン番号
         * 
         */
        public static const PAINTER_LOG_VERSION:uint = 22;
        
        /**
         * ペインター自体のバージョン
         * 
         */
        public static const PAINTER_VERSION:uint = 20100401;
        
        /**
         * ペインターのバージョン文字列
         * 
         */
        public static const PAINTER_VERSION_STRING:String = "ver." + PAINTER_VERSION;
        
        /**
         * レイヤー選択をアンドゥに含めるかどうかのオプション
         *
         */
        public static const COMPATIBILITY_UNDO_LAYER:uint = 1;
        
        /**
         * 1 ピクセル以上の大きさを持つ PixelCommand を有効にするかどうかのオプション
         *
         */
        public static const COMPATIBILITY_BIG_PIXEL:uint = 2;
        
        /**
         * 反転関連で全てのレイヤーに対して適用するための定数
         * 
         */
        public static const ALL_LAYERS:uint = 0xff;
        
        public function Painter(width:uint, height:uint, version:uint, paintEngine:PaintEngine)
        {
            enableBigPixel = true;
            enableUndoLayer = false;
            m_layers = new LayerBitmapCollection(width, height);
            m_layers.compositeAll();
            m_horizontalMirrorMatrix = new Matrix(-1, 0, 0, 1, width, 0);
            m_verticalMirrorMatrix = new Matrix(1, 0, 0, -1, 0, height);
            m_moveMatrix = new Matrix();
            m_scaleMatrix = new Matrix();
            m_paintEngine = paintEngine;
            m_version = version;
            super();
        }
        
        /**
         * バージョン番号からペイントエンジンオブジェクトを返す
         *
         * @param uint バージョン番号
         * @return PaintEngine ペイントエンジンオブジェクト
         */
        public static function createPaintEngine(version:uint):PaintEngine
        {
            var shape:Shape = new Shape();
            if (version > 0 && version <= 10) {
                return new PaintEngineV1(shape);
            }
            else if (version > 10 && version <= PAINTER_LOG_VERSION) {
                return new PaintEngineV2(shape);
            }
            else {
                throw new NotSupportedVersionError(version.toString());
            }
        }
        
        /**
         * お絵描き操作の巻き戻しを実行する
         */
        public function undo():void
        {
            m_undo.undo(m_layers);
        }
        
        /**
         * お絵描き操作のやり直しを実行する
         */
        public function redo():void
        {
            m_undo.redo(m_layers);
        }
        
        /**
         * 現在のお絵描き操作をアンドゥログを追加する
         */
        public function pushUndo():void
        {
            m_undo.push(m_layers);
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
            if (m_version <= 21 || enableUndoLayer)
                pushUndo();
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
            m_layers.at(index).visible = visible;
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
         * 現在のレイヤーに対して平行移動を行う
         * 
         * @param x 移動先となるX座標
         * @param y 移動先となるY座標
         */
        public function move(x:int, y:int):void
        {
            moveAt(m_layers.currentIndex, x, y);
        }
        
        /**
         * 指定されたレイヤーに対して平行移動を行う
         * 
         * @param index レイヤー番号
         * @param x 移動先となるX座標
         * @param y 移動先となるY座標
         */
        public function moveAt(index:int, x:int, y:int):void
        {
            m_moveMatrix.translate(x, y);
            m_layers.at(index).applyMatrix(m_moveMatrix);
            m_layers.compositeAll();
        }
        
        /**
         * 現在のレイヤーに対して拡大または縮小を行う
         * 
         * @param x 移動先となるX座標
         * @param y 移動先となるY座標
         */
        public function scale(x:int, y:int):void
        {
            scaleAt(m_layers.currentIndex, x, y);
        }
        
        /**
         * 指定されたレイヤーに対して拡大または縮小を行う
         * 
         * @param index レイヤー番号
         * @param x 移動先となるX座標
         * @param y 移動先となるY座標
         */
        public function scaleAt(index:int, x:int, y:int):void
        {
            m_scaleMatrix.scale(x, y);
            m_layers.at(index).applyMatrix(m_scaleMatrix);
            m_layers.compositeAll();
        }
        
        /**
         * 描写開始を宣言する
         * 
         * <p>
         * 全てのレイヤーに対してではなく、現在のレイヤーのみにブレンドモードが
         * 適用されるように Sprite の変更が行われる。
         * </p>
         */
        public function startDrawing():void
        {
            m_layers.startDrawing(m_paintEngine);
        }
        
        /**
         * 描写終了を宣言する
         * 
         */
        public function stopDrawing():void
        {
            m_layers.stopDrawing(m_paintEngine);
        }
        
        public function correctCoordinate(coordinate:Point):void
        {
            m_paintEngine.correctCoordinate(coordinate);
        }
        
        private function transformFromMatrixAt(index:int, matrix:Matrix):void
        {
            if (index === ALL_LAYERS) {
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
        
        /**
         * レイヤーオブジェクトを返す
         * 
         */
        public function get layers():LayerBitmapCollection
        {
            return m_layers;
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
         */
        public function get version():uint
        {
            return m_version;
        }
        
        /**
         * 描写するキャンバスの幅を返す
         * 
         */
        public function get width():uint
        {
            return m_layers.width;
        }
        
        /**
         * 描写するキャンバスの高さを返す
         * 
         */
        public function get height():uint
        {
            return m_layers.height;
        }
        
        /**
         * UndoStack オブジェクトを返す
         * 
         */
        public function get undoStack():UndoStack
        {
            return m_undo;
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
            m_paintEngine.pen.setPen(value);
        }
        
        /**
         * ログのバージョンを設定する
         * 
         */
        internal function setVersion(value:uint):void
        {
            m_version = value;
        }
        
        /**
         * UndoStack オブジェクトを設定する
         * 
         */
        internal function setUndoStack(value:UndoStack):void
        {
            m_undo = value;
        }
        
        public var enableUndoLayer:Boolean;
        
        public var enableBigPixel:Boolean;
        
        // テストでLayerBitmapCollectionの差し替えを行うため敢えてprotected にしてある
        protected var m_layers:LayerBitmapCollection;
        private var m_paintEngine:PaintEngine;
        private var m_horizontalMirrorMatrix:Matrix;
        private var m_verticalMirrorMatrix:Matrix;
        private var m_moveMatrix:Matrix;
        private var m_scaleMatrix:Matrix;
        private var m_version:uint;
        private var m_undo:UndoStack;
    }
}
