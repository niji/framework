package org.libspark.gunyarapaint.framework
{
    import flash.utils.ByteArray;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
    
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.errors.EOLError;
    import org.libspark.gunyarapaint.framework.events.PlayerEvent;
    
    /**
     * ログを再生する
     * 
     */
    public final class Player extends CanvasContext
    {
        public function Player(parser:Parser)
        {
            var data:Object = {};
            parser.readHeader(data);
            parser.loadCommands();
            parser.preload();
            speed = 1;
            duration = 50;
            m_timerID = 0;
            m_parser = parser;
            var version:uint = data.version;
            super(data.width, data.height, version, createPaintEngine(version));
        }
        
        /**
         * ログデータを読み込む
         * 
         * <p>
         * まず先読みを実行してからお絵描きログを読み込んで再生出来る状態にする。
         * このクラスを継承する Player はこれを必ず実行する必要がある。
         * </p>
         * 
         * @param bytes ログデータ
         */
        public static function load(bytes:ByteArray):Player
        {
            var player:Player = new Player(new Parser(bytes));
            player.setUndo(new UndoStack(player, player.m_parser.maxUndoCount));
            return player;
        }
        
        /**
         * ログを再生する
         * 
         * <p>
         * PlayerEvent.STARTED イベントが発生する
         * </p>
         * 
         */
        public function start():void
        {
            if (m_timerID === 0) {
                m_timerID = flash.utils.setInterval(process, duration);
                if (hasEventListener(PlayerEvent.STARTED))
                    dispatchEvent(new PlayerEvent(PlayerEvent.STARTED));
            }
        }
        
        /**
         * ログの再生を一時停止する
         * 
         * <p>
         * PlayerEvent.PAUSED イベントが発生する
         * </p>
         * 
         */
        public function pause():void
        {
            stopTimer();
            if (hasEventListener(PlayerEvent.PAUSED))
                dispatchEvent(new PlayerEvent(PlayerEvent.PAUSED));
        }
        
        /**
         * ログの再生を停止する
         * 
         * <p>
         * PlayerEvent.STOPPED イベントが発生する
         * </p>
         * 
         */
        public function stop():void
        {
            stopTimer();
            m_parser.rewind();
            m_parser.resetCommands();
            if (hasEventListener(PlayerEvent.STOPPED))
                dispatchEvent(new PlayerEvent(PlayerEvent.STOPPED));
        }
        
        private function process():void
        {
            try {
                var bytes:ByteArray = m_parser.bytes;
                for (var i:uint = 0; i < speed; i++) {
                    var command:ICommand = m_parser.parse();
                    command.read(bytes);
                    command.execute(this);
                    if (hasEventListener(PlayerEvent.UPDATED))
                        dispatchEvent(new PlayerEvent(PlayerEvent.UPDATED));
                }
            }
            catch (e:Error) {
                stopTimer();
                if (e is EOLError) {
                    m_parser.rewind();
                    m_parser.resetCommands();
                    // 再生が完了している場合はそのイベントを送出する
                    if (hasEventListener(PlayerEvent.FINISHED))
                        dispatchEvent(new PlayerEvent(PlayerEvent.FINISHED));
                }
                else {
                    // 再生が途中で終了するようなエラーが出た
                    trace(e.getStackTrace());
                }
            }
        }
        
        private function stopTimer():void
        {
            flash.utils.clearInterval(m_timerID);
            m_timerID = 0;
        }
        
        /**
         * ログのコマンド数を返す
         * 
         */
        public function get count():uint
        {
            return m_parser.count;
        }
        
        /**
         * 現在のログの解析回数を返す
         * 
         */
        public function get position():uint
        {
            return m_parser.position;
        }
        
        /**
         * 再生中かどうかを調べる
         * 
         */
        public function get playing():Boolean
        {
            return m_timerID != 0;
        }
        
        /**
         * 再生速度
         * 
         */
        public var speed:uint;
        
        /**
         * ログの長さ
         * 
         */
        public var duration:uint;
        
        private var m_parser:Parser;
        private var m_timerID:uint;
    }
}