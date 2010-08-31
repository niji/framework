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
            var value:Object = {
                "width" : width,
                "height" : height,
                "points" : this.coordinates,
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
        
        public function hitTest(x:Number, y:Number):Boolean
        {
            var length:uint = m_points.length;
            var value:Point = new Point(x, y);
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
        
        public function get coordinates():Vector.<VGPoint>
        {
            var points:Vector.<VGPoint> = new Vector.<VGPoint>(length, true);
            for (var i:uint = 0; i < length; i++) {
                points[i] = m_points[i].clone();
            }
            return points;
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