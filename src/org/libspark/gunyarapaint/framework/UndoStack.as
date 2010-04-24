package org.libspark.gunyarapaint.framework
{
    import flash.display.BitmapData;
    import flash.events.EventDispatcher;
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.errors.RedoError;
    import org.libspark.gunyarapaint.framework.errors.UndoError;
    import org.libspark.gunyarapaint.framework.events.UndoEvent;
    
    /**
     * アンドゥを管理する
     * 
     */
    public final class UndoStack extends EventDispatcher
    {
        public function UndoStack(layers:LayerBitmapCollection,
                                  size:uint = 16)
        {
            m_buffer = new Vector.<Object>(size + 1, true);
            m_index = 0;
            m_first = 0;
            m_last = 0;
            for (var i:uint = 0; i < size + 1; i++) {
                m_buffer[i] = {};
            }
            layers.saveState(m_buffer[0]);
        }
        
        public function load(value:Object):void
        {
            var bufferCount:uint = m_buffer.length;
            var data:Object = value.data;
            for (var i:uint = 0; i < bufferCount; i++) {
                var layers:Object = data[i];
                m_buffer[i] = {};
                if (layers != null) {
                    var layerCount:uint = layers.length;
                    for (var j:uint = 0; j < layerCount; j++) {
                        var layer:Object = layers[j];
                        var bitmapData:BitmapData = new BitmapData(layer.width, layer.height);
                        var pixels:ByteArray = ByteArray(layer.bitmapData);
                        pixels.position = 0;
                        bitmapData.setPixels(bitmapData.rect, pixels);
                        layer.bitmapData = bitmapData;
                        delete layer.width;
                        delete layer.height;
                    }
                    m_buffer[i] = layers;
                }
            }
            m_index = value.index;
            m_first = value.first;
            m_last = value.last;
        }
        
        public function save(value:Object):void
        {
            var bufferCount:uint = m_buffer.length;
            var buffer:Array = [];
            for (var i:uint = 0; i < bufferCount; i++) {
                var layers:Object = m_buffer[i].layers;
                if (layers != null) {
                    var layerCount:uint = layers.length;
                    for (var j:uint = 0; j < layerCount; j++) {
                        var layer:Object = layers[j];
                        var bitmapData:BitmapData = BitmapData(layer.bitmapData);
                        var pixels:ByteArray = bitmapData.getPixels(bitmapData.rect);
                        pixels.position = 0;
                        layer.bitmapData = pixels;
                        layer.width = bitmapData.width;
                        layer.height = bitmapData.height;
                    }
                    buffer.push(layers);
                }
            }
            value.data = buffer;
            value.index = m_index;
            value.first = m_first;
            value.last = m_last;
        }
        
        internal function undo(layers:LayerBitmapCollection):void
        {
            if (m_index === m_first) {
                throw new UndoError();
            }
            else if (m_index === 0) {
                m_index = m_buffer.length - 1;
            }
            else {
                m_index--;
            }
            layers.loadState(m_buffer[m_index]);
            if (hasEventListener(UndoEvent.UNDO))
                dispatchEvent(new UndoEvent(UndoEvent.UNDO));
        }
        
        internal function redo(layers:LayerBitmapCollection):void
        {
            if (m_index === m_last) {
                throw new RedoError();
            }
            m_index = (m_index + 1) % m_buffer.length;
            layers.loadState(m_buffer[m_index]);
            if (hasEventListener(UndoEvent.REDO))
                dispatchEvent(new UndoEvent(UndoEvent.REDO));
        }
        
        internal function push(layers:LayerBitmapCollection):void
        {
            m_index = (m_index + 1) % m_buffer.length;
            layers.saveState(m_buffer[m_index]);
            m_last = m_index;
            if (m_index === m_first) {
                m_first = (m_first + 1) % m_buffer.length;
            }
            if (hasEventListener(UndoEvent.PUSH))
                dispatchEvent(new UndoEvent(UndoEvent.PUSH));
        }
        
        public function get undoCount():uint
        {
            var count:int = m_index - m_first;
            return count < 0 ? count + m_buffer.length : count;
        }
        
        public function get redoCount():uint
        {
            var count:int = m_last - m_index;
            return count < 0 ? count + m_buffer.length : count;
        }
        
        private var m_buffer:Vector.<Object>;
        private var m_index:uint;
        private var m_first:uint;
        private var m_last:uint;
    }
}