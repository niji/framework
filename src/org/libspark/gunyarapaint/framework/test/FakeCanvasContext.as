package org.libspark.gunyarapaint.framework.test
{
    import org.libspark.gunyarapaint.framework.CanvasContext;
    import org.libspark.gunyarapaint.framework.Painter;
    
    public class FakeCanvasContext extends CanvasContext
    {
        public function FakeCanvasContext()
        {
            m_fakePainter = new FakePainter(1, 1, new FakePaintEngine());
            m_didUndo = false;
            m_didRedo = false;
            m_pushUndo = false;
            m_pushUndoIfNeed = false;
            super();
        }
        
        public override function undo():void
        {
            m_didUndo = true;
        }
        
        public override function redo():void
        {
            m_didRedo = true;
        }
        
        public override function pushUndo():void
        {
            m_pushUndo = true;
        }
        
        public override function pushUndoIfNeed():void
        {
            m_pushUndoIfNeed = true;
        }
        
        public override function get painter():Painter
        {
            return m_fakePainter;
        }
        
        public function get didUndo():Boolean
        {
            return m_didUndo;
        }
        
        public function get didRedo():Boolean
        {
            return m_didRedo;
        }
        
        public function get didPushUndo():Boolean
        {
            return m_pushUndo;
        }
        
        public function get didPushUndoIfNeed():Boolean
        {
            return m_pushUndoIfNeed;
        }
        
        private var m_fakePainter:FakePainter;
        private var m_didUndo:Boolean;
        private var m_didRedo:Boolean;
        private var m_pushUndo:Boolean;
        private var m_pushUndoIfNeed:Boolean;
    }
}