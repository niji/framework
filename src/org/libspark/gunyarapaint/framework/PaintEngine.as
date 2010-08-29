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
package org.libspark.gunyarapaint.framework
{
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.geom.Point;
    
    import org.libspark.gunyarapaint.framework.vg.VGLayer;
    import org.libspark.gunyarapaint.framework.vg.VGPoint;
    
    /**
     * Graphics に描写を委譲するクラスです.
     * 
     * <p>
     * Graphics がサブクラス出来無いクラスであるため、代わりにGraphicsの処理を
     * 受け持つという方法を適用しています。これにより FlexUnit による単体テストを
     * しやすくします。
     * </p>
     */
    public class PaintEngine
    {
        /**
         * Shape オブジェクトから描画エンジンを生成します
         * 
         * @param shape 描画対象となる Shape オブジェクト
         */
        public function PaintEngine(shape:Shape)
        {
            m_coordinate = new Point();
            m_pen = new Pen();
            m_shape = shape;
            m_graphics = shape.graphics;
        }
        
        /**
         * Graphics オブジェクトの描写内容を消去します
         * 
         */
        public function clear():void
        {
            m_graphics.clear();
        }
        
        /**
         * Graphics の現在位置を変更します
         * 
         * @param x 移動先となる X 座標
         * @param y 移動先となる Y 座標
         * @see flash.display.Graphics#moveTo
         */
        public function moveTo(x:Number, y:Number):void
        {
            m_coordinate.x = x;
            m_coordinate.y = y;
            correctCoordinate(m_coordinate);
            m_graphics.moveTo(m_coordinate.x, m_coordinate.y);
        }
        
        /**
         * Graphics の現在位置から指定された座標まで線を描写します
         * 
         * @param x 描写先となる X 座標
         * @param y 描写先となる Y 座標
         * @see flash.display.Graphics#lineTo
         */
        public function lineTo(x:Number, y:Number):void
        {
            m_coordinate.x = x;
            m_coordinate.y = y;
            correctCoordinate(m_coordinate);
            m_graphics.lineTo(m_coordinate.x, m_coordinate.y);
        }
        
        /**
         * 矩形を描写します
         * 
         * @param x 基準点となる X 座標
         * @param y 基準点となる Y 座標
         * @param width 幅
         * @param height 高さ
         * @see flash.display.Graphics#drawRect
         */
        public function drawRect(x:Number, y:Number,
                                 width:uint, height:uint):void
        {
            m_graphics.drawRect(x, y, width, height);
        }
        
        /**
         * 楕円を描写します
         * 
         * @param x 基準点となる X 座標
         * @param y 基準点となる Y 座標
         * @param width 幅
         * @param height 高さ
         * @see flash.display.Graphics#drawEllipse
         */
        public function drawEllipse(x:Number, y:Number,
                                    width:uint, height:uint):void
        {
            m_graphics.drawEllipse(x, y, width, height);
        }
        
        /**
         * 塗りつぶしを開始します
         * 
         * @param color 塗りつぶす色
         * @param alpha 透明度
         * @see flash.display.Graphics#beginFill
         */
        public function beginFill(color:uint, alpha:Number):void
        {
            m_graphics.beginFill(color, alpha);
        }
        
        /**
         * 現在の位置から円弧を描写します
         * 
         * @param radius 半径
         * @see flash.display.Graphics#drawCircle
         */
        public function drawCircle(radius:Number):void
        {
            m_graphics.drawCircle(
                m_coordinate.x,
                m_coordinate.y,
                radius
            );
        }
        
        /**
         * 塗りつぶしを終了します
         * 
         * @see flash.display.Graphics#endFill
         */
        public function endFill():void
        {
            m_graphics.endFill();
        }
        
        /**
         * 現在のVGLayerの座標リストからベジエ曲線を描画します
         * 
         * @param layer
         */
        public function drawVG(layer:VGLayer):void
        {
            var g:Graphics = m_graphics;
            var coordinates:Vector.<VGPoint> = layer.coordinates;
            var count:uint = coordinates.length;
            var point:VGPoint;
            // draw background
            g.clear();
            g.beginFill(0x0, 0);
            g.drawRect(0, 0, m_shape.width, m_shape.height);
            g.endFill();
            g.lineStyle(0.5, 0xaaffaa);
            if (!layer.closed)
                drawVGAuxLines(layer);
            // draw Bezier lines
            if (count > 1) {
                var anchor:Point = coordinates[0].anchorPoint;
                g.lineStyle(0.5, 0x0000ff);
                g.moveTo(anchor.x, anchor.y);
                for (var i:uint = 1; i < count; i++) {
                    var prev:VGPoint = coordinates[i - 1];
                    var current:VGPoint = coordinates[i];
                    drawBezierCurve(prev, current);
                }
            }
        }
        
        /**
         * 現在のVGLayerの座標リストからベジエ曲線のための補助線を描画します
         * 
         * @param layer
         */
        public function drawVGAuxLines(layer:VGLayer):void
        {
            var coordinates:Vector.<VGPoint> = layer.coordinates;
            var count:uint = coordinates.length;
            var g:Graphics = m_graphics;
            // draw lines between each control points
            for (var i:uint = 0; i < count; i++) {
                var point:VGPoint = coordinates[i];
                var anchor:Point = point.anchorPoint;
                var cf:Point = point.controlPointForward;
                var cb:Point = point.controlPointBack;
                g.moveTo(cb.x, cb.y);
                g.lineTo(anchor.x, anchor.y);
                g.lineTo(cf.x, cf.y);
            }
        }
        
        /**
         * 現在のVGLayerの座標リストからベジエ曲線のための補助点を描画します
         * 
         * @param layer
         */
        public function drawVGAuxPoints(layer:VGLayer):void
        {
            var coordinates:Vector.<VGPoint> = layer.coordinates;
            var count:uint = coordinates.length;
            var g:Graphics = m_graphics;
            var i:uint = 0;
            // draw anchor points
            g.lineStyle(0, 0, 0);
            g.beginFill(0x0000ff);
            for (i = 0; i < count; i++) {
                var anchor:Point = coordinates[i].anchorPoint;
                g.drawCircle(anchor.x, anchor.y, 1.5);
            }
            g.endFill();
            // draw control points
            g.beginFill(0x00ff00);
            for (i = 0; i < count; i++) {
                var point:VGPoint = coordinates[i];
                var cf:Point = point.controlPointForward;
                var cb:Point = point.controlPointBack;
                g.drawCircle(cf.x, cf.y, 1.5);
                g.drawCircle(cb.x, cb.y, 1.5);
            }
            g.endFill();
        }
        
        /**
         * ベジエ曲線を描画します
         * 
         * @param prev
         * @param current
         */
        public function drawBezierCurve(prev:VGPoint, current:VGPoint):void
        {
            var curvePoints:Vector.<Point> = getBezierCurvePoints(
                prev.anchorPoint,
                prev.controlPointForward,
                current.controlPointBack,
                current.anchorPoint
            );
            var len:uint = curvePoints.length;
            var g:Graphics = m_graphics;
            for (var i:int = 0; i < len; i++) {
                var curvePoint:Point = curvePoints[i];
                g.lineTo(curvePoint.x, curvePoint.y);
            }
        }
        
        /**
         * 座標を正しい位置に修正します
         * 
         * @param Point
         */
        public function correctCoordinate(point:Point):void
        {
        }
        
        /**
         * Graphics を現在のペンの状態に適用します
         * 
         */
        public function resetPen():void
        {
            m_pen.setLineStyle(m_graphics);
            m_shape.blendMode = m_pen.blendMode;
        }
        
        private function getBezierCurvePoints(anchor0:Point,
                                              handle0:Point,
                                              handle1:Point,
                                              anchor1:Point):Vector.<Point>
        {
            var n:uint = 100;
            var ret:Vector.<Point> = new Vector.<Point>(n - 1, true);
            for (var i:int = 1; i < n; i++) {
                var t:Number = Number(i) / Number(n);
                var p1:Point = getDividePoint(anchor0, handle0, t);
                var p2:Point = getDividePoint(handle0, handle1, t);
                var p3:Point = getDividePoint(handle1, anchor1, t);
                var p4:Point = getDividePoint(p1, p2, t);
                var p5:Point = getDividePoint(p2, p3, t);
                var p6:Point = getDividePoint(p4, p5, t);
                ret[i - 1] = p6;
            }
            return ret;
        }
        
        private function getDividePoint(p1:Point, p2:Point, t:Number):Point
        {
            return new Point(p1.x + (p2.x - p1.x) * t, p1.y + (p2.y - p1.y) * t);
        }
        
        /**
         * ペンオブジェクトを返します
         * 
         * @return Pen ペンオブジェクト
         */
        public function get pen():Pen
        {
            return m_pen;
        }
        
        /**
         * シェイプオブジェクトを返します
         * 
         * @return Shape シェイプオブジェクト
         */
        public function get shape():Shape
        {
            return m_shape;
        }
        
        /**
         * 現在のx座標を返します
         * 
         * @return x 現在のx座標
         */
        public function get x():int
        {
            return m_coordinate.x;
        }
        
        /**
         * 現在のy座標を返す
         * 
         * @return y 現在のy座標
         */
        public function get y():int
        {
            return m_coordinate.y;
        }
        
        private var m_coordinate:Point;
        private var m_pen:Pen;
        private var m_shape:Shape;
        private var m_graphics:Graphics;
    }
}