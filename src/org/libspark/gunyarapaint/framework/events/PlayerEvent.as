package org.libspark.gunyarapaint.framework.events
{
    import flash.events.Event;

    /**
     * ログ再生のイベント
     * 
     */
    public final class PlayerEvent extends AbstractEvent
    {
        /**
         * 開始後
         * 
         */
        public static const STARTED:String = PREFIX + "started";
        
        /**
         * コマンドが読み込まれ、実行した後
         * 
         */
        public static const UPDATED:String = PREFIX + "updated";
        
        /**
         * 一時停止後
         * 
         */
        public static const PAUSED:String = PREFIX + "paused";
        
        /**
         * 停止後
         * 
         */
        public static const STOPPED:String = PREFIX + "stopped";
        
        /**
         * 終了後
         * 
         */
        public static const FINISHED:String = PREFIX + "finished";
        
        public function PlayerEvent(type:String)
        {
            super(type, false, false);
        }
        
        public override function clone():Event
        {
            return new PlayerEvent(type);
        }
    }
}