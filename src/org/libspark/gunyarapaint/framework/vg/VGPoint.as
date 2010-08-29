package org.libspark.gunyarapaint.framework.vg
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