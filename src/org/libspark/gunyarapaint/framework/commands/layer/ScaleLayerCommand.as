package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
    public final class ScaleLayerCommand extends MovableLayerCommand implements ICommand
    {
        public static const ID:uint = 26;
        
        public function ScaleLayerCommand()
        {
            super();
        }
        
        public function execute(painter:Painter):void
        {
            painter.scale(m_coordinateX, m_coordinateY);
            painter.pushUndo();
        }
        
        public function toString():String
        {
            return "[ScaleLayerCommand x=" + m_coordinateX + ", y=" + m_coordinateY + "]";
        }
        
        public override function get commandID():uint
        {
            return ID;
        }
    }
}
