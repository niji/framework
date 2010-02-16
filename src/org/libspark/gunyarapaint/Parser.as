    package org.libspark.gunyarapaint
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import org.libspark.gunyarapaint.commands.ICommand;
    import org.libspark.gunyarapaint.commands.LineToCommand;
    import org.libspark.gunyarapaint.commands.MoveToCommand;
    import org.libspark.gunyarapaint.commands.RedoCommand;
    import org.libspark.gunyarapaint.commands.UndoCommand;
    import org.libspark.gunyarapaint.errors.EOLError;
    import org.libspark.gunyarapaint.errors.InvalidCommandError;
    import org.libspark.gunyarapaint.errors.InvalidSignatureError;
    import org.libspark.gunyarapaint.events.CommandEvent;
    
    public final class Parser extends CommandCollection
    {
        public static const EOH:uint = 26;
        
        public function Parser(bytes:ByteArray)
        {
            super();
            bytes.endian = Endian.BIG_ENDIAN;
            bytes.position = 0;
            m_bytes = bytes;
        }
        
        /**
         * ログのヘッダーを読み取る
         * 
         * 最初の 14bytes に "GUNYARA_PAINT:" 、次の 6bytes に バージョン番号、
         * 6bytes にそれぞれ 2bytes ずつで画像の幅、高さとアンドゥ回数が含まれる。
         * 最初の 14bytes に "GUNYARA_PAINT" が入っていない場合 InvalidSignatureError を送出する。
         * 
         * @param data
         */
        public function readHeader(data:Object):void
        {
            var signature:String = m_bytes.readUTFBytes(14);
            if (signature !== "GUNYARA_PAINT:") {
                throw new InvalidSignatureError();
            }
            var pattern:RegExp = /^(\d)\.(\d)\.(\d):$/;
            var version:uint = 0;
            var versionString:String = m_bytes.readUTFBytes(6);
            var matched:Object = pattern.exec(versionString);
            if (matched) {
                version = uint(matched[1]) * 100
                    + uint(matched[2]) * 10
                    + uint(matched[3]);
            }
            data.width = m_bytes.readShort();
            data.height = m_bytes.readShort();
            data.undo = m_bytes.readShort();
            data.version = version;
        }
        
        /**
         * ログを本体の最初の位置に移動する
         * 
         * ヘッダーは 26 bytes あるため、それ未満であれば ArgumentError を送出する。
         */
        public function rewind():void
        {
            if (m_bytes.length < EOH) {
                throw new ArgumentError(
                    "log data' length is less than 26 bytes"
                );
            }
            m_bytes.position = EOH;
            m_position = 0;
        }
        
        /**
         * ログを先読みする
         * 
         * ログの先読みによって、お絵描きログのコマンド数、最適なアンドゥ回数が分かる。
         * 未登録のコマンドが入っていた場合、InvalidCommandError を送出する。
         */
        public function preload():void
        {
            rewind();
            var count:uint = 0;
            var length:uint = bytes.length;
            var previous:ICommand = new MoveToCommand();
            var undoCount:uint = 0;
            var maxUndo:uint = 0;
            var command:ICommand = null;
            while (bytes.bytesAvailable > 0) {
                var byte:uint = bytes.readUnsignedByte();
                command = m_commands[byte];
                if (command === null) {
                    if (byte & 0x80) {
                        command = m_commands[LineToCommand.ID];
                        LineToCommand(command).compressedValue = byte;
                    }
                    else if (byte & 0x40) {
                        command = m_commands[MoveToCommand.ID];
                        MoveToCommand(command).compressedValue = byte;
                    }
                    else {
                        throw new InvalidCommandError(count, byte);
                    }
                }
                if ((command.commandID === UndoCommand.ID ||
                    command.commandID === RedoCommand.ID) &&
                    (previous.commandID === UndoCommand.ID ||
                    previous.commandID === RedoCommand.ID)) {
                    undoCount++;
                }
                else {
                    maxUndo = maxUndo < undoCount ? undoCount : maxUndo;
                    undoCount = 0;
                }
                previous = command;
                command.read(bytes);
                count++;
            }
            m_maxUndoCount = maxUndo + 1;
            m_count = count;
            resetCommands();
            rewind();
        }
        
        /**
         * ログを解析する
         * 
         * これ以上ログを読み込むことが出来ない場合は EOLError を送出する。
         * また、登録されていないコマンドを実行しようとした場合 InvalidCommandError を送出する。
         * 解析が完了すると、CommandEvent.PARSE イベントが発生する。
         * 
         * @return コマンド
         */
        public function parse():ICommand
        {
            var bytes:ByteArray = m_bytes;
            if (bytes.bytesAvailable === 0) {
                throw new EOLError();
            }
            var byte:uint = bytes.readUnsignedByte();
            var command:ICommand = m_commands[byte];
            if (command === null) {
                if (byte & 0x80) {
                    command = m_commands[LineToCommand.ID];
                    LineToCommand(command).compressedValue = byte;
                }
                else if (byte & 0x40) {
                    command = m_commands[MoveToCommand.ID];
                    MoveToCommand(command).compressedValue = byte;
                }
                else {
                    throw new InvalidCommandError(m_count, byte);
                }
            }
            m_position++;
            if (hasEventListener(CommandEvent.PARSE))
                dispatchEvent(new CommandEvent(CommandEvent.PARSE, command));
            return command;
        }
        
        /**
         * ログデータそのものを返す
         * 
         * @return ログデータ
         */
        public function get bytes():ByteArray
        {
            return m_bytes;
        }
        
        /**
         * ログのコマンド数を返す
         * 
         * @return ログのコマンド数
         */
        public function get count():uint
        {
            return m_count;
        }
        
        /**
         * 現在のログの解析回数を返す
         * 
         * @return 解析回数
         */
        public function get position():uint
        {
            return m_position;
        }
        
        /**
         * 先読みによって連続してアンドゥを行った回数を返す
         * 
         * @return アンドゥ回数
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
