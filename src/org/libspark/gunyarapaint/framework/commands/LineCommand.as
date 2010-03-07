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
            m_compressedValue =
                s_readCoordinate.x =
                s_readCoordinate.y =
                s_writeCoordinate.x =
                s_writeCoordinate.y = 0;
        }
        
        public function set compressedValue(value:int):void
        {
            m_compressedValue = value;
        }
        
        protected function get readCoordinate():Point
        {
            return s_readCoordinate;
        }
        
        protected function get writeCoordinate():Point
        {
            return s_writeCoordinate;
        }
        
        private static var s_readCoordinate:Point = new Point();
        private static var s_writeCoordinate:Point = new Point();
        protected var m_compressedValue:int;
    }
}