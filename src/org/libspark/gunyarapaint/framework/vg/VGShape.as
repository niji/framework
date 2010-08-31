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
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public final class VGShape
    {
        public function VGShape(width:Number, height:Number)
        {
            m_points = new Vector.<VGPoint>();
            m_rect = new Rectangle(width, height -width, -height);
            m_width = width;
            m_height = height;
        }
        
        public function clone():VGShape
        {
            var newShape:VGShape = new VGShape(m_width, m_height);
            newShape.m_points = cloneVGPoints();
            newShape.m_rect = m_rect.clone();
            return newShape;
        }
        
        public function cloneVGPoints():Vector.<VGPoint>
        {
            var newPoints:Vector.<VGPoint> = new Vector.<VGPoint>(length, true);
            for (var i:uint = 0; i < length; i++) {
                newPoints[i] = m_points[i].clone();
            }
            return newPoints;
        }
        
        public function updateRectangle(value:Point):void
        {
            var px:Number = value.x;
            var py:Number = value.y;
            if (py < m_rect.top)
                m_rect.top = py;
            if (py > m_rect.bottom)
                m_rect.bottom = py;
            if (px < m_rect.left)
                m_rect.left = px;
            if (px > m_rect.right)
                m_rect.right = px;
        }
        
        public function get allVGPoints():Vector.<VGPoint>
        {
            return m_points;
        }
        
        public function get rectangle():Rectangle
        {
            return m_rect.clone();
        }
        
        private var m_points:Vector.<VGPoint>;
        private var m_rect:Rectangle;
        private var m_width:Number;
        private var m_height:Number;
    }
}
