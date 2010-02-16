package org.libspark.gunyarapaint.events
{
    public final class PlayerEvent extends AbstractEvent
    {
        public static const STARTED:String = PREFIX + "started";
        
        public static const UPDATED:String = PREFIX + "updated";
        
        public static const PAUSED:String = PREFIX + "paused";
        
        public static const STOPPED:String = PREFIX + "stopped";
        
        public static const FINISHED:String = PREFIX + "finished";
        
        public function PlayerEvent(type:String)
        {
            super(type, false, false);
        }
    }
}