package org.libspark.gunyarapaint.framework
{
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.CapsStyle;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.events.EventDispatcher;
    import flash.geom.Matrix;
    
    import org.libspark.gunyarapaint.framework.events.PenEvent;
    
    /**
     * ペンオブジェクト
     * 
     */
    public final class Pen extends EventDispatcher
    {
        public function Pen()
        {
            reset();
            super();
        }
        
        /**
         * 初期状態に戻す
         * 
         */
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
        
        /**
         * 別のPenオブジェクトの設定を適用する.
         * 
         * Painter でイベントを確実に発生させるためにsetterを経由する
         * 
         * @param value Pen
         */
        public function setPen(value:Pen):void
        {
            thickness = value.thickness;
            color = value.color;
            alpha = value.alpha;
            blendMode = value.blendMode;
            scaleMode = value.scaleMode;
            capsStyle = value.capsStyle;
            jointStyle = value.jointStyle;
            miterLimit = value.miterLimit;
            pixelHinting = value.pixelHinting;
            matrix = value.matrix.clone();
            if (m_bitmap != null)
                bitmap = value.bitmap;
        }
        
        /**
         * Graphics オブジェクトに対して現在のペンを適用する
         * 
         */
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
        
        /**
         * 現在の色を取得する。ARGB 形式(0xAARRGGBB) で返す
         * 
         */
        public function get argb():uint
        {
            return uint(m_alpha * 255) << 24 | m_color;
        }
        
        /**
         * 現在のペンの太さを取得する
         * 
         */
        public function get thickness():uint
        {
            return m_thickness;
        }
        
        /**
         * ペンの太さを設定する
         * 
         * @eventType PenEvent.THICKNESS
         */
        public function set thickness(value:uint):void
        {
            var oldValue:uint = m_thickness;
            m_thickness = value;
            if (oldValue != value && hasEventListener(PenEvent.THICKNESS))
                dispatchEvent(new PenEvent(PenEvent.THICKNESS))
        }
        
        /**
         * 現在の色を取得する。RGB形式(0xRRGGBB) で返す
         * 
         */
        public function get color():uint
        {
            return m_color;
        }
        
        /**
         * 色を設定する(アルファ情報は無視される)。
         * 
         * @eventType PenEvent.COLOR
         */
        public function set color(value:uint):void
        {
            var oldValue:uint = m_color;
            m_color = value;
            if (oldValue != value && hasEventListener(PenEvent.COLOR))
                dispatchEvent(new PenEvent(PenEvent.COLOR))
        }
        
        /**
         * 現在の不透明度を取得する
         * 
         */
        public function get alpha():Number
        {
            return m_alpha;
        }
        
        /**
         * 不透明度を設定する
         * 
         * @eventType PenEvent.ALPHA
         */
        public function set alpha(value:Number):void
        {
            var oldValue:Number = m_alpha;
            m_alpha = value;
            if (oldValue != value && hasEventListener(PenEvent.ALPHA))
                dispatchEvent(new PenEvent(PenEvent.ALPHA))
        }
        
        /**
         * 現在のブレンドモードを取得する
         * 
         */
        public function get blendMode():String
        {
            return m_blendMode;
        }
        
        /**
         * ブレンドモードを設定する
         * 
         * @eventType PenEvent.BLEND_MODE
         */
        public function set blendMode(value:String):void
        {
            var oldValue:String = m_blendMode;
            m_blendMode = value;
            if (oldValue != value && hasEventListener(PenEvent.BLEND_MODE))
                dispatchEvent(new PenEvent(PenEvent.BLEND_MODE))
        }
        
        /**
         * 現在のLineScaleMode の値を取得する
         * 
         */
        public function get scaleMode():String
        {
            return m_scaleMode;
        }
        
        /**
         * LineScaleMode の値を設定する
         * 
         * @eventType PenEvent.SCALE_MODE
         */
        public function set scaleMode(value:String):void
        {
            var oldValue:String = m_scaleMode;
            m_scaleMode = value;
            if (oldValue != value && hasEventListener(PenEvent.SCALE_MODE))
                dispatchEvent(new PenEvent(PenEvent.SCALE_MODE))
        }
        
        /**
         * 現在のCapsStyle の値を取得する
         * 
         */
        public function get capsStyle():String
        {
            return m_capsStyle;
        }
        
        /**
         * CapsStyle の値を設定する
         * 
         * @eventType PenEvent.CAPS_STYLE
         */
        public function set capsStyle(value:String):void
        {
            var oldValue:String = m_capsStyle;
            m_capsStyle = value;
            if (oldValue != value && hasEventListener(PenEvent.CAPS_STYLE))
                dispatchEvent(new PenEvent(PenEvent.CAPS_STYLE))
        }
        
        /**
         * 現在のJointStyle の値を取得する
         * 
         */
        public function get jointStyle():String
        {
            return m_jointStyle;
        }
        
        /**
         * JointStyle の値を設定する
         * 
         * @eventType PenEvent.JOINT_STYLE
         */
        public function set jointStyle(value:String):void
        {
            var oldValue:String = m_jointStyle;
            m_jointStyle = value;
            if (oldValue != value && hasEventListener(PenEvent.JOINT_STYLE))
                dispatchEvent(new PenEvent(PenEvent.JOINT_STYLE))
        }
        
        /**
         * 現在のマイター値を取得する
         * 
         */
        public function get miterLimit():Number
        {
            return m_miterLimit;
        }
        
        /**
         * マイター値を設定する
         * 
         * @eventType PenEvent.MITER_LIMIT
         */
        public function set miterLimit(value:Number):void
        {
            var oldValue:Number = m_miterLimit;
            m_miterLimit = value;
            if (oldValue != value && hasEventListener(PenEvent.MITER_LIMIT))
                dispatchEvent(new PenEvent(PenEvent.MITER_LIMIT))
        }
        
        /**
         * @private
         * 
         */
        public function get pixelHinting():Boolean
        {
            return m_pixelHinting;
        }
        
        /**
         * @private
         * 
         */
        public function set pixelHinting(value:Boolean):void
        {
            var oldValue:Boolean = m_pixelHinting;
            m_pixelHinting = value;
            if (oldValue != value && hasEventListener(PenEvent.PIXEL_HINTING))
                dispatchEvent(new PenEvent(PenEvent.PIXEL_HINTING))
        }
        
        /**
         * @private
         * 
         */
        public function get bitmap():BitmapData
        {
            return m_bitmap;
        }
        
        /**
         * @private
         * 
         */
        public function set bitmap(value:BitmapData):void
        {
            m_bitmap.dispose();
            m_bitmap = value.clone();
            if (hasEventListener(PenEvent.BITMAP))
                dispatchEvent(new PenEvent(PenEvent.BITMAP))
        }
        
        /**
         * @private
         * 
         */
        public function get matrix():Matrix
        {
            return m_matrix;
        }
        
        /**
         * @private
         * 
         */
        public function set matrix(value:Matrix):void
        {
            var oldValue:Matrix = m_matrix;
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
