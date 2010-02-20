package org.libspark.gunyarapaint.framework.test
{
    import flash.events.Event;
    
    import org.flexunit.Assert;
    import org.libspark.gunyarapaint.framework.UndoStack;
    import org.libspark.gunyarapaint.framework.events.UndoEvent;

    public class UndoStackTest
    {
        [Test(async,timeout="1000")]
        public function 巻き戻しが出来ること():void
        {
            var undo:UndoStack = new UndoStack(painter);
            undo.addEventListener(UndoEvent.UNDO, onUndo);
            undo.push(painter);
            undo.undo(painter);
        }
        
        [Test(async,timeout="1000")]
        public function やり直しが出来ること():void
        {
            var undo:UndoStack = new UndoStack(painter);
            undo.addEventListener(UndoEvent.REDO, onRedo);
            undo.push(painter);
            undo.undo(painter);
            undo.redo(painter);
        }
        
        [Test(expects="org.libspark.gunyarapaint.framework.errors.UndoError")]
        public function 過剰な巻き戻しが発生すると例外を送出する():void
        {
            var undo:UndoStack = new UndoStack(painter);
            undo.undo(painter);
        }
        
        [Test(expects="org.libspark.gunyarapaint.framework.errors.RedoError")]
        public function 過剰なやり直しが発生すると例外を送出する():void
        {
            var undo:UndoStack = new UndoStack(painter);
            undo.redo(painter);
        }
        
        private function onUndo(e:Event):void
        {
            var undo:UndoStack = UndoStack(e.target);
            Assert.assertEquals(0, undo.undoCount);
            Assert.assertEquals(1, undo.redoCount);
        }
        
        private function onRedo(e:Event):void
        {
            var undo:UndoStack = UndoStack(e.target);
            Assert.assertEquals(1, undo.undoCount);
            Assert.assertEquals(0, undo.redoCount);
        }
        
        private function get painter():FakePainter
        {
            var engine:FakePaintEngine = new FakePaintEngine();
            return new FakePainter(1, 1, engine);
        }
    }
}
