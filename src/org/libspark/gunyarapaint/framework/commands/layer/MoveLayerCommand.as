package org.libspark.gunyarapaint.framework.commands.layer
{
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     *  
     */
    public final class MoveLayerCommand extends MovableLayerCommand implements ICommand
    {
        public static const ID:uint = 27;
        
        public function MoveLayerCommand()
        {
            super();
        }
        
        public function execute(painter:Painter):void
        {
            painter.move(m_coordinateX, m_coordinateY);
            painter.pushUndo();
        }
        
        public function toString():String
        {
            return "[MoveLayerCommand]";
        }
        
        public override function get commandID():uint
        {
            return ID;
        }
    }
}
