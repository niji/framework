package org.libspark.gunyarapaint.framework.events
{
    import flash.events.Event;
    
    internal class AbstractEvent extends Event
    {
        protected static const PREFIX:String = "org.libspark.gunyarapaint.framework.events.";
        
        /**
         * @inheritDoc
         */
        public function AbstractEvent(type:String, bubbles:Boolean, cancelable:Boolean)
        {
            super(type, bubbles, cancelable);
        }
        
        /**
         * @inheritDoc
         */
        public override function clone():Event
        {
            return new AbstractEvent(type, bubbles, cancelable);
        }
    }
}
