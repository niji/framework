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
/// @cond
package com.github.niji.framework
{
/// @endcond
    import com.github.niji.framework.errors.NotSupportedVersionError;
    
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.events.EventDispatcher;
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    /**
     * 再生及び記録のための共通基盤となるクラスです.
     * 
     * <p>実際の処理は Painter または PaintEngine に委譲する</p>
     */
    public class Painter extends EventDispatcher
    {
        /**
         * レイヤー選択をアンドゥに含めるかどうかのオプション
         */
        public static const COMPATIBILITY_UNDO_LAYER:uint = 1;
        
        /**
         * 1 ピクセル以上の大きさを持つ PixelCommand を有効にするかどうかのオプション
         */
        public static const COMPATIBILITY_BIG_PIXEL:uint = 2;
        
        /**
         * レイヤー配列の生成及び描画状態を初期化して Painter を生成します
         *
         * @param width 画像の幅
         * @param height 画像の高さ
         * @param version ログのバージョン
         * @param paintEngine PaintEngine オブジェクト
         */
        public function Painter(width:uint, height:uint, version:uint, paintEngine:PaintEngine)
        {
            enableBigPixel = true;
            enableUndoLayer = false;
            m_layers = new LayerList(width, height);
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
         * バージョン番号からペイントエンジンオブジェクトを返します
         *
         * @param uint バージョン番号
         * @return PaintEngine ペイントエンジンオブジェクト
         * @see PaintEngine
         */
        public static function createPaintEngine(version:uint):PaintEngine
        {
            var shape:Shape = new Shape();
            if (version > 0 && version <= 10) {
                return new PaintEngineV1(shape);
            }
            else if (version > 10 && Version.compareLogVersion(version) <= 0) {
                return new PaintEngineV2(shape);
            }
            else {
                throw new NotSupportedVersionError(version.toString());
            }
        }
        
        /**
         * お絵描き操作の巻き戻しを実行します
         */
        public function undo():void
        {
            m_undo.undo(m_layers);
        }
        
        /**
         * お絵描き操作のやり直しを実行します
         */
        public function redo():void
        {
            m_undo.redo(m_layers);
        }
        
        /**
         * 現在のお絵描き操作をアンドゥログを追加します
         */
        public function pushUndo():void
        {
            m_undo.push(m_layers);
        }
        
        /**
         * 必要であれば現在のお絵描き操作をアンドゥログに追加します.
         * 
         * <p>
         * これはレイヤー操作もアンドゥログに含まれていた為、ログのバージョンが古いか、
         * レイヤー操作もアンドゥに含めてもいい選択が入っている場合にアンドゥログに追加します
         * </p>
         */
        public function pushUndoIfNeed():void
        {
            if (m_version <= 21 || enableUndoLayer)
                pushUndo();
        }
        
        /**
         * 現在位置を変更します.
         * 
         * <p>PaintEngine クラスにある moveTo の委譲です</p>
         * 
         * @param x 移動先となる X 座標
         * @param y 移動先となる Y 座標
         * @see PaintEngine#moveTo()
         */
        public function moveTo(x:Number, y:Number):void
        {
            m_paintEngine.moveTo(x, y);
        }
        
        /**
         * 現在位置から指定された位置まで線を描写します.
         * 
         * <p>PaintEngine クラスにある lineTo の委譲です</p>
         * 
         * @param x 描写先となる X 座標
         * @param y 描写先となる Y 座標
         * @see PantEngine#lineTo()
         */
        public function lineTo(x:Number, y:Number):void
        {
            m_paintEngine.lineTo(x, y);
        }
        
        /**
         * 矩形を描写します.
         * 
         * <p>PaintEngine クラスにある drawRect の委譲です</p>
         * 
         * @param x 基準点となる X 座標
         * @param y 基準点となる Y 座標
         * @param width 幅
         * @param height 高さ
         * @see PaintEngine#drawRect()
         */
        public function drawRect(width:int, height:int):void
        {
            m_paintEngine.drawRect(width, height);
        }
        
        /**
         * 楕円を描写します.
         * 
         * <p>PainterEngine クラスにある drawEllipse の委譲です</p>
         * 
         * @param x 基準点となる X 座標
         * @param y 基準点となる Y 座標
         * @param width 幅
         * @param height 高さ
         * @see PaintEngine#drawEllipse()
         */
        public function drawEllipse(width:int, height:int):void
        {
            m_paintEngine.drawEllipse(width, height);
        }
        
        /**
         * 塗りつぶしを開始します.
         * 
         * <p>PaintEngine クラスにある beginFill の委譲です</p>
         * 
         * @param color 塗りつぶす色
         * @param alpha 透明度
         * @see PaintEngine#beginFill()
         */
        public function beginFill(color:uint, alpha:Number):void
        {
            m_paintEngine.beginFill(color, alpha);
        }
        
        /**
         * 現在の位置から円弧を描写します.
         * 
         * <p>PaintEngine クラスにある drawCircle の委譲です</p>
         * 
         * @param radius 半径
         * @see PaintEngine#drawCircle()
         */
        public function drawCircle(radius:Number):void
        {
            m_paintEngine.drawCircle(radius);
        }
        
        /**
         * 塗りつぶしを終了します.
         * 
         * <p>PaintEngine クラスにある endFill の委譲です</p>
         * 
         * @see PaintEngine#endFill()
         */
        public function endFill():void
        {
            m_paintEngine.endFill();
        }
        
        /**
         * ペンオブジェクトを初期状態にリセットします.
         * 
         * <p>PaintEngine クラスにある resetPen の委譲です</p>
         * 
         * @see PaintEngine#resetPen()
         */
        public function resetPen():void
        {
            m_paintEngine.resetPen();
        }
        
        /**
         * 描写中の内容を消去します.
         * 
         * <p>PainterEngine クラスにある clear の委譲です</p>
         * 
         * @see PaintEngine#clear()
         */
        public function clear():void
        {
            m_paintEngine.clear();
        }
        
        /**
         * PainterEngine クラスに描写された中身を現在のレイヤーに反映させます.
         * 
         * <p>Pen クラスのブレンドモードを適用します</p>
         * 
         * @see LayerBitmap#compositeFrom()
         * @see PaintEngine#blendMode
         */
        public function composite():void
        {
            // undoBuffer に入っているLayerBitmapを上書きしない為にコピーしてから作業する
            // これは floodFill 及び setPixel も同様
            BitmapLayer(m_layers.currentLayer).compositeFrom(
                m_paintEngine.shapeToPaint,
                m_paintEngine.pen.blendMode
            );
            m_layers.compositeAll();
        }
        
        /**
         * 塗りつぶしを行います.
         * 
         * <p>PainterEngine クラスの現在位置と Pen クラスの色を適用します</p>
         * 
         * @see LayerBitmap#floodFill()
         * @see PaintEngine#argb
         */
        public function floodFill():void
        {
            BitmapLayer(m_layers.currentLayer).floodFill(
                m_paintEngine.x,
                m_paintEngine.y,
                m_paintEngine.pen.argb
            );
            m_layers.compositeAll();
        }
        
        /**
         * 1 ピクセルを描写します.
         * 
         * <p>現在の Pen クラスの色を適用します</p>
         * 
         * @param x 描写先となる X 座標
         * @param y 描写先となる Y 座標
         * @see LayerBitmap#setPixel()
         */
        public function setPixel(x:int, y:int):void
        {
            BitmapLayer(m_layers.currentLayer).setPixel(x, y, m_paintEngine.pen.argb);
            m_layers.compositeAll();
        }
        
        /**
         * 特定のピクセルの色を取得します。不透明度は取得しません
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
         * 特定のピクセルの色を取得します。不透明度も含まれます
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
         * レイヤーの可視状態を変更します
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
         * 指定されたレイヤーに対して水平方向に鏡面処理を実行します
         * 
         * @param index レイヤー番号
         */
        public function transformWithHorizontalMirrorAt(index:int):void
        {
            m_layers.transformAt(index, m_horizontalMirrorMatrix);
        }
        
        /**
         * 指定されたレイヤーに対して垂直方向に鏡面処理を実行します
         * 
         * @param index レイヤー番号
         */
        public function transformWithVerticalMirrorAt(index:int):void
        {
            m_layers.transformAt(index, m_verticalMirrorMatrix);
        }
        
        /**
         * 現在のレイヤーに対して平行移動を行います
         * 
         * @param x 移動先となるX座標
         * @param y 移動先となるY座標
         */
        public function move(x:int, y:int):void
        {
            moveAt(m_layers.currentIndex, x, y);
        }
        
        /**
         * 指定されたレイヤーに対して平行移動を行います
         * 
         * @param index レイヤー番号
         * @param x 移動先となるX座標
         * @param y 移動先となるY座標
         */
        public function moveAt(index:int, x:int, y:int):void
        {
            m_moveMatrix.translate(x, y);
            BitmapLayer(m_layers.at(index)).transform(m_moveMatrix);
            m_layers.compositeAll();
        }
        
        /**
         * 現在のレイヤーに対して拡大または縮小を行います
         * 
         * @param x 移動先となるX座標
         * @param y 移動先となるY座標
         */
        public function scale(x:int, y:int):void
        {
            scaleAt(m_layers.currentIndex, x, y);
        }
        
        /**
         * 指定されたレイヤーに対して拡大または縮小を行います
         * 
         * @param index レイヤー番号
         * @param x 移動先となるX座標
         * @param y 移動先となるY座標
         */
        public function scaleAt(index:int, x:int, y:int):void
        {
            m_scaleMatrix.scale(x, y);
            BitmapLayer(m_layers.at(index)).transform(m_scaleMatrix);
            m_layers.compositeAll();
        }
        
        /**
         * 描写開始を宣言します.
         * 
         * <p>
         * 全てのレイヤーに対してではなく、現在のレイヤーのみにブレンドモードが
         * 適用されるように Sprite の変更が行われます。
         * </p>
         */
        public function startDrawing():void
        {
            m_layers.startDrawing(m_paintEngine);
        }
        
        /**
         * 現在描画中かどうかを返します
         * 
         * @return Boolean
         */
        public function isDrawing():Boolean
        {
            return m_layers.isDrawing();
        }
        
        /**
         * 描写終了を宣言します
         */
        public function stopDrawing():void
        {
            m_layers.stopDrawing(m_paintEngine);
        }
        
        /**
         * 連結されたレイヤー画像とメタデータから復元した上でアンドゥ情報を再設定します
         *
         * @param layerBitmaps 縦に連結されたレイヤー画像
         * @param metadata メタデータ
         * @see LayerBitmapCollection#load()
         * @see LayerBitmapCollection#newLayerBitmapData
         */
        public function load(layerBitmap:BitmapData, metadata:Object):void
        {
            m_layers.load(layerBitmap, metadata);
            m_undo = new UndoStack(m_layers, m_undo.size);
        }
        
        /**
         * 座標の補正を行ないます.
         * 
         * <p>
         * PaintEngine#correctCoordinate の移譲です
         * </p>
         * 
         * @param coordinate 補正対象の座標となる Point オブジェクト
         * @see PaintEngine#correctCoordinate()
         */
        public function correctCoordinate(coordinate:Point):void
        {
            m_paintEngine.correctCoordinate(coordinate);
        }
        
        /**
         * レイヤーオブジェクトを返します
         */
        public function get layers():LayerList
        {
            return m_layers;
        }
        
        /**
         * ペンオブジェクトを返します
         */
        public function get pen():Pen
        {
            return m_paintEngine.pen;
        }
        
        /**
         * 現在のお絵描きログのバージョンを返します
         */
        public function get version():uint
        {
            return m_version;
        }
        
        /**
         * 描写するキャンバスの幅を返します
         */
        public function get width():uint
        {
            return m_layers.width;
        }
        
        /**
         * 描写するキャンバスの高さを返します
         */
        public function get height():uint
        {
            return m_layers.height;
        }
        
        /**
         * UndoStack オブジェクトを返します
         */
        public function get undoStack():UndoStack
        {
            return m_undo;
        }
        
        /**
         * @private
         */
        public function get paintEngine():PaintEngine
        {
            return m_paintEngine;
        }
        
        /**
         * 現在のレイヤーの透明度を変更します
         */
        public function set currentLayerAlpha(value:Number):void
        {
            m_layers.currentLayer.alpha = value;
            m_layers.compositeAll();
        }
        
        /**
         * 現在のブレンドモードを変更します
         */
        public function set currentLayerBlendMode(value:String):void
        {
            m_layers.currentLayer.blendMode = value;
            m_layers.compositeAll();
        }
        
        /**
         * ペンオブジェクトを設定します
         */
        public function set pen(value:Pen):void
        {
            m_paintEngine.pen.setPen(value);
        }
        
        /**
         * ログのバージョンを設定します
         */
        internal function setVersion(value:uint):void
        {
            m_version = value;
        }
        
        /**
         * UndoStack オブジェクトを設定します
         */
        internal function setUndoStack(value:UndoStack):void
        {
            m_undo = value;
        }
        
        /**
         * レイヤー位置の変更を巻き戻しに含めるかを設定します
         * 
         * @default true
         */
        public var enableUndoLayer:Boolean;
        
        /**
         * 大きなピクセルを有効にするかを設定します
         * 
         * @default true
         */
        public var enableBigPixel:Boolean;
        
        // テストでLayerBitmapCollectionの差し替えを行うため敢えてprotected にしてある
        protected var m_layers:LayerList;
        private var m_paintEngine:PaintEngine;
        private var m_horizontalMirrorMatrix:Matrix;
        private var m_verticalMirrorMatrix:Matrix;
        private var m_moveMatrix:Matrix;
        private var m_scaleMatrix:Matrix;
        private var m_version:uint;
        private var m_undo:UndoStack;
    }
}
