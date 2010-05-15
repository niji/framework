package org.libspark.gunyarapaint.framework.net
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    public interface IRequest extends IEventDispatcher
    {
        function post(url:String, parameters:IParameters):void;
        
        function get(url:String):void;
        
        function load(url:String):void;
        
        function get loader():EventDispatcher;
        
        function set loader(value:EventDispatcher):void;
    }
}
