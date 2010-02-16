package org.libspark.gunyarapaint.components
{
    import mx.collections.ArrayCollection;
    
    import org.libspark.gunyarapaint.Recorder;
    import org.libspark.gunyarapaint.modules.IDrawable;
    
    public interface IDelegate
    {
        function get module():IDrawable;
        function get recorder():Recorder;
        function get supportedBlendModes():ArrayCollection;
        function get canvas():CanvasController;
        function set module(value:IDrawable):void;
    }
}
