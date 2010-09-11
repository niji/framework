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
    import flash.geom.Point;

    public class VGPoint
    {
        public function VGPoint(point:Point)
        {
            this.anchorPoint = point;
        }
        
        public function clone():VGPoint
        {
            var value:VGPoint = new VGPoint(m_anchor);
            value.controlPoint = m_controlForward;
            return value;
        }
        
        internal function clone0():VGPoint
        {
            var value:VGPoint = new VGPoint(m_anchor);
            value.m_controlForward = m_anchor.clone();
            value.m_controlBack = m_anchor.clone();
            return value;
        }
        
        public function equals(value:VGPoint):Boolean
        {
            return Point.distance(m_anchor, value.anchorPoint) < 5;
        }
        
        public function equalsAnchor(value:Point):Boolean
        {
            return Point.distance(m_anchor, value) < 5;
        }
        
        public function get anchorPoint():Point
        {
            return m_anchor;
        }
        
        public function get controlPointForward():Point
        {
            return m_controlForward;
        }
        
        public function get controlPointBack():Point
        {
            return m_controlBack;
        }
        
        public function set anchorPoint(value:Point):void
        {
            m_anchor = value.clone();
        }
        
        public function set controlPoint(value:Point):void
        {
            m_controlForward = value.clone();
            m_controlBack = new Point(
                m_anchor.x * 2 - value.x,
                m_anchor.y * 2 - value.y
            );
        }
        
        public function set controlPointForward(value:Point):void
        {
            m_controlForward = value;
        }
        
        public function set controlPointBack(value:Point):void
        {
            m_controlBack = value;
        }
        
        private var m_anchor:Point;
        private var m_controlForward:Point;
        private var m_controlBack:Point;
    }
}