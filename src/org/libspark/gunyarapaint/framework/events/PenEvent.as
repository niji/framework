package org.libspark.gunyarapaint.framework.events
{
    import flash.events.Event;

    /**
     * @private
     * 
     */
    public final class PenEvent extends AbstractEvent
    {
        /**
         * 太さが変更された
         */
        public static const THICKNESS:String = PREFIX + "thickness";
        
        /**
         * 色が変更された
         */
        public static const COLOR:String = PREFIX + "color";
        
        /**
         * 不透明度が変更された
         */
        public static const ALPHA:String = PREFIX + "alpha";
        
        /**
         * ブレンドモードが変更された
         */
        public static const BLEND_MODE:String = PREFIX + "blendMode";
        
        /**
         * スケールモードが変更された
         */
        public static const SCALE_MODE:String = PREFIX + "scaleMode";
        
        /**
         * キャップモードが変更された
         */
        public static const CAPS_STYLE:String = PREFIX + "capsStyle";
        
        /**
         * ジョイントモードが変更された
         */
        public static const JOINT_STYLE:String = PREFIX + "jointStyle";
        
        /**
         * マイター値が変更された
         */
        public static const MITER_LIMIT:String = PREFIX + "miterLimit";
        
        /**
         * ピクセルヒンティングが変更された
         */
        public static const PIXEL_HINTING:String = PREFIX + "pixelHinting";
        
        /**
         * @private
         */
        public static const BITMAP:String = PREFIX + "bitmap";
        
        /**
         * @private
         */
        public static const MATRIX:String = PREFIX + "matrix";
        
        public function PenEvent(type:String)
        {
            super(type, false, false);
        }
        
        /**
         * @inheritDoc
         */
        public override function clone():Event
        {
            return new PenEvent(type);
        }
    }
}