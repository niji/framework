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
/// @cond
package com.github.niji.framework.aux
{
/// @endcond
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.geom.Rectangle;
    
    /**
     * 補助線を描写するスプライトを継承したクラスです.
     * 
     * <p>
     * キャンバススプライトよりも上に配置する必要があります。
     * また、抽象クラスなので、直接インスタンスを生成してはいけません。
     * </p>
     * 
     * @see AuxLineView
     * @see AuxPixelView
     */
    public class AuxBitmap extends Sprite
    {
        /**
         * @private
         */
        public function AuxBitmap(rect:Rectangle)
        {
            m_rect = rect;
            m_color = 0;
            m_alpha = 1;
            m_divideCount = 4;
            m_box = new Shape();
            m_skew = new Shape();
            m_box.visible = false;
            m_skew.visible = false;
            update();
            mouseEnabled = false;
            addChild(m_box);
            addChild(m_skew);
        }
        
        /**
         * 補助線を再描写するように指示します
         */
        public function update():void
        {
            var box:Graphics = m_box.graphics;
            var skew:Graphics = m_skew.graphics;
            box.clear();
            skew.clear();
            box.lineStyle(0, m_color, m_alpha);
            skew.lineStyle(0, m_color, m_alpha);
            box.drawRect(0, 0, width, height);
            divide();
        }
        
        /**
         * 補助線を実際に描写します
         */
        public function divide():void
        {
            throw new IllegalOperationError();
        }
        
        /**
         * 補助線の色を取得します
         */
        public function get lineColor():uint
        {
            return m_color;
        }
        
        /**
         * 補助線の不透明度を取得します
         */
        public function get lineAlpha():Number
        {
            return m_alpha;
        }
        
        /**
         * 補助線の分割単位を取得します
         */
        public function get divideCount():uint
        {
            return m_divideCount;
        }
        
        /**
         * 補助線のうち直線が可視状態にあるかどうかを取得します
         */
        public function get boxVisible():Boolean
        {
            return m_box.visible;
        }
        
        /**
         * 補助線のうち斜線が可視状態にあるかどうかを取得します
         */
        public function get skewVisible():Boolean
        {
            return m_skew.visible;
        }
        
        /**
         * 補助線の色を設定します
         */
        public function set lineColor(value:uint):void
        {
            m_color = value;
        }
        
        /**
         * 補助線の不透明度を設定します
         */
        public function set lineAlpha(value:Number):void
        {
            m_alpha = value;
        }
        
        /**
         * 補助線の分割単位を設定します
         */
        public function set divideCount(value:uint):void
        {
            m_divideCount = value;
        }
        
        /**
         * 補助線のうち直線の可視状態を設定します
         */
        public function set boxVisible(value:Boolean):void
        {
            m_box.visible = value;
        }
        
        /**
         * 補助線のうち斜線の可視状態を設定します
         */
        public function set skewVisible(value:Boolean):void
        {
            m_skew.visible = value;
        }
        
        /**
         * @private
         */
        protected var m_rect:Rectangle;
        
        /**
         * @private
         */
        protected var m_box:Shape;
        
        /**
         * @private
         */
        protected var m_skew:Shape;
        
        /**
         * @private
         */
        protected var m_divideCount:uint;
        
        private var m_color:uint;
        private var m_alpha:Number;
    }
}
