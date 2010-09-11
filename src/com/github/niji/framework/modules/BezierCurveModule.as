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
package com.github.niji.framework.modules
{
    import com.github.niji.framework.Recorder;
    import com.github.niji.framework.vg.VGLayer;
    
    public final class BezierCurveModule extends CanvasModule implements ICanvasModule
    {
        public static const BEZIER_CURVE:String = PREFIX + "bezierCurve";
        
        public function BezierCurveModule(recorder:Recorder)
        {
            super(recorder);
            m_hit = false;
        }
        
        public function start(x:Number, y:Number):void
        {
            var layer:VGLayer = VGLayer(m_recorder.layers.currentLayer);
            validateLayerState();
            setCoordinate(x, y);
            m_recorder.startDrawing();
            if (layer.hitTest(x, y)) {
                m_hit = true;
            }
            else {
                layer.setCurrentPoint(x, y);
            }
        }
        
        public function move(x:Number, y:Number):void
        {
            var layer:VGLayer = VGLayer(m_recorder.layers.currentLayer);
            if (m_hit) {
                layer.updateVGPoint(x, y);
            }
            else {
                m_recorder.paintEngine.drawVGPreview(layer);
            }
        }
        
        public function stop(x:Number, y:Number):void
        {
            var layer:VGLayer = VGLayer(m_recorder.layers.currentLayer);
            if (m_hit) {
                m_hit = false;
            }
            else {
                layer.commitCurrentVGPoint(x, y);
            }
            m_recorder.stopDrawing();
            m_recorder.paintEngine.drawVG(layer);
            if (layer.closed) {
                m_recorder.paintEngine.drawVGAuxPoints(layer);
            }
            else {
                layer.createShape();
            }
            saveCoordinate(x, y);
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            stop(x, y);
        }
        
        public function get name():String
        {
            return BEZIER_CURVE;
        }
        
        private var m_hit:Boolean;
    }
}
