package org.libspark.gunyarapaint.framework.events
{
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * コマンド関連のイベント
     * 
     */
    public final class CommandEvent extends AbstractEvent
    {
        /**
         * ログから対応するコマンドオブジェクトが取得出来た後
         * 
         */
        public static const PARSE:String = PREFIX + "parse";
        
        /**
         * コマンド登録後
         * 
         */
        public static const REGISTERED:String = PREFIX + "registered";
        
        /**
         * コマンド解除後
         * 
         */
        public static const UNREGISTERED:String = PREFIX + "unregistered";
        
        /**
         * コマンドが書き込まれ、実行した後
         * 
         */
        public static const COMMITTED:String = PREFIX + "committed";
        
        public function CommandEvent(type:String, command:ICommand)
        {
            super(type, false, false);
            m_command = command;
        }
        
        /**
         * コマンドオブジェクトを返す
         * 
         */
        public function get command():ICommand
        {
            return m_command;
        }
        
        private var m_command:ICommand;
    }
}
