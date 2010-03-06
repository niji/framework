package org.libspark.gunyarapaint.framework
{
    import flash.events.EventDispatcher;
    
    import org.libspark.gunyarapaint.framework.commands.BeginFillCommand;
    import org.libspark.gunyarapaint.framework.commands.CompositeCommand;
    import org.libspark.gunyarapaint.framework.commands.DrawCircleCommand;
    import org.libspark.gunyarapaint.framework.commands.EndFillCommand;
    import org.libspark.gunyarapaint.framework.commands.FloodFillCommand;
    import org.libspark.gunyarapaint.framework.commands.HorizontalMirrorCommand;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.commands.LineToCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    import org.libspark.gunyarapaint.framework.commands.PenCommand;
    import org.libspark.gunyarapaint.framework.commands.PixelCommand;
    import org.libspark.gunyarapaint.framework.commands.RedoCommand;
    import org.libspark.gunyarapaint.framework.commands.UndoCommand;
    import org.libspark.gunyarapaint.framework.commands.VerticalMirrorCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.CopyLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.CreateLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.MergeLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.RemoveLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerAlphaCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerBlendModeCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerIndexCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerVisibleCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SwapLayerCommand;
    import org.libspark.gunyarapaint.framework.events.CommandEvent;

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
        
        /**
         * 引数からコマンドオブジェクトを返す
         * 
         * @return ICommand コマンドオブジェクト
         * @throws ArgumentError 引数の値が0x80または0x40とビット演算レベルで一致する場合
         */
        public function getCommand(id:uint):ICommand
        {
            if (id & 0x80 || id & 0x40) {
                throw new ArgumentError();
            }
            else {
                return m_commands[id];
            }
        }
        
        protected var m_commands:Vector.<ICommand>;
    }
}