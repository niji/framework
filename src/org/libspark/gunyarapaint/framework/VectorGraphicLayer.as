package org.libspark.gunyarapaint.framework
{
    import flash.display.DisplayObject;

    public class VectorGraphicLayer implements ILayer
    {
        public function VectorGraphicLayer()
        {
        }
        
        public function clone(bitmapDataCopy:Boolean = true):ILayer
        {
            return null;
        }
        
        public function fromJSON(data:Object):void
        {
        }
        
        public function toJSON():Object
        {
            return null;
        }
        
        public function setIndex(index:uint):void
        {
        }
        
        public function get alpha():Number
        {
            return 0;
        }
        
        public function get blendMode():String
        {
            return null;
        }
        
        public function get displayObject():DisplayObject
        {
            return null;
        }
        
        public function get height():uint
        {
            return 0;
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
        
        public function get visible():Boolean
        {
            return false;
        }
        
        public function get width():uint
        {
            return 0;
        }
        
        public function get newDisplayObject():DisplayObject
        {
            return null;
        }
        
        public function set alpha(value:Number):void
        {
        }
        
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
        
        public function set visible(value:Boolean):void
        {
        }
        
        private var m_index:uint;
        
        private var m_locked:Boolean;
        
        private var m_name:String;
    }
}