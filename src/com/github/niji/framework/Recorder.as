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
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import com.github.niji.framework.commands.ICommand;
    import com.github.niji.framework.events.CommandEvent;
    
    /**
     * ログを記録するクラスです
     * 
     * @see Painter
     */
    public final class Recorder extends Painter
    {
        /**
         * やり直し可能な回数の初期値
         * 
         */
        public static const DEFAULT_UNDO_MAX:uint = 16;
        
        /**
         * ログデータ及びCommandContextを登録して記録可能な状態にしてから生成します.
         *
         * <p>
         * コンストラクタから直接生成しないでください。代わりに
         * Recorder#create() を呼び出す必要があります
         * </p>
         *
         * @param bytes 空のログデータ
         * @param width 画像の幅
         * @param height 画像の高さ
         * @param commands CommandContext オブジェクト
         * @see #create()
         */
        public function Recorder(bytes:ByteArray, width:uint, height:uint, commands:CommandContext)
        {
            m_bytes = bytes;
            m_command = commands;
            var version:uint = Version.LOG_VERSION;
            super(width, height, version, createPaintEngine(version));
        }
        
        /**
         * オブジェクトの生成及びヘッダーに書き込みを同時に行ないます
         * 
         * @param width 画像の幅
         * @param height 画像の高さ
         * @param undo やり直しできる回数
         */
        public static function create(bytes:ByteArray, width:int, height:int, undo:int):Recorder
        {
            var commands:CommandContext = new CommandContext();
            var version:uint = Version.LOG_VERSION;
            bytes.endian = Endian.BIG_ENDIAN;
            bytes.position = 0;
            var signature:String = "GUNYARA_PAINT:"
                + uint(version / 100)         + "."
                + uint((version % 100) / 10)  + "."
                + uint(version % 10)          + ":"
            bytes.writeUTFBytes(signature);
            bytes.writeShort(width);
            bytes.writeShort(height);
            bytes.writeShort(undo);
            var recorder:Recorder = new Recorder(bytes, width, height, commands);
            recorder.setUndoStack(new UndoStack(recorder.layers, undo));
            return recorder;
        }
        
        /**
         * コマンドの書き出し及び実行を同時に行います
         * 
         * @param command コマンドオブジェクト
         * @param args コマンドに対する引数
         * @eventType CommandEvent.COMMITTED
         */
        public function commitCommand(id:uint, args:Object):void
        {
            var command:ICommand = m_command.getCommand(id);
            command.write(m_bytes, args);
            command.execute(this);
            if (hasEventListener(CommandEvent.COMMITTED))
                dispatchEvent(new CommandEvent(CommandEvent.COMMITTED, command));
        }
        
        /**
         * 現在のログデータをコピーして返します
         */
        public function newBytes():ByteArray
        {
            var bytes:ByteArray = new ByteArray();
            var pos:uint = m_bytes.position;
            bytes.writeBytes(m_bytes);
            bytes.compress();
            m_bytes.position = pos;
            return bytes;
        }
        
        private var m_command:CommandContext;
        private var m_bytes:ByteArray;
    }
}
