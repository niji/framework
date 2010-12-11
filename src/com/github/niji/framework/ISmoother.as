package com.github.niji.framework
{
    public interface ISmoother
    {
        function moveTo(x:Number, y:Number):void;
        
        function lineTo(x:Number, y:Number):void;
        
        function calcurate():Vector.<Number>;
    }
}
