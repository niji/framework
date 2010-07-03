package org.libspark.gunyarapaint.framework.events
{
    import flash.events.Event;

    /**
     * @private
     */
    public final class PenEvent extends AbstractEvent
    {
        /**
         * 太さが変更された
         */
        public static const THICKNESS:String = prefix + "thickness";
        
        /**
         * 色が変更された
         */
        public static const COLOR:String = prefix + "color";
        
        /**
         * 不透明度が変更された
         */
        public static const ALPHA:String = prefix + "alpha";
        
        /**
         * ブレンドモードが変更された
         */
        public static const BLEND_MODE:String = prefix + "blendMode";
        
        /**
         * スケールモードが変更された
         */
        public static const SCALE_MODE:String = prefix + "scaleMode";
        
        /**
         * キャップモードが変更された
         */
        public static const CAPS_STYLE:String = prefix + "capsStyle";
        
        /**
         * ジョイントモードが変更された
         */
        public static const JOINT_STYLE:String = prefix + "jointStyle";
        
        /**
         * マイター値が変更された
         */
        public static const MITER_LIMIT:String = prefix + "miterLimit";
        
        /**
         * ピクセルヒンティングが変更された
         */
        public static const PIXEL_HINTING:String = prefix + "pixelHinting";
        
        /**
         * @private
         */
        public static const BITMAP:String = prefix + "bitmap";
        
        /**
         * @private
         */
        public static const MATRIX:String = prefix + "matrix";
        
        /**
         * @inheritDoc 
         */
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
        
        public static function get prefix():String
        {
            return commonPrefix + "penEvent.";
        }
    }
}
