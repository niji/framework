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
    import flash.events.TimerEvent;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
    
    import com.github.niji.framework.commands.ICommand;
    import com.github.niji.framework.errors.EOLError;
    import com.github.niji.framework.events.CommandEvent;
    import com.github.niji.framework.events.PlayerErrorEvent;
    import com.github.niji.framework.events.PlayerEvent;
    
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
            player.layers.throwsError = false;
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