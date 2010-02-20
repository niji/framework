package org.libspark.gunyarapaint.framework.components
{
    import flash.events.MouseEvent;
    
    import mx.controls.DataGrid;
    
    public class LayerDataGrid extends DataGrid
    {
        public function LayerDataGrid()
        {
            super();
            doubleClickEnabled = true;
        }
        
        override protected function mouseDoubleClickHandler(event:MouseEvent):void
        {
            super.mouseDoubleClickHandler(event);
            super.mouseDownHandler(event);
            super.mouseUpHandler(event);
        }
        
        override protected function mouseUpHandler(event:MouseEvent):void
        {
            var saved:Boolean = editable;
            editable = false;
            super.mouseUpHandler(event);
            editable = saved;
        }
    }
}
