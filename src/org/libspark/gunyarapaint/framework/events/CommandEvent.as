package org.libspark.gunyarapaint.framework.events
{
    import org.libspark.gunyarapaint.framework.commands.ICommand;

    public final class CommandEvent extends AbstractEvent
    {
        public static const PARSE:String = PREFIX + "parse";
        
        public static const REGISTERED:String = PREFIX + "registered";
        
        public static const UNREGISTERED:String = PREFIX + "unregistered";
        
        public static const COMMITTED:String = PREFIX + "committed";
        
        public function CommandEvent(type:String, command:ICommand)
        {
            super(type, false, false);
            m_command = command;
        }
        
        public function get command():ICommand
        {
            return m_command;
        }
        
        private var m_command:ICommand;
    }
}
