package org.libspark.gunyarapaint.framework
{
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.geom.Rectangle;
    
    public class AuxBitmap extends Sprite
    {
        public function AuxBitmap(rect:Rectangle)
        {
            m_rect = rect;
            m_color = 0;
            m_alpha = 1;
            m_divideCount = 4;
            m_box = new Shape();
            m_skew = new Shape();
            m_box.visible = false;
            m_skew.visible = false;
            update();
            mouseEnabled = false;
            addChild(m_box);
            addChild(m_skew);
        }
        
        public function update():void
        {
            var box:Graphics = m_box.graphics;
            var skew:Graphics = m_skew.graphics;
            box.clear();
            skew.clear();
            box.lineStyle(0, m_color, m_alpha);
            skew.lineStyle(0, m_color, m_alpha);
            box.drawRect(0, 0, width, height);
            divide();
        }
        
        public function divide():void
        {
            throw new IllegalOperationError();
        }
        
        public function get lineColor():uint
        {
            return m_color;
        }
        
        public function get lineAlpha():Number
        {
            return m_alpha;
        }
        
        public function get divideCount():uint
        {
            return m_divideCount;
        }
        
        public function get boxVisible():Boolean
        {
            return m_box.visible;
        }
        
        public function get skewVisible():Boolean
        {
            return m_skew.visible;
        }
        
        public function set lineColor(value:uint):void
        {
            m_color = value;
        }
        
        public function set lineAlpha(value:Number):void
        {
            m_alpha = value;
        }
        
        public function set divideCount(value:uint):void
        {
            m_divideCount = value;
        }
        
        public function set boxVisible(value:Boolean):void
        {
            m_box.visible = value;
        }
        
        public function set skewVisible(value:Boolean):void
        {
            m_skew.visible = value;
        }
        
        protected var m_rect:Rectangle;
        protected var m_box:Shape;
        protected var m_skew:Shape;
        protected var m_divideCount:uint;
        private var m_color:uint;
        private var m_alpha:Number;
    }
}
