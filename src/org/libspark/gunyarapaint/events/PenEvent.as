package org.libspark.gunyarapaint.events
{
    public final class PenEvent extends AbstractEvent
    {
        public static const THICKNESS:String = PREFIX + "thickness";
        
        public static const COLOR:String = PREFIX + "color";
        
        public static const ALPHA:String = PREFIX + "alpha";
        
        public static const BLEND_MODE:String = PREFIX + "blendMode";
        
        public static const SCALE_MODE:String = PREFIX + "scaleMode";
        
        public static const CAPS_STYLE:String = PREFIX + "capsStyle";
        
        public static const JOINT_STYLE:String = PREFIX + "jointStyle";
        
        public static const MITER_LIMIT:String = PREFIX + "miterLimit";
        
        public static const PIXEL_HINTING:String = PREFIX + "pixelHinting";
        
        public static const BITMAP:String = PREFIX + "bitmap";
        
        public static const MATRIX:String = PREFIX + "matrix";
        
        public function PenEvent(type:String)
        {
            super(type, false, false);
        }
    }
}