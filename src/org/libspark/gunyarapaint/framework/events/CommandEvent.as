package org.libspark.gunyarapaint.framework.events
{
    import flash.events.Event;
    
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * コマンド関連のイベントです
     */
    public final class CommandEvent extends AbstractEvent
    {
        /**
         * 先読みでログから対応するコマンドオブジェクトが取得出来た後
         */
        public static const PREPARSE:String = PREFIX + "preparse";
        
        /**
         * ログから対応するコマンドオブジェクトが取得出来た後
         */
        public static const PARSE:String = PREFIX + "parse";
        
        /**
         * コマンド登録後
         */
        public static const REGISTERED:String = PREFIX + "registered";
        
        /**
         * コマンド解除後
         */
        public static const UNREGISTERED:String = PREFIX + "unregistered";
        
        /**
         * コマンドが書き込まれ、実行した後
         */
        public static const COMMITTED:String = PREFIX + "committed";
        
        /**
         * @inheritDoc 
         */
        public function CommandEvent(type:String, command:ICommand)
        {
            super(type, false, false);
            m_command = command;
        }
        
        /**
         * @inheritDoc
         */
        public override function clone():Event
        {
            return new CommandEvent(type, m_command);
        }
        
        /**
         * コマンドオブジェクトを返します
         */
        public function get command():ICommand
        {
            return m_command;
        }
        
        private var m_command:ICommand;
    }
}
