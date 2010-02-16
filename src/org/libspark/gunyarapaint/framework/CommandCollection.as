package org.libspark.gunyarapaint
{
    import flash.events.EventDispatcher;
    
    import org.libspark.gunyarapaint.commands.BeginFillCommand;
    import org.libspark.gunyarapaint.commands.CompositeCommand;
    import org.libspark.gunyarapaint.commands.DrawCircleCommand;
    import org.libspark.gunyarapaint.commands.EndFillCommand;
    import org.libspark.gunyarapaint.commands.FloodFillCommand;
    import org.libspark.gunyarapaint.commands.HorizontalMirrorCommand;
    import org.libspark.gunyarapaint.commands.ICommand;
    import org.libspark.gunyarapaint.commands.LineToCommand;
    import org.libspark.gunyarapaint.commands.MoveToCommand;
    import org.libspark.gunyarapaint.commands.PenCommand;
    import org.libspark.gunyarapaint.commands.PixelCommand;
    import org.libspark.gunyarapaint.commands.RedoCommand;
    import org.libspark.gunyarapaint.commands.UndoCommand;
    import org.libspark.gunyarapaint.commands.VerticalMirrorCommand;
    import org.libspark.gunyarapaint.commands.layer.CopyLayerCommand;
    import org.libspark.gunyarapaint.commands.layer.CreateLayerCommand;
    import org.libspark.gunyarapaint.commands.layer.MergeLayerCommand;
    import org.libspark.gunyarapaint.commands.layer.RemoveLayerCommand;
    import org.libspark.gunyarapaint.commands.layer.SetLayerAlphaCommand;
    import org.libspark.gunyarapaint.commands.layer.SetLayerBlendModeCommand;
    import org.libspark.gunyarapaint.commands.layer.SetLayerIndexCommand;
    import org.libspark.gunyarapaint.commands.layer.SetLayerVisibleCommand;
    import org.libspark.gunyarapaint.commands.layer.SwapLayerCommand;
    import org.libspark.gunyarapaint.events.CommandEvent;

    public class CommandCollection extends EventDispatcher
    {
        public static const MAX_COMMANDS:uint = 256;
        
        public function CommandCollection()
        {
            m_commands = new Vector.<ICommand>(MAX_COMMANDS, true);
        }
        
        /**
         * 最初から入っているコマンドを全て登録する
         */
        public function loadCommands():void
        {
            registerCommand(new CopyLayerCommand());
            registerCommand(new CreateLayerCommand());
            registerCommand(new MergeLayerCommand());
            registerCommand(new RemoveLayerCommand());
            registerCommand(new SetLayerAlphaCommand());
            registerCommand(new SetLayerBlendModeCommand());
            registerCommand(new SetLayerIndexCommand());
            registerCommand(new SetLayerVisibleCommand());
            registerCommand(new SwapLayerCommand());
            registerCommand(new BeginFillCommand());
            registerCommand(new CompositeCommand());
            registerCommand(new DrawCircleCommand());
            registerCommand(new EndFillCommand());
            registerCommand(new FloodFillCommand());
            registerCommand(new HorizontalMirrorCommand());
            registerCommand(new LineToCommand());
            registerCommand(new MoveToCommand());
            registerCommand(new PenCommand());
            registerCommand(new PixelCommand());
            registerCommand(new RedoCommand());
            registerCommand(new UndoCommand());
            registerCommand(new VerticalMirrorCommand());
        }
        
        /**
         * コマンドの状態を全てリセットする
         */        
        public function resetCommands():void
        {
            var length:uint = MAX_COMMANDS;
            for (var i:uint = 0; i < length; i++) {
                var command:ICommand = m_commands[i];
                if (command !== null)
                    command.reset();
            }
        }
        
        /**
         * コマンドを登録する
         * 
         * @param command コマンドオブジェクト
         */
        public function registerCommand(command:ICommand):void
        {
            var id:uint = command.commandID;
            if (id & 0x80 || id & 0x40) {
                throw new ArgumentError();
            }
            else {
                m_commands[command.commandID] = command;
                if (hasEventListener(CommandEvent.REGISTERED))
                    dispatchEvent(
                        new CommandEvent(CommandEvent.REGISTERED, command)
                    );
            }
        }
        
        /**
         * コマンドを未登録にする
         * 
         * コマンドオブジェクトが MoveToCommand か LineToCommand もしくはコマンドのIDが
         * 0x80 または 0x40 に該当する場合、 ArgumentError を送出する。理由は registerCommand と同じ。
         * 未登録にした後、CommandEvent.UNREGISTERED イベントが発生する。
         * 
         * @param command コマンドオブジェクト
         */
        public function unregisterCommand(command:ICommand):void
        {
            var id:uint = command.commandID;
            if (id & 0x80 || id & 0x40) {
                throw new ArgumentError();
            }
            else {
                m_commands[command.commandID] = null;
                if (hasEventListener(CommandEvent.UNREGISTERED))
                    dispatchEvent(
                        new CommandEvent(CommandEvent.UNREGISTERED, command)
                    );
            }
        }
        
        protected var m_commands:Vector.<ICommand>;
    }
}