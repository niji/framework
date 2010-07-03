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
        public static const PREPARSE:String = prefix + "preparse";
        
        /**
         * ログから対応するコマンドオブジェクトが取得出来た後
         */
        public static const PARSE:String = prefix + "parse";
        
        /**
         * コマンド登録後
         */
        public static const REGISTERED:String = prefix + "registered";
        
        /**
         * コマンド解除後
         */
        public static const UNREGISTERED:String = prefix + "unregistered";
        
        /**
         * コマンドが書き込まれ、実行した後
         */
        public static const COMMITTED:String = prefix + "committed";
        
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
        
        public static function get prefix():String
        {
            return commonPrefix + "commandEvent.";
        }
        
        private var m_command:ICommand;
    }
}
