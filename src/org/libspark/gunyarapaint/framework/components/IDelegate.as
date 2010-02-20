package org.libspark.gunyarapaint.framework.components
{
    import mx.collections.ArrayCollection;
    
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.modules.IDrawable;
    
    public interface IDelegate
    {
        function get module():IDrawable;
        function get recorder():Recorder;
        function get supportedBlendModes():ArrayCollection;
        function get canvas():CanvasController;
        function set module(value:IDrawable):void;
    }
}
