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
    import com.github.niji.framework.commands.ICommand;
    import com.github.niji.framework.commands.LineToCommand;
    import com.github.niji.framework.commands.MoveToCommand;
    import com.github.niji.framework.commands.RedoCommand;
    import com.github.niji.framework.commands.UndoCommand;
    import com.github.niji.framework.errors.EOLError;
    import com.github.niji.framework.errors.InvalidCommandError;
    import com.github.niji.framework.errors.InvalidSignatureError;
    import com.github.niji.framework.events.CommandEvent;
    
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    /**
     * ペイントログを解析して再生に必要な情報を管理するクラスです
     * 
     * @see CommandContext
     */
    public final class Parser extends CommandContext
    {
        /**
         * ヘッダーの終端位置
         */
        public static const EOH:uint = 26;
        
        /**
         * ログデータを解析対象として登録して生成します
         * 
         * @param bytes zlibから解凍済みのログデータ
         */
        public function Parser(bytes:ByteArray)
        {
            super();
            bytes.endian = Endian.BIG_ENDIAN;
            bytes.position = 0;
            m_bytes = bytes;
        }
        
        /**
         * ログのヘッダーを読み取ります.
         * 
         * <p>
         * 最初の 14bytes に "GUNYARA_PAINT:" 、次の 6bytes に バージョン番号、
         * 6bytes にそれぞれ 2bytes ずつで画像の幅、高さとアンドゥ回数が含まれます。
         * </p>
         * 
         * @param data
         * @throws InvalidSignatureError 最初の14文字がGUNYARA_PAINT:と一致しない場合
         */
        public function readHeader(data:Object):void
        {
            var signature:String = m_bytes.readUTFBytes(14);
			// 先頭の 14bytes を確認
            if (signature !== "GUNYARA_PAINT:") {
                throw new InvalidSignatureError();
            }
			// 6 bytes をとってバージョン文字列を確認
            var pattern:RegExp = /^(\d)\.(\d)\.(\d):$/;
            var version:uint = 0;
            var versionString:String = m_bytes.readUTFBytes(6);
            var matched:Object = pattern.exec(versionString);
            if (matched) {
                version = uint(matched[1]) * 100
                    + uint(matched[2]) * 10
                    + uint(matched[3]);
            }
			// 残り 6bytes はそれぞれ画像の幅と高さ、アンドゥ回数が入っている
            data.width = m_bytes.readShort();
            data.height = m_bytes.readShort();
            data.undo = m_bytes.readShort();
            data.version = version;
        }
        
        /**
         * ログを本体の最初の位置に移動します
         * 
         * @throws ArgumentError ログの大きさが 26 bytes 未満の場合
         */
        public function rewind():void
        {
			// 26bytes 未満であれば エラーを出す
            if (m_bytes.length < EOH) {
                throw new ArgumentError(
                    "log data' length is less than " + EOH + " bytes"
                );
            }
            m_bytes.position = EOH;
            m_position = 0;
        }
        
        /**
         * ログを先読みを行ないます.
         * 
         * <p>
         * ログの先読みによって、お絵描きログのコマンド数、最適なアンドゥ回数が分かります
         * </p>
         * 
         * @eventType CommandEvent.PREPARSE
         * @throws InvalidCommandError 登録されていないコマンドが検出された場合
         */
        public function preparse():void
        {
            rewind();
            var count:uint = 0;
            var previous:ICommand = new MoveToCommand();
            var undoCount:uint = 0;
            var maxUndo:uint = 0;
            var command:ICommand = null;
            var eventType:String = CommandEvent.PREPARSE;
            while (bytes.bytesAvailable > 0) {
				// TODO: Parser#parse を使う
                var byte:uint = bytes.readUnsignedByte();
                if (byte & 0x80) {
                    command = m_commands[LineToCommand.ID];
                    LineToCommand(command).compressedValue = byte;
                }
                else if (byte & 0x40) {
                    command = m_commands[MoveToCommand.ID];
                    MoveToCommand(command).compressedValue = byte;
                }
                else {
                    command = m_commands[byte];
                    if (command === null) {
                        throw new InvalidCommandError(count, byte);
                    }
                }
				// 連続して Undo または Redo が使われている場合のみカウントする
                if ((command.commandID === UndoCommand.ID ||
                    command.commandID === RedoCommand.ID) &&
                    (previous.commandID === UndoCommand.ID ||
                        previous.commandID === RedoCommand.ID)) {
                    undoCount++;
                }
				// それ以外の場合はリセットする
                else {
                    maxUndo = maxUndo < undoCount ? undoCount : maxUndo;
                    undoCount = 0;
                }
                previous = command;
                command.read(bytes);
                count++;
                if (hasEventListener(eventType))
                    dispatchEvent(new CommandEvent(eventType, command));
            }
            m_maxUndoCount = maxUndo + 1;
            m_count = count;
            resetCommands();
            rewind();
        }
        
        /**
         * ログを解析します.
         * 
         * <p>
         * 解析が完了すると、position が 1 増え、
         * CommandEvent.PARSE イベントが発生します。
         * 対応するコマンドがない場合は例外を送出します。
         * </p>
         * 
         * @return コマンドオブジェクト
         * @throws EOLError これ以上ログを読み込むことが出来ない場合
         * @throws InvalidCommandError 登録されていないコマンドを実行しようとした場合
         */
        public function parse():ICommand
        {
            var bytes:ByteArray = m_bytes;
            if (bytes.bytesAvailable === 0) {
                throw new EOLError();
            }
            var byte:uint = bytes.readUnsignedByte();
			// 0x80 の場合は例外として直線描写命令とみなす
            if (byte & 0x80) {
                command = m_commands[LineToCommand.ID];
                LineToCommand(command).compressedValue = byte;
            }
			// 0x40 の場合は例外として位置移動命令とみなす
            else if (byte & 0x40) {
                command = m_commands[MoveToCommand.ID];
                MoveToCommand(command).compressedValue = byte;
            }
            else {
                var command:ICommand = m_commands[byte];
				// 対応するコマンドが無い
                if (command === null) {
                    throw new InvalidCommandError(m_count, byte);
                }
            }
            m_position++;
            return command;
        }
        
        /**
         * ログデータそのものを返します
         */
        public function get bytes():ByteArray
        {
			// XXX: コピーした方が望ましいと考えられる
            return m_bytes;
        }
        
        /**
         * ログのコマンド数を返します
         */
        public function get count():uint
        {
            return m_count;
        }
        
        /**
         * 現在のログの解析回数を返します
         */
        public function get position():uint
        {
            return m_position;
        }
        
        /**
         * 先読みによって連続してアンドゥを行った回数を返します
         */
        public function get maxUndoCount():uint
        {
            return m_maxUndoCount;
        }
        
        private var m_bytes:ByteArray;
        private var m_count:uint;
        private var m_position:uint;
        private var m_maxUndoCount:uint;
    }
}
