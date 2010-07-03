package org.libspark.gunyarapaint.framework.events
{
    import flash.events.Event;

    /**
     * ログ再生のイベント
     */
    public final class PlayerEvent extends AbstractEvent
    {
        /**
         * 開始後
         */
        public static const STARTED:String = prefix + "started";
        
        /**
         * コマンドが読み込まれ、実行した後
         */
        public static const UPDATED:String = prefix + "updated";
        
        /**
         * 一時停止後
         */
        public static const PAUSED:String = prefix + "paused";
        
        /**
         * 停止後
         */
        public static const STOPPED:String = prefix + "stopped";
        
        /**
         * 終了後
         */
        public static const FINISHED:String = prefix + "finished";
        
        /**
         * @inheritDoc 
         */
        public function PlayerEvent(type:String)
        {
            super(type, false, false);
        }
        
        /**
         * @inheritDoc
         */
        public override function clone():Event
        {
            return new PlayerEvent(type);
        }
        
        public static function get prefix():String
        {
            return commonPrefix + "playerEvent.";
        }
    }
}
