package org.libspark.gunyarapaint.framework
{
    import flash.events.TimerEvent;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
    
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.errors.EOLError;
    import org.libspark.gunyarapaint.framework.events.CommandEvent;
    import org.libspark.gunyarapaint.framework.events.PlayerErrorEvent;
    import org.libspark.gunyarapaint.framework.events.PlayerEvent;
    
    /**
     * ログを再生するクラスです
     * 
     * @see Painter
     */
    public final class Player extends Painter
    {
        /**
         * Parser オブジェクトの登録及び再生準備をして生成します
         *
         * @param parser Parser オブジェクト
         */
        public function Player(parser:Parser)
        {
            var data:Object = {};
            parser.readHeader(data);
            parser.preparse();
            speed = 1;
            m_timer = new Timer(50);
            m_timer.addEventListener(TimerEvent.TIMER, process);
            m_parser = parser;
            var version:uint = data.version;
            super(data.width, data.height, version, createPaintEngine(version));
        }
        
        /**
         * ログデータを読み込みます.
         * 
         * <p>
         * まず先読みを実行してからお絵描きログを読み込んで再生出来る状態にします。
         * このクラスを継承する Player はこれを必ず実行する必要があります。
         * </p>
         * 
         * @param bytes ログデータ
         */
        public static function create(bytes:ByteArray):Player
        {
            var player:Player = new Player(new Parser(bytes));
            player.setUndoStack(new UndoStack(player.layers));
            return player;
        }
        
        /**
         * ログを再生します
         * 
         * @eventType PlayerEvent.STARTED
         */
        public function start():void
        {
            if (!m_timer.running) {
                m_timer.start();
                if (hasEventListener(PlayerEvent.STARTED))
                    dispatchEvent(new PlayerEvent(PlayerEvent.STARTED));
            }
        }
        
        /**
         * ログの再生を一時停止します
         * 
         * @eventType PlayerEvent.PAUSED
         */
        public function pause():void
        {
            if (m_timer.running) {
                m_timer.stop();
                if (hasEventListener(PlayerEvent.PAUSED))
                    dispatchEvent(new PlayerEvent(PlayerEvent.PAUSED));
            }
        }
        
        /**
         * ログの再生を停止します
         * 
         * @eventType PlayerEvent.STOPPED
         */
        public function stop():void
        {
            if (m_timer.running) {
                m_timer.stop();
                m_parser.rewind();
                m_parser.resetCommands();
                if (hasEventListener(PlayerEvent.STOPPED))
                    dispatchEvent(new PlayerEvent(PlayerEvent.STOPPED));
            }
        }
        
        /**
         * @eventType CommandEvent.PARSE
         * @eventType PlayerEvent.UPDATED
         * @eventType PlayerEvent.FINISHED
         */ 
        private function process(event:TimerEvent):void
        {
            try {
                var parseEvent:String = CommandEvent.PARSE;
                var updateEvent:String = PlayerEvent.UPDATED;
                var bytes:ByteArray = m_parser.bytes;
                for (var i:uint = 0; i < speed; i++) {
                    var command:ICommand = m_parser.parse();
                    command.read(bytes);
                    if (hasEventListener(parseEvent))
                        dispatchEvent(new CommandEvent(parseEvent, command));
                    command.execute(this);
                    if (hasEventListener(updateEvent))
                        dispatchEvent(new PlayerEvent(updateEvent));
                }
            }
            catch (e:Error) {
                m_timer.stop();
                if (e is EOLError) {
                    m_parser.rewind();
                    m_parser.resetCommands();
                    // 再生が完了している場合はそのイベントを送出する
                    if (hasEventListener(PlayerEvent.FINISHED))
                        dispatchEvent(new PlayerEvent(PlayerEvent.FINISHED));
                }
                else {
                    // 再生が途中で終了するようなエラーが出た
                    if (hasEventListener(PlayerErrorEvent.ERROR))
                        dispatchEvent(new PlayerErrorEvent(PlayerErrorEvent.ERROR, e));
                }
            }
        }
        
        /**
         * ログのコマンド数を返します
         */
        public function get count():uint
        {
            return m_parser.count;
        }
        
        /**
         * 現在のログの解析回数を返します
         */
        public function get position():uint
        {
            return m_parser.position;
        }
        
        /**
         * 再生中かどうかのフラグを返します
         */
        public function get playing():Boolean
        {
            return m_timer.running;
        }
        
        /**
         * 現在の再生速度を返します
         */
        public var speed:uint;
        
        /**
         * 現在の動作間隔をミリ秒単位で返します
         */
        public function set duration(value:uint):void
        {
            m_timer.delay = value;
        }
        
        private var m_parser:Parser;
        private var m_timer:Timer;
    }
}