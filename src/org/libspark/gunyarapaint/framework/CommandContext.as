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
     * コマンドを管理するクラスです.
     * 
     * <table>
     * <thead>
     * <th><td>番号</td><td>コマンド名</td></th>
     * </thead>
     * <tbody>
     * <tr><td>1</td><td>MoveToCommand</td></tr>
     * <tr><td>2</td><td>LineToCommand</td></tr>
     * <tr><td>3</td><td>LineStyleCommand</td></tr>
     * <tr><td>4</td><td>DrawShapeOnBitmap</td></tr>
     * <tr><td>5</td><td>UndoCommand</td></tr>
     * <tr><td>6</td><td>RedoCommand</td></tr>
     * <tr><td>7</td><td>BeginFillCommand</td></tr>
     * <tr><td>8</td><td>EndFillCommand</td></tr>
     * <tr><td>9</td><td>DrawRectCommand</td></tr> (unused)
     * <tr><td>10</td><td>DrawCircleCommand</td></tr>
     * <tr><td>11</td><td>DrawEllipseCommand</td></tr> (unused)
     * <tr><td>12</td><td>DrawRoundRectCommand</td></tr> (unsed)
     * <tr><td>13</td><td>FloodFillCommand</td></tr>
     * <tr><td>14</td><td>CreateLayerCommand</td></tr>
     * <tr><td>15</td><td>CopyLayerCommand</td></tr>
     * <tr><td>16</td><td>SwapCommandCommand</td></tr>
     * <tr><td>17</td><td>MergeLayerCommand</td></tr>
     * <tr><td>18</td><td>RemoveLayerCommand</td></tr>
     * <tr><td>19</td><td>SetLayerIndexCommand</td></tr>
     * <tr><td>20</td><td>SetLayerVisibleCommand</td></tr>
     * <tr><td>21</td><td>SetLayerBlendModeCommand</td></tr>
     * <tr><td>22</td><td>SetLayerAlphaCommand</td></tr>
     * <tr><td>23</td><td>PixelCommand</td></tr>
     * <tr><td>24</td><td>HorizontalMirrorCommand</td></tr>
     * <tr><td>25</td><td>VerticalMirrorCommand</td></tr>
     * <tr><td>26</td><td>ScaleLayerCommand</td></tr>
     * <tr><td>27</td><td>MoveLayerCommand</td></tr>
     * <tr><td>28</td><td>BezierCurveCommand</td></tr>
     * <tr><td>29</td><td>CompatibilityCommand</td></tr>
     * <tr><td>30</td><td>ResetAllCommand</td></tr>
     * </tbody>
     * </table>
     * 
     * @see org.libspark.gunyarapaint.framework.commands.ICommand
     */
    public class CommandContext extends EventDispatcher
    {
        /**
         * 登録可能な最大コマンド数
         */
        public static const MAX_COMMANDS:uint = 64;
        
        /**
         * はじめから使用可能なコマンドを予め登録した状態で生成します
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
         * コマンドの状態を全てリセットします
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
         * コマンドを登録します
         * 
         * @param command コマンドオブジェクト
         * @eventType CommandEvent.REGISTERED
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
         * コマンドを未登録にします
         * 
         * @param command コマンドオブジェクト
         * @eventType CommandEvent.UNREGISTERED
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
         * 引数からコマンドオブジェクトを返します
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
         */
        protected var m_commands:Vector.<ICommand>;
    }
}
