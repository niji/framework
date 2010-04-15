package org.libspark.gunyarapaint.framework.commands
{
    import flash.geom.Point;
    
    /**
     * @private
     * 
     */
    internal class LineCommand
    {
        public function LineCommand()
        {
            reset();
        }
        
        public function reset():void
        {
            m_compressedValue = 0;
            resetCoordinates();
        }
        
        public static function resetCoordinates():void
        {
            s_readCoordinateX = 0;
            s_readCoordinateY = 0;
            s_writeCoordinateX = 0;
            s_writeCoordinateY = 0;
        }
        
        public function set compressedValue(value:int):void
        {
            m_compressedValue = value;
        }
        
        protected static var s_readCoordinateX:int;
        protected static var s_readCoordinateY:int;
        protected static var s_writeCoordinateX:int;
        protected static var s_writeCoordinateY:int;
        protected var m_compressedValue:uint;
    }
}
