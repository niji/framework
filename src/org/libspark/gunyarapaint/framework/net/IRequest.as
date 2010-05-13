package org.libspark.gunyarapaint.framework.net
{
    import flash.events.IEventDispatcher;

    public interface IRequest extends IEventDispatcher
    {
        function post(url:String, parameters:IParameters):void;
    }
}
