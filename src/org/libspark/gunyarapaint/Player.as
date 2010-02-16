package org.libspark.gunyarapaint
{
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
    
    import org.libspark.gunyarapaint.commands.ICommand;
    import org.libspark.gunyarapaint.errors.EOLError;
    import org.libspark.gunyarapaint.events.PlayerEvent;

    public final class Player extends CanvasContext
    {
        public function Player()
        {
            super();
            speed = 1;
            duration = 50;
            m_timerID = 0;
        }
        
        /**
         * ログデータを読み込む
         * 
         * まず先読みを実行してからお絵描きログを読み込んで再生出来る状態にする。
         * このクラスを継承する Player はこれを必ず実行する必要がある。
         * 
         * @param bytes ログデータ
         */
        public function load(bytes:ByteArray):void
        {
            var data:Object = {};
            m_parser = new Parser(bytes);
            m_parser.readHeader(data);
            var width:uint = m_width = data.width;
            var height:uint = m_height = data.height;
            var version:uint = m_version = data.version;
            createPainter(width, height, version);
            m_parser.loadCommands();
            m_parser.preload();
            m_undo = new UndoStack(m_painter, m_parser.maxUndoCount);
        }
        
        public function restore(layerBitmaps:BitmapData, metadata:Object):void
        {
            m_painter.restore(layerBitmaps, metadata);
        }
        
        /**
         * ログデータを再読み込みしてオブジェクトを初期化する
         * 
         */
        public function reload():void
        {
            createPainter(m_width, m_height, m_version);
            m_parser.resetCommands();
            m_undo = new UndoStack(m_painter, m_parser.maxUndoCount);
        }
        
        /**
         * ログを再生する
         * 
         * PlayerEvent.STARTED イベントが発生する
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
         * PlayerEvent.PAUSED イベントが発生する
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
         * PlayerEvent.STOPPED イベントが発生する
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
         * @return ログのコマンド数
         */
        public function get count():uint
        {
            return m_parser.count;
        }
        
        /**
         * 現在のログの解析回数を返す
         * 
         * @return 解析回数
         */
        public function get position():uint
        {
            return m_parser.position;
        }
        
        /**
         * 再生中かどうかを調べる
         * 
         * @return 再生中であれば真
         */
        public function get playing():Boolean
        {
            return m_timerID != 0;
        }
        
        public var speed:uint;
        public var duration:uint;
        protected var m_parser:Parser;
        private var m_timerID:uint;
    }
}