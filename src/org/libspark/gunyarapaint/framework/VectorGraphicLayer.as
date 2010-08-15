package org.libspark.gunyarapaint.framework
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.geom.ColorTransform;

    public class VectorGraphicLayer extends Layer implements ILayer
    {
        public function VectorGraphicLayer(shape:Shape)
        {
            super();
            m_shape = shape;
        }
        
        /**
         * @inheritDoc
         */
        public function compositeTo(dest:ILayer):void
        {
            if (visible && dest.visible) {
                if (dest is BitmapLayer) {
                    BitmapLayer(dest).bitmapData.draw(m_shape,
                        null, m_colorTransform, blendMode);
                }
                else if (dest is VectorGraphicLayer) {
                    // TODO: implement this
                }
            }
        }
        
        /**
         * @inheritDoc
         */
        public function compositeBitmap(dest:BitmapData):void
        {
            if (visible)
                dest.draw(m_shape, null, m_colorTransform, blendMode);
        }
        
        /**
         * @inheritDoc
         */
        public function clone(bitmapDataCopy:Boolean = true):ILayer
        {
            var newShape:Shape = new Shape();
            newShape.graphics.copyFrom(m_shape.graphics);
            var layer:VectorGraphicLayer = new VectorGraphicLayer(newShape);
            layer.alpha = alpha;
            layer.blendMode = blendMode;
            layer.locked = false;
            layer.name = name;
            layer.visible = visible;
            layer.setIndex(index);
            return layer;
        }
        
        /**
         * @inheritDoc
         */
        public override function get alpha():Number
        {
            return m_shape.alpha;
        }
        
        /**
         * @inheritDoc
         */
        public override function get blendMode():String
        {
            return m_shape.blendMode;
        }
        
        /**
         * @inheritDoc
         */
        public function get displayObject():DisplayObject
        {
            return m_shape;
        }
        
        /**
         * @inheritDoc
         */
        public function get height():uint
        {
            return m_shape.height;
        }
        
        /**
         * @inheritDoc
         */
        public override function get visible():Boolean
        {
            return m_shape.visible;
        }
        
        /**
         * @inheritDoc
         */
        public function get width():uint
        {
            return m_shape.width;
        }
        
        /**
         * @inheritDoc
         */
        public function get newDisplayObject():DisplayObject
        {
            return m_shape;
        }
        
        /**
         * @inheritDoc
         */
        public override function set alpha(value:Number):void
        {
            m_shape.alpha = value;
            m_colorTransform.alphaMultiplier = value;
        }
        
        /**
         * @inheritDoc
         */
        public override function set blendMode(value:String):void
        {
            m_shape.blendMode = value;
        }
        
        /**
         * @inheritDoc
         */
        public override function set visible(value:Boolean):void
        {
            m_shape.visible = value;
        }
        
        private var m_shape:Shape;
    }
}