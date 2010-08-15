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