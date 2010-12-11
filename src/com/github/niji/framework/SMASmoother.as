package com.github.niji.framework
{
    public class SMASmoother implements ISmoother
    {
        public function SMASmoother()
        {
            m_buffer = new Vector.<Number>();
        }
        
        /**
         * @inheritDoc
         */
        public function moveTo(x:Number, y:Number):void
        {
            m_buffer.push(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function lineTo(x:Number, y:Number):void
        {
            m_buffer.push(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function calcurate():Vector.<Number>
        {
            var length:uint = m_buffer.length;
            var ret:Vector.<Number> = new Vector.<Number>(length, true);
            var x0:Number = m_buffer[0];
            var y0:Number = m_buffer[1];
            ret[0] = x0;
            ret[1] = y0;
            for (var i:uint = 2; i < length; i += 2) {
                var x1:Number = m_buffer[i];
                var y1:Number = m_buffer[i + 1];
                var x:Number = (x1 + x0) / 2;
                var y:Number = (y1 + y0) / 2;
                ret[i] = x;
                ret[i + 1] = y;
                x0 = x;
                y0 = y;
            }
            m_buffer.splice(0, length);
            return ret;
        }
        
        private var m_buffer:Vector.<Number>;
    }
}
