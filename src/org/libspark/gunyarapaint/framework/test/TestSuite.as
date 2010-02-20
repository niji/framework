package org.libspark.gunyarapaint.framework.test
{
    import org.libspark.gunyarapaint.framework.test.commands.BeginFillCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.CompositeCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.DrawCircleCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.EndFillComamndTest;
    import org.libspark.gunyarapaint.framework.test.commands.FloodFillCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.HorizontalMirrorCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.LineToCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.MoveToCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.PenCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.PixelCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.RedoCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.UndoCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.VerticalMirrorCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.layer.CopyLayerCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.layer.CreateLayerCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.layer.MergeLayerCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.layer.RemoveLayerCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.layer.SetLayerAlphaCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.layer.SetLayerBlendModeCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.layer.SetLayerIndexCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.layer.SetLayerVisibleCommandTest;
    import org.libspark.gunyarapaint.framework.test.commands.layer.SwapLayerCommandTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class TestSuite
    {
        public var copyLayerCommand:CopyLayerCommandTest;
        
        public var createLayerCommand:CreateLayerCommandTest;
        
        public var mergeLayerCommand:MergeLayerCommandTest;
        
        public var removeLayerCommand:RemoveLayerCommandTest;
        
        public var setLayerAlphaCommand:SetLayerAlphaCommandTest;
        
        public var setLayerBlendModeCommand:SetLayerBlendModeCommandTest;
        
        public var setLayerIndexCommand:SetLayerIndexCommandTest;
        
        public var setLayerVisibleCommand:SetLayerVisibleCommandTest;
        
        public var swapLayerCommand:SwapLayerCommandTest;
        
        public var beginFillCommand:BeginFillCommandTest;
        
        public var compositeCommand:CompositeCommandTest;
        
        public var drawCircleCommand:DrawCircleCommandTest;
        
        public var endFillCommand:EndFillComamndTest;
        
        public var floodFillCommand:FloodFillCommandTest;
        
        public var horizontalMirrorCommand:HorizontalMirrorCommandTest;
        
        public var lineToCommand:LineToCommandTest
        
        public var moveToCommand:MoveToCommandTest
        
        public var penCommand:PenCommandTest;
        
        public var pixelCommand:PixelCommandTest;
        
        public var redoCommand:RedoCommandTest;
        
        public var undoCommand:UndoCommandTest;
        
        public var verticalMirrorCommand:VerticalMirrorCommandTest;
        
        public var layerBitmapContainer:LayerBitmapContainerTest;
        
        public var layerBitmap:LayerBitmapTest;
        
        public var painter:PainterTest;
        
        public var parser:ParserTest;
        
        public var player:PlayerTest;
        
        public var undo:UndoStackTest;
    }
}
