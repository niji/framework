/*
    Copyright (c) 2008-2010, tasukuchan, hikarincl2
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name of the <organization> nor the
          names of its contributors may be used to endorse or promote products
          derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.github.niji.framework.commands
{
    import flash.geom.Point;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
    import com.github.niji.framework.LayerCollection;
    import com.github.niji.framework.Painter;
    import com.github.niji.framework.vg.VGLayer;
    
    /**
     * @private
     * 
     */
    public final class BezierCurveCommand implements ICommand
    {
        public static const ID:uint = 28;
        
        public function BezierCurveCommand()
        {
            reset();
        }
        
        public function read(bytes:IDataInput):void
        {
        }
        
        public function write(bytes:IDataOutput, args:Object):void
        {
        }
        
        public function execute(painter:Painter):void
        {
            var layers:LayerCollection = painter.layers;
            var layer:VGLayer = VGLayer(layers.currentLayer);
            switch (m_type) {
                case 1: // start
                    layer.setCurrentPoint(m_x, m_y);
                    break;
                case 2: //end
                    layer.commitCurrentVGPoint(m_x, m_y);
                    break;
            }
        }
        
        public function reset():void
        {
            m_type = 0;
        }
        
        public function toString():String
        {
            return "[BezierCurveCommand]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_type:uint;
        private var m_x:Number;
        private var m_y:Number;
    }
}
