package org.libspark.gunyarapaint.framework
{
    import flash.events.EventDispatcher;
    
    import org.libspark.gunyarapaint.framework.commands.BeginFillCommand;
    import org.libspark.gunyarapaint.framework.commands.BezierCurveCommand;
    import org.libspark.gunyarapaint.framework.commands.CompatibilityCommand;
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
    import org.libspark.gunyarapaint.framework.commands.ResetAllCommand;
    import org.libspark.gunyarapaint.framework.commands.UndoCommand;
    import org.libspark.gunyarapaint.framework.commands.VerticalMirrorCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.CopyLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.CreateLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.MergeLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.MoveLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.RemoveLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.ScaleLayerCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerAlphaCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerBlendModeCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerIndexCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SetLayerVisibleCommand;
    import org.libspark.gunyarapaint.framework.commands.layer.SwapLayerCommand;
    import org.libspark.gunyarapaint.framework.events.CommandEvent;
    
    /**
     * コマンドを管理する
     * 
     */
    public class CommandContext extends EventDispatcher
    {
        public static const MAX_COMMANDS:uint = 64;
        
        /*
         * 1 = MoveToCommand
         * 2 = LineToCommand
         * 3 = LineStyleCommand
         * 4 = DrawShapeOnBitmap
         * 5 = UndoCommand
         * 6 = RedoCommand
         * 7 = BeginFillCommand
         * 8 = EndFillCommand
         * 9 = DrawRectCommand (unused)
         * 10 = DrawCircleCommand
         * 11 = DrawEllipseCommand (unused)
         * 12 = DrawRoundRectCommand (unsed)
         * 13 = FloodFillCommand
         * 14 = CreateLayerCommand
         * 15 = CopyLayerCommand
         * 16 = SwapCommandCommand
         * 17 = MergeLayerCommand
         * 18 = RemoveLayerCommand
         * 19 = SetLayerIndexCommand
         * 20 = SetLayerVisibleCommand
         * 21 = SetLayerBlendModeCommand
         * 22 = SetLayerAlphaCommand
         * 23 = PixelCommand
         * 24 = HorizontalMirrorCommand
         * 25 = VerticalMirrorCommand
         *
         * 26以降について (予定)
         * 26 = ScaleLayerCommand
         * 27 = MoveLayerCommand
         * 28 = BezierCurveCommand
         * 29 = CompatibilityCommand
         * 30 = ResetAllCommand
         */
        public function CommandContext()
        {
            m_commands = new Vector.<ICommand>(MAX_COMMANDS, true);
            registerCommand(new CopyLayerCommand());
            registerCommand(new CreateLayerCommand());
            registerCommand(new MergeLayerCommand());
            registerCommand(new MoveLayerCommand());
            registerCommand(new RemoveLayerCommand());
            registerCommand(new ScaleLayerCommand());
            registerCommand(new SetLayerAlphaCommand());
            registerCommand(new SetLayerBlendModeCommand());
            registerCommand(new SetLayerIndexCommand());
            registerCommand(new SetLayerVisibleCommand());
            registerCommand(new SwapLayerCommand());
            registerCommand(new BeginFillCommand());
            registerCommand(new BezierCurveCommand());
            registerCommand(new CompatibilityCommand);
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
            registerCommand(new ResetAllCommand());
            registerCommand(new UndoCommand());
            registerCommand(new VerticalMirrorCommand());
            super();
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
         * <p>
         * 登録にした後、CommandEvent.REGISTERED イベントが発生する。
         * </p>
         * 
         * @param command コマンドオブジェクト
         * @throws ArgumentError command が 0x80 または 0x40 とビット演算で一致する場合
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
         * <p>
         * 未登録にした後、CommandEvent.UNREGISTERED イベントが発生する。
         * </p>
         * 
         * @param command コマンドオブジェクト
         * @throws ArgumentError command が 0x80 または 0x40 とビット演算で一致する場合
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
        
        /**
         * @private
         * 
         */
        protected var m_commands:Vector.<ICommand>;
    }
}