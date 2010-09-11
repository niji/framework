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
package com.github.niji.framework.vg
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import com.github.niji.framework.BitmapLayer;
    import com.github.niji.framework.ILayer;
    import com.github.niji.framework.Layer;

    public class VGLayer extends Layer implements ILayer
    {
        public function VGLayer(shape:Shape)
        {
            super();
            m_shape = shape;
            m_closed = false;
            m_shapes = new Vector.<VGShape>();
            m_shapes.push(new VGShape(width, height));
            m_shapeIndex = 0;
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
            var length:uint = m_shapes.length;
            var newShapes:Vector.<VGShape> = new Vector.<VGShape>(length);
            for (var i:uint = 0; i < length; i++) {
                newShapes[i] = m_shapes[i].clone();
            }
            var newShape:Shape = new Shape();
            newShape.graphics.copyFrom(m_shape.graphics);
            var layer:VGLayer = new VGLayer(newShape);
            layer.alpha = alpha;
            layer.blendMode = blendMode;
            layer.locked = false;
            layer.name = name;
            layer.visible = visible;
            layer.setIndex(index);
            layer.m_closed = m_closed;
            layer.m_current = m_current.clone();
            layer.m_shapes = newShapes;
            layer.m_shapeIndex = m_shapeIndex;
            return layer;
        }
        
        public override function fromJSON(value:Object):void
        {
            m_shape.width = uint(value.width);
            m_shape.height = uint(value.height);
            m_current = VGPoint(value.current);
            //m_points = Vector.<VGPoint>(value.points);
        }
        
        public override function toJSON():Object
        {
            var value:Object = {
                "width" : width,
                "height" : height,
                "shapes" : null,
                "current" : m_current.clone()
            };
            return value;
        }
        
        public function createShape():void
        {
            m_shapes.push(new VGShape(width, height));
            ++m_shapeIndex;
        }
        
        public function setCurrentPoint(x:Number, y:Number):void
        {
            m_current = new VGPoint(new Point(x, y));
        }
        
        public function commitCurrentVGPoint(x:Number, y:Number):void
        {
            var shape:VGShape = m_shapes[m_shapeIndex];
            var points:Vector.<VGPoint> = shape.allVGPoints;
            if (points.length > 0) {
                var first:VGPoint = points[0];
                if (first.equals(m_current)) {
                    currentVGPoint = first.clone0();
                    m_closed = true;
                }
                else {
                    m_current.controlPoint = new Point(x, y);
                }
            }
            else {
                m_current.controlPoint = new Point(x, y);
            }
            points.push(m_current);
            shape.updateRectangle(m_current.anchorPoint);
        }
        
        public function getVGPoint(index:uint):VGPoint
        {
            return m_shapes[m_shapeIndex].allVGPoints[index];
        }
        
        public function hitTest(x:Number, y:Number):Boolean
        {
            var points:Vector.<VGPoint> = m_shapes[m_shapeIndex].allVGPoints;
            var length:uint = points.length;
            var value:Point = new Point(x, y);
            if (!m_closed && length > 0 && points[0].equalsAnchor(value)) {
                return false;
            }
            for (var i:uint = 0; i < length; i++) {
                var point:VGPoint = points[i];
                var anchor:Point = point.anchorPoint;
                m_hitIndex = i;
                if (Point.distance(value, anchor) < 4) {
                    m_hitType = "anchor";
                    return true;
                }
                var cf:Point = point.controlPointForward;
                if (Point.distance(value, cf) < 4) {
                    m_hitType = "forward";
                    return true;
                }
                var cb:Point = point.controlPointBack;
                if (Point.distance(value, cb) < 4) {
                    m_hitType = "back";
                    return true;
                }
            }
            return false;
        }
        
        public function updateVGPoint(x:Number, y:Number):void
        {
            var point:Point = new Point(x, y);
            var current:VGPoint = m_shape[m_shapeIndex].allVGPoints[m_hitIndex];
            switch (m_hitType) {
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
        
        public function get allVGPoints():Vector.<VGPoint>
        {
            return m_shapes[m_shapeIndex].cloneVGPoints();
        }
        
        public function get currentVGPoint():VGPoint
        {
            return m_current;
        }
        
        public function get previousVGPoint():VGPoint
        {
            var points:Vector.<VGPoint> = m_shapes[m_shapeIndex].allVGPoints;
            return points[points.length - 1];
        }
        
        public function get countVGPoints():uint
        {
            return m_shapes[m_shapeIndex].allVGPoints.length;
        }
        
        public function get rectangle():Rectangle
        {
            return m_shapes[m_shapeIndex].rectangle;
        }
        
        public function get closed():Boolean
        {
            return m_closed;
        }
        
        public function get shapeIndex():uint
        {
            return m_shapeIndex;
        }
        
        public function get countShapes():uint
        {
            return m_shapes.length;
        }
        
        public function set currentVGPoint(value:VGPoint):void
        {
            m_current = value.clone();
        }
        
        public function set shapeIndex(value:uint):void
        {
            m_shapeIndex = value;
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
        
        private var m_shapes:Vector.<VGShape>;
        private var m_shape:Shape;
        private var m_current:VGPoint;
        private var m_hitType:String;
        private var m_hitIndex:uint;
        private var m_shapeIndex:uint;
        private var m_closed:Boolean;
    }
}