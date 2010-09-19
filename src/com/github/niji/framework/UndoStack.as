/*
    Copyright (c) 2008-2010, tasukuchan, hikarincl2
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name of the <organization> nor the
          names of its contributors may be used to endorse or promote products
          derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.github.niji.framework
{
    import flash.display.BitmapData;
    import flash.events.EventDispatcher;
    import flash.utils.ByteArray;
    
    import com.github.niji.framework.errors.RedoError;
    import com.github.niji.framework.errors.UndoError;
    import com.github.niji.framework.events.UndoEvent;
    
    /**
     * アンドゥを管理するクラスです
     * 
     */
    public final class UndoStack extends EventDispatcher
    {
        /**
         * アンドゥを管理する標準キュー値
         */
        public static const DEFAULT_SIZE:uint = 16;
        
        /**
         * アンドゥのキューを初期化し、最初にレイヤー配列を登録した状態で生成します
         *
         * @param layers レイヤー配列
         * @param size レイヤーを管理するキュー数
         */
        public function UndoStack(layers:LayerList,
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
        
		/**
		 * UndoStack を復元します
		 * 
		 * @param value #save() で保存したオブジェクト
         * @see #save()
		 */		
        public function load(value:Object):void
        {
            var bufferCount:uint = m_buffer.length;
            var data:Object = value.data;
            for (var i:uint = 0; i < bufferCount; i++) {
                var layerState:Object = data[i];
                m_buffer[i] = {};
                if (layerState != null) {
                    var layers:Vector.<Object> = layerState.layers;
                    var layerCount:uint = layers.length;
                    for (var j:uint = 0; j < layerCount; j++) {
                        var layer:Object = layers[j];
                        var bitmapData:BitmapData = new BitmapData(layer.width, layer.height);
                        var pixels:Vector.<uint> = Vector.<uint>(layer.bitmapData);
                        bitmapData.setVector(bitmapData.rect, pixels);
                        layer.bitmapData = bitmapData;
                        delete layer.width;
                        delete layer.height;
                    }
                    m_buffer[i] = layerState;
                }
            }
            m_index = value.index;
            m_first = value.first;
            m_last = value.last;
        }
        
		/**
		 * UndoStack を保存します
		 * 
		 * @param value　保存先となる空のオブジェクト
         * @see #load()
		 */		
        public function save(value:Object):void
        {
            var bufferCount:uint = m_buffer.length;
            var data:Array = [];
            for (var i:uint = 0; i < bufferCount; i++) {
                var layerState:Object = m_buffer[i];
                var layers:Vector.<Object> = layerState.layers;
                if (layers != null) {
                    var newLayerState:Object = {};
                    var newLayers:Vector.<Object> = new Vector.<Object>(layers.length, true);
                    var layerCount:uint = layers.length;
                    for (var j:uint = 0; j < layerCount; j++) {
                        var layer:Object = layers[j];
                        var newLayer:Object = {};
                        var bitmapData:BitmapData = BitmapData(layer.bitmapData);
                        var pixels:Vector.<uint> = bitmapData.getVector(bitmapData.rect);
                        for (var k:String in layer) {
                            newLayer[k] = layer[k];
                        }
                        newLayer.bitmapData = pixels;
                        newLayer.width = bitmapData.width;
                        newLayer.height = bitmapData.height;
                        newLayers[j] = newLayer;
                    }
                    for (var l:String in layerState) {
                        newLayerState[l] = layerState[l];
                    }
                    newLayerState.layers = newLayers;
                    data.push(newLayerState);
                }
            }
            value.data = data;
            value.index = m_index;
            value.first = m_first;
            value.last = m_last;
        }
        
        /**
         * 前回のレイヤーのスナップショットから巻き戻します
         * 
         * @param layers LayerbitmapCollectionオブジェクト
         * @eventType UndoEvent.UNDO
         */
        internal function undo(layers:LayerList):void
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
        
        /**
         * 前回のレイヤーのスナップショットからやり直します
         * 
         * @param layers LayerbitmapCollectionオブジェクト
         * @eventType UndoEvent.REDO
         */
        internal function redo(layers:LayerList):void
        {
            if (m_index === m_last) {
                throw new RedoError();
            }
            m_index = (m_index + 1) % m_buffer.length;
            layers.loadState(m_buffer[m_index]);
            if (hasEventListener(UndoEvent.REDO))
                dispatchEvent(new UndoEvent(UndoEvent.REDO));
        }
        
        /**
         * レイヤーのスナップショットを追加します
         * 
         * @param layers LayerbitmapCollectionオブジェクト
         */
        internal function push(layers:LayerList):void
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
        
		/**
		 * 巻き戻し可能な回数を返します
		 */
        public function get undoCount():uint
        {
            var count:int = m_index - m_first;
            return count < 0 ? count + m_buffer.length : count;
        }
        
		/**
		 * やり直し可能な回数を返します
		 */
        public function get redoCount():uint
        {
            var count:int = m_last - m_index;
            return count < 0 ? count + m_buffer.length : count;
        }
        
		/**
		 * UndoStack の大きさを返します
		 */
        public function get size():uint
        {
            return m_buffer.length - 1;
        }
        
        private var m_buffer:Vector.<Object>;
        private var m_index:uint;
        private var m_first:uint;
        private var m_last:uint;
    }
}