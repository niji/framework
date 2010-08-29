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
package org.libspark.gunyarapaint.framework.vg
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import org.libspark.gunyarapaint.framework.BitmapLayer;
    import org.libspark.gunyarapaint.framework.ILayer;
    import org.libspark.gunyarapaint.framework.Layer;

    public class VGLayer extends Layer implements ILayer
    {
        public static const NUM_ELEMENTS:uint = 100;
        
        public static const EVENT_CLOSED:String = "closed";
        
        public function VGLayer(shape:Shape)
        {
            super();
            m_shape = shape;
            m_points = new Vector.<VGPoint>();
            m_rect = new Rectangle(width, height, -width, -height);
            m_closed = false;
        }
        
        /**
         * @inheritDoc
         */
        public function compositeTo(dest:ILayer):void
        {
            if (visible && dest.visible) {
                if (dest is BitmapLayer) {
                    BitmapLayer(dest).bitmapData.draw(m_shape,
                        null, m_colorTransform, blendMode);
                }
                else if (dest is VGLayer) {
                    VGLayer(dest)
                    // TODO: implement this
                }
            }
        }
        
        /**
         * @inheritDoc
         */
        public function compositeBitmap(dest:BitmapData):void
        {
            if (visible)
                dest.draw(m_shape, null, m_colorTransform, blendMode);
        }
        
        /**
         * @inheritDoc
         */
        public function clone(bitmapDataCopy:Boolean = true):ILayer
        {
            var newShape:Shape = new Shape();
            newShape.graphics.copyFrom(m_shape.graphics);
            var layer:VGLayer = new VGLayer(newShape);
            layer.alpha = alpha;
            layer.blendMode = blendMode;
            layer.locked = false;
            layer.name = name;
            layer.visible = visible;
            layer.setIndex(index);
            return layer;
        }
        
        public override function fromJSON(value:Object):void
        {
            m_shape.width = uint(value.width);
            m_shape.height = uint(value.height);
            m_current = VGPoint(value.current);
            m_points = Vector.<VGPoint>(value.points);
        }
        
        public override function toJSON():Object
        {
            var length:uint = m_points.length;
            var points:Vector.<VGPoint> = new Vector.<VGPoint>(length, true);
            for (var i:uint = 0; i < length; i++) {
                points[i] = m_points[i].clone();
            }
            var value:Object = {
                "width" : width,
                "height" : height,
                "points" : m_points,
                "current" : m_current.clone()
            };
            return value;
        }
        
        public function setCurrentPoint(x:Number, y:Number):void
        {
            m_current = new VGPoint(new Point(x, y));
        }
        
        public function setCurrentVGPoint(value:VGPoint):void
        {
            m_current = value.clone();
        }
        
        public function commitCurrentVGPoint(x:Number, y:Number):void
        {
            if (m_points.length > 0) {
                var first:VGPoint = m_points[0];
                if (first.equals(m_current)) {
                    setCurrentVGPoint(first.clone0());
                    m_closed = true;
                }
                else {
                    m_current.controlPoint = new Point(x, y);
                }
            }
            else {
                m_current.controlPoint = new Point(x, y);
            }
            m_points.push(m_current);
            updateRectangle();
        }
        
        public function getVGPoint(index:uint):VGPoint
        {
            return m_points[index];
        }
        
        public function hitTest(value:Point):Boolean
        {
            var length:uint = m_points.length;
            if (!m_closed && length > 0 && m_points[0].equalsAnchor(value)) {
                return false;
            }
            for (var i:uint = 0; i < length; i++) {
                var point:VGPoint = m_points[i];
                var anchor:Point = point.anchorPoint;
                m_index = i;
                if (Point.distance(value, anchor) < 4) {
                    m_type = "anchor";
                    return true;
                }
                var cf:Point = point.controlPointForward;
                if (Point.distance(value, cf) < 4) {
                    m_type = "forward";
                    return true;
                }
                var cb:Point = point.controlPointBack;
                if (Point.distance(value, cb) < 4) {
                    m_type = "back";
                    return true;
                }
            }
            return false;
        }
        
        public function updateVGPoint(x:Number, y:Number):void
        {
            var point:Point = new Point(x, y);
            var current:VGPoint = m_points[m_index];
            switch (m_type) {
                case "anchor":
                    current.anchorPoint = point;
                    break;
                case "forward":
                    current.controlPointForward = point;
                    break;
                case "back":
                    current.controlPointBack = point;
                    break;
            }
        }
        
        public function draw():void
        {
            var g:Graphics = m_shape.graphics;
            var count:uint = this.countVGPoints;
            var point:VGPoint;
            // draw background
            g.clear();
            g.beginFill(0x0, 0);
            g.drawRect(0, 0, width, height);
            g.endFill();
            g.lineStyle(0.5, 0xaaffaa);
            if (!m_closed) {
                drawLines(g, count);
            }
            // draw Bezier lines
            if (count > 1) {
                var anchor:Point = m_points[0].anchorPoint;
                g.lineStyle(0.5, 0x0000ff);
                g.moveTo(anchor.x, anchor.y);
                for (var i:uint = 1; i < count; i++) {
                    var prev:VGPoint = m_points[i - 1];
                    var current:VGPoint = m_points[i];
                    drawBezierCurve(g, prev, current);
                }
            }
            if (!m_closed) {
                drawPoints(g, count);
            }
            else {
                //dispatchEvent(new Event(EVENT_CLOSED));
            }
        }
        
        public function drawBezierCurve(g:Graphics, prev:VGPoint, current:VGPoint):void
        {
            var curvePoints:Vector.<Point> = getBezierCurvePoints(
                prev.anchorPoint,
                prev.controlPointForward,
                current.controlPointBack,
                current.anchorPoint
            );
            var len:uint = curvePoints.length;
            for (var i:int = 0; i < len; i++) {
                var curvePoint:Point = curvePoints[i];
                g.lineTo(curvePoint.x, curvePoint.y);
            }
        }
        
        private function updateRectangle():void
        {
            var point:Point = m_current.anchorPoint;
            var px:Number = point.x;
            var py:Number = point.y;
            if (py < m_rect.top)
                m_rect.top = py;
            if (py > m_rect.bottom)
                m_rect.bottom = py;
            if (px < m_rect.left)
                m_rect.left = px;
            if (px > m_rect.right)
                m_rect.right = px;
        }
        
        private function drawLines(g:Graphics, count:uint):void
        {
            // draw lines between each control points
            for (var i:uint = 0; i < count; i++) {
                var point:VGPoint = m_points[i];
                var anchor:Point = point.anchorPoint;
                var cf:Point = point.controlPointForward;
                var cb:Point = point.controlPointBack;
                g.moveTo(cb.x, cb.y);
                g.lineTo(anchor.x, anchor.y);
                g.lineTo(cf.x, cf.y);
            }
        }
        
        private function drawPoints(g:Graphics, count:uint):void
        {
            var i:uint = 0;
            // draw anchor points
            g.lineStyle(0, 0, 0);
            g.beginFill(0x0000ff);
            for (i = 0; i < count; i++) {
                var anchor:Point = m_points[i].anchorPoint;
                g.drawCircle(anchor.x, anchor.y, 1.5);
            }
            g.endFill();
            // draw control points
            g.beginFill(0x00ff00);
            for (i = 0; i < count; i++) {
                var point:VGPoint = m_points[i];
                var cf:Point = point.controlPointForward;
                var cb:Point = point.controlPointBack;
                g.drawCircle(cf.x, cf.y, 1.5);
                g.drawCircle(cb.x, cb.y, 1.5);
            }
            g.endFill();
        }
        
        private function getBezierCurvePoints(anchor0:Point,
                                              handle0:Point,
                                              handle1:Point,
                                              anchor1:Point):Vector.<Point>
        {
            var n:uint = NUM_ELEMENTS;
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
        
        public function get currentVGPoint():VGPoint
        {
            return m_current;
        }
        
        public function get previousVGPoint():VGPoint
        {
            return m_points[m_points.length - 1];
        }
        
        public function get countVGPoints():uint
        {
            return m_points.length;
        }
        
        public function get rectangle():Rectangle
        {
            return m_rect.clone();
        }
        
        public function get closed():Boolean
        {
            return m_closed;
        }
        
        /**
         * @inheritDoc
         */
        public override function get alpha():Number
        {
            return m_shape.alpha;
        }
        
        /**
         * @inheritDoc
         */
        public override function get blendMode():String
        {
            return m_shape.blendMode;
        }
        
        /**
         * @inheritDoc
         */
        public function get displayObject():DisplayObject
        {
            return m_shape;
        }
        
        /**
         * @inheritDoc
         */
        public function get height():uint
        {
            return m_shape.height;
        }
        
        /**
         * @inheritDoc
         */
        public override function get visible():Boolean
        {
            return m_shape.visible;
        }
        
        /**
         * @inheritDoc
         */
        public function get width():uint
        {
            return m_shape.width;
        }
        
        /**
         * @inheritDoc
         */
        public function get newDisplayObject():DisplayObject
        {
            return m_shape;
        }
        
        /**
         * @inheritDoc
         */
        public override function set alpha(value:Number):void
        {
            m_shape.alpha = value;
            m_colorTransform.alphaMultiplier = value;
        }
        
        /**
         * @inheritDoc
         */
        public override function set blendMode(value:String):void
        {
            m_shape.blendMode = value;
        }
        
        /**
         * @inheritDoc
         */
        public override function set visible(value:Boolean):void
        {
            m_shape.visible = value;
        }
        
        private var m_shape:Shape;
        private var m_points:Vector.<VGPoint>;
        private var m_rect:Rectangle;
        private var m_current:VGPoint;
        private var m_closed:Boolean;
        private var m_type:String;
        private var m_index:uint;
    }
}