package org.libspark.gunyarapaint
{
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.CapsStyle;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.events.EventDispatcher;
    import flash.geom.Matrix;
    
    import org.libspark.gunyarapaint.events.PenEvent;

    public final class Pen extends EventDispatcher
    {
        public function Pen()
        {
            reset();
        }
        
        public function reset():void
        {
            m_thickness = 3;
            m_color = 0x0;
            m_alpha = 1.0;
            m_blendMode = BlendMode.NORMAL;
            m_scaleMode = LineScaleMode.NORMAL;
            m_capsStyle = CapsStyle.ROUND;
            m_jointStyle = JointStyle.ROUND;
            m_miterLimit = 3.0;
            m_pixelHinting = true;
            m_bitmap = null;
            m_matrix = new Matrix();
        }
        
        internal function setLineStyle(graphics:Graphics):void
        {
            graphics.lineStyle(
                m_thickness,
                m_color,
                m_alpha,
                m_pixelHinting,
                m_scaleMode,
                m_capsStyle,
                m_jointStyle,
                m_miterLimit
            );
            if (m_bitmap != null)
                graphics.lineBitmapStyle(m_bitmap, m_matrix);
        }
        
        public function get argb():uint
        {
            return uint(m_alpha * 255) << 24 | m_color;
        }
        
        public function get thickness():uint
        {
            return m_thickness;
        }
        
        public function set thickness(value:uint):void
        {
            m_thickness = value;
            if (hasEventListener(PenEvent.THICKNESS))
                dispatchEvent(new PenEvent(PenEvent.THICKNESS))
        }
        
        public function get color():uint
        {
            return m_color;
        }
        
        public function set color(value:uint):void
        {
            m_color = value;
            if (hasEventListener(PenEvent.COLOR))
                dispatchEvent(new PenEvent(PenEvent.COLOR))
        }
        
        public function get alpha():Number
        {
            return m_alpha;
        }
        
        public function set alpha(value:Number):void
        {
            m_alpha = value;
            if (hasEventListener(PenEvent.ALPHA))
                dispatchEvent(new PenEvent(PenEvent.ALPHA))
        }
        
        public function get blendMode():String
        {
            return m_blendMode;
        }
        
        public function set blendMode(value:String):void
        {
            m_blendMode = value;
            if (hasEventListener(PenEvent.BLEND_MODE))
                dispatchEvent(new PenEvent(PenEvent.BLEND_MODE))
        }
        
        public function get scaleMode():String
        {
            return m_scaleMode;
        }
        
        public function set scaleMode(value:String):void
        {
            m_scaleMode = value;
            if (hasEventListener(PenEvent.SCALE_MODE))
                dispatchEvent(new PenEvent(PenEvent.SCALE_MODE))
        }
        
        public function get capsStyle():String
        {
            return m_capsStyle;
        }
        
        public function set capsStyle(value:String):void
        {
            m_capsStyle = value;
            if (hasEventListener(PenEvent.CAPS_STYLE))
                dispatchEvent(new PenEvent(PenEvent.CAPS_STYLE))
        }
        
        public function get jointStyle():String
        {
            return m_jointStyle;
        }
        
        public function set jointStyle(value:String):void
        {
            m_jointStyle = value;
            if (hasEventListener(PenEvent.JOINT_STYLE))
                dispatchEvent(new PenEvent(PenEvent.JOINT_STYLE))
        }
        
        public function get miterLimit():Number
        {
            return m_miterLimit;
        }
        
        public function set miterLimit(value:Number):void
        {
            m_miterLimit = value;
            if (hasEventListener(PenEvent.MITER_LIMIT))
                dispatchEvent(new PenEvent(PenEvent.MITER_LIMIT))
        }
        
        public function get pixelHinting():Boolean
        {
            return m_pixelHinting;
        }
        
        public function set pixelHinting(value:Boolean):void
        {
            m_pixelHinting = value;
            if (hasEventListener(PenEvent.PIXEL_HINTING))
                dispatchEvent(new PenEvent(PenEvent.PIXEL_HINTING))
        }
        
        public function get bitmap():BitmapData
        {
            return m_bitmap;
        }
        
        public function set bitmap(value:BitmapData):void
        {
            m_bitmap = value;
            if (hasEventListener(PenEvent.BITMAP))
                dispatchEvent(new PenEvent(PenEvent.BITMAP))
        }
        
        public function get matrix():Matrix
        {
            return m_matrix;
        }
        
        public function set matrix(value:Matrix):void
        {
            m_matrix = value;
            if (hasEventListener(PenEvent.MATRIX))
                dispatchEvent(new PenEvent(PenEvent.MATRIX))
        }
        
        private var m_thickness:uint;
        private var m_color:uint;
        private var m_alpha:Number;
        private var m_blendMode:String;
        private var m_scaleMode:String;
        private var m_capsStyle:String;
        private var m_jointStyle:String;
        private var m_miterLimit:Number;
        private var m_pixelHinting:Boolean;
        private var m_bitmap:BitmapData;
        private var m_matrix:Matrix;
    }
}
