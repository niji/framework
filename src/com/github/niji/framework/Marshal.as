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
/// @cond
package com.github.niji.framework
{
/// @endcond
    import com.github.niji.framework.errors.MarshalRectError;
    import com.github.niji.framework.errors.MarshalVersionError;
    import com.github.niji.framework.ui.IController;
    
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
     * ふっかつのじゅもんのデータとして保存するクラス.
     *
     * <p>以下のフォーマットに基づいて zlib 形式で圧縮して保存されます。</p>
     * <pre>
     * 1:uint          version
     * n:ByteArray     logData
     * n:Object        metadata
     * n:Vector.<uint> layerPixelData
     * n:Object        layerInfo
     * n:Object        undoData
     * n:Object        controllerData
     * </pre>
     */
    public final class Marshal
    {
        /**
         * ログのバージョン番号
         */
        public static const VERSION:uint = 1;

        public function Marshal(recorder:Recorder,
                                controllers:Vector.<IController>,
                                metadata:Object)
        {
            m_recorder = recorder;
            m_controllers = controllers;
            m_metadata = metadata;
        }

        /**
         * ふっかつのじゅもんを復元します
         *
         * @param bytes 読み込み元
         * @param toBytes お絵描きログの読み込み先
         * @throws MarshalVersionError
         */
        public function load(bytes:ByteArray, toBytes:ByteArray):void
        {
            bytes.position = 0;
            bytes.endian = Endian.BIG_ENDIAN;
            bytes.inflate();
            var version:uint = bytes.readUnsignedByte();
            if (version > VERSION)
                throw new MarshalVersionError(version, VERSION);
            var dataBytes:ByteArray = ByteArray(bytes.readObject());
            m_metadata = bytes.readObject();
            var pixels:Vector.<uint> = Vector.<uint>(bytes.readObject());
            var layerInfo:Object = bytes.readObject();
            var undoData:Object = bytes.readObject();
            var controllerData:Object = bytes.readObject();
            var lw:uint = m_metadata.width;
            var lh:uint = m_metadata.height;
            var layerImage:BitmapData = new BitmapData(lw, lh, true, 0x0);
            layerImage.setVector(new Rectangle(0, 0, lw, lh), pixels);
            dataBytes.readBytes(toBytes);
            m_recorder.layers.load(layerImage, layerInfo);
            delete m_metadata.width;
            delete m_metadata.height;
            var w:uint = layerInfo.width;
            var h:uint = layerInfo.height;
            var rw:uint = m_recorder.width;
            var rh:uint = m_recorder.height;
            if (w != rw || h != rh)
                throw new MarshalRectError(w, h, rw, rh);
            m_recorder.undoStack.load(undoData);
            toBytes.position = toBytes.length;
            var count:uint = m_controllers.length;
            for (var i:uint = 0; i < count; i++) {
                var controller:IController = m_controllers[i];
                var value:Object = controllerData[controller.name];
                controller.load(value);
            }
        }

        /**
         * ふっかつのじゅもんを保存します
         *
         * @param bytes 保存先
         * @param fromBytes お絵描きログ
         */
        public function save(bytes:ByteArray, fromBytes:ByteArray):void
        {
            var layerImage:BitmapData = m_recorder.layers.newLayerBitmapData;
            var metadata:Object = {};
            var undoData:Object = {};
            var rect:Rectangle = layerImage.rect;
            m_metadata.width = rect.width;
            m_metadata.height = rect.height;
            m_recorder.layers.save(layerImage, metadata);
            m_recorder.undoStack.save(undoData);
            bytes.endian = Endian.BIG_ENDIAN;
            bytes.writeByte(VERSION);
            bytes.writeObject(fromBytes);
            bytes.writeObject(m_metadata);
            bytes.writeObject(layerImage.getVector(rect));
            bytes.writeObject(metadata);
            bytes.writeObject(undoData);
            delete m_metadata.width;
            delete m_metadata.height;
            var controllerData:Object = {};
            var count:uint = m_controllers.length;
            for (var i:uint = 0; i < count; i++) {
                var value:Object = {};
                var controller:IController = m_controllers[i];
                controller.save(value);
                controllerData[controller.name] = value;
            }
            bytes.writeObject(controllerData);
            bytes.deflate();
            bytes.position = 0;
        }

        public function newRecorderBytes():ByteArray
        {
            return m_recorder.newBytes();
        }

        private var m_recorder:Recorder;
        private var m_controllers:Vector.<IController>;
        private var m_metadata:Object;
    }
}
