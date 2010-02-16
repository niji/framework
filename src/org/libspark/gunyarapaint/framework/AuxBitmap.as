package org.libspark.gunyarapaint
{
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    
    public final class AuxBitmap extends Sprite
    {
        public static const LINES:String = "lines";
        
        public static const PIXELS:String = "pixels";
        
        public function AuxBitmap(rect:Rectangle)
        {
            m_rect = rect;
            m_color = 0;
            m_alpha = 1;
            m_length = 4;
            m_type = LINES;
            m_box = new Shape();
            m_skew = new Shape();
            m_box.visible = false;
            m_skew.visible = false;
            validate();
            addChild(m_box);
            addChild(m_skew);
        }
        
        public function validate():void
        {
            var box:Graphics = m_box.graphics;
            var skew:Graphics = m_skew.graphics;
            box.clear();
            skew.clear();
            box.lineStyle(0, m_color, m_alpha);
            skew.lineStyle(0, m_color, m_alpha);
            box.drawRect(0, 0, width, height);
            switch (m_type) {
                case LINES:
                default:
                    divideLines(box, skew);
                    break;
                case PIXELS:
                    dividePixels(box, skew);
                    break;
            }
        }
        
        private function divideLines(box:Graphics, skew:Graphics):void
        {
            var w:Number = m_rect.width;
            var h:Number = m_rect.height;
            var sw:Number = w / m_length;
            var sh:Number = h / m_length;
            for (var i:uint = 0; i < m_length; i++) {
                if (i > 0){
                    box.moveTo(i * sw, 0);
                    box.lineTo(i * sw, h);
                    box.moveTo(0, i * sh);
                    box.lineTo(w, i * sh);
                    skew.moveTo(i * sh, 0);
                    skew.lineTo(0, i * sh);
                    skew.moveTo(w - (i * sw), 0);
                    skew.lineTo(w, i * sh);
                }
                skew.moveTo(w - ((i + 1) * sw), h);
                skew.lineTo(h, h - ((i + 1) * sh));
                skew.moveTo((i + 1) * sw, h);
                skew.lineTo(0, h - ((i + 1) * sh));
            }
        }
        
        private function dividePixels(box:Graphics, skew:Graphics):void
        {
            var i:uint = 0;
            for (i = m_length; i < width; i += m_length) {
                box.moveTo(i, 0);
                box.lineTo(i, height);
            }
            for (i = m_length; i < height; i += m_length) {
                box.moveTo(0, i);
                box.lineTo(width, i);
            }
            var max:uint = (m_rect.width > m_rect.height) ? m_rect.width : m_rect.height;
            max += m_length - (max % m_length);
            for (i = m_length; i <= max; i += m_length) {
                skew.moveTo(i - m_length, 0);
                skew.lineTo(0, i - m_length);
                skew.moveTo(max - (i - m_length), 0);
                skew.lineTo(max, i - m_length);
                skew.moveTo(max, max - i);
                skew.lineTo(max - i, max);
                skew.moveTo(0, max - i);
                skew.lineTo(i, max);
            }
            m_skew.scrollRect = m_rect;
        }
        
        public function get type():String
        {
            return m_type;
        }
        
        public function get lineColor():uint
        {
            return m_color;
        }
        
        public function get lineAlpha():Number
        {
            return m_alpha;
        }
        
        public function get length():uint
        {
            return m_length;
        }
        
        public function get boxVisible():Boolean
        {
            return m_box.visible;
        }
        
        public function get skewVisible():Boolean
        {
            return m_skew.visible;
        }
        
        public function set type(value:String):void
        {
            m_type = value;
            validate();
        }
        
        public function set lineColor(value:uint):void
        {
            m_color = value;
            validate();
        }
        
        public function set lineAlpha(value:Number):void
        {
            m_alpha = value;
            validate();
        }
        
        public function set length(value:uint):void
        {
            m_length = value;
            validate();
        }
        
        public function set boxVisible(value:Boolean):void
        {
            m_box.visible = value;
        }
        
        public function set skewVisible(value:Boolean):void
        {
            m_skew.visible = value;
        }
        
        private var m_rect:Rectangle;
        private var m_box:Shape;
        private var m_skew:Shape;
        private var m_type:String;
        private var m_color:uint;
        private var m_alpha:Number;
        private var m_length:uint;
    }
}
