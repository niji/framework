package org.libspark.gunyarapaint.framework
{
    import flash.geom.ColorTransform;

    public class Layer
    {
        public function Layer()
        {
            m_colorTransform = new ColorTransform(
                1.0,
                1.0,
                1.0,
                1.0,
                0,
                0,
                0,
                0
            );
        }
        
        /**
         * @inheritDoc
         */
        public function fromJSON(data:Object):void
        {
            alpha = data.alpha;
            blendMode = data.blendMode;
            locked = data.lock == "true";
            name = data.name;
            visible = data.visible == "true";
        }
        
        /**
         * @inheritDoc
         */
        public function toJSON():Object
        {
            return {
                "alpha": alpha,
                "blendMode": blendMode,
                "lock": locked ? "true" : "false",
                    "name": name,
                    "visible": visible ? "true" : "false"
            };
        }
        
        public function setIndex(index:uint):void
        {
            m_index = index;
        }
        
        /**
         * @inheritDoc
         */
        public function get alpha():Number
        {
            return 0.0;
        }
        
        /**
         * @inheritDoc
         */
        public function get blendMode():String
        {
            return "";
        }
        /**
         * @inheritDoc
         */
        public function get index():uint
        {
            return m_index;
        }
        
        /**
         * @inheritDoc
         */
        public function get locked():Boolean
        {
            return m_locked;
        }
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return m_name;
        }
        
        /**
         * @inheritDoc
         */
        public function get visible():Boolean
        {
            return false;
        }
        
        /**
         * @inheritDoc
         */
        public function set alpha(value:Number):void
        {
            m_colorTransform.alphaMultiplier = value;
        }
        
        /**
         * @inheritDoc
         */
        public function set blendMode(value:String):void
        {
        }
        
        /**
         * @inheritDoc
         */
        public function set locked(value:Boolean):void
        {
            m_locked = value;
        }
        
        /**
         * @inheritDoc
         */
        public function set name(value:String):void
        {
            m_name = value;
        }
        
        /**
         * @inheritDoc
         */
        public function set visible(value:Boolean):void
        {
        }
        
        protected var m_colorTransform:ColorTransform;
        
        private var m_index:uint;
        
        private var m_locked:Boolean;
        
        private var m_name:String;
    }
}