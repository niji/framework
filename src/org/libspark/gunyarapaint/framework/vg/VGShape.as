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
