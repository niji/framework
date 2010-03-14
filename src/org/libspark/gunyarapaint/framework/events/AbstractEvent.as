package org.libspark.gunyarapaint.framework.events
{
    import flash.events.Event;
    
    internal class AbstractEvent extends Event
    {
        protected static const PREFIX:String = "org.libspark.gunyarapaint.framework.events.";
        
        public function AbstractEvent(type:String, bubbles:Boolean, cancelable:Boolean)
        {
            super(type, bubbles, cancelable);
        }
    }
}
