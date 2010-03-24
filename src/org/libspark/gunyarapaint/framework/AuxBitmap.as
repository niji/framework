package org.libspark.gunyarapaint.framework
{
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.geom.Rectangle;
    
    /**
     * 補助線を描写するスプライトオブジェクト。キャンバススプライトよりも上に配置する必要がある
     * 
     * @see AuxLineView
     * @see AuxPixelBitmap
     */
    public class AuxBitmap extends Sprite
    {
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
         * 補助線を再描写するように指示する
         * 
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
         * 補助線を実際に描写する
         * 
         */
        public function divide():void
        {
            throw new IllegalOperationError();
        }
        
        /**
         * 補助線の色を取得する
         * 
         */
        public function get lineColor():uint
        {
            return m_color;
        }
        
        /**
         * 補助線の不透明度を取得する
         * 
         */
        public function get lineAlpha():Number
        {
            return m_alpha;
        }
        
        /**
         * 補助線の分割単位を取得する
         * 
         */
        public function get divideCount():uint
        {
            return m_divideCount;
        }
        
        /**
         * 補助線のうち直線が可視状態にあるかどうかを取得する
         * 
         */
        public function get boxVisible():Boolean
        {
            return m_box.visible;
        }
        
        /**
         * 補助線のうち斜線が可視状態にあるかどうかを取得する
         * 
         */
        public function get skewVisible():Boolean
        {
            return m_skew.visible;
        }
        
        /**
         * 補助線の色を設定する
         * 
         */
        public function set lineColor(value:uint):void
        {
            m_color = value;
        }
        
        /**
         * 補助線の不透明度を設定する
         * 
         */
        public function set lineAlpha(value:Number):void
        {
            m_alpha = value;
        }
        
        /**
         * 補助線の分割単位を設定する
         * 
         */
        public function set divideCount(value:uint):void
        {
            m_divideCount = value;
        }
        
        /**
         * 補助線のうち直線の可視状態を設定する
         * 
         */
        public function set boxVisible(value:Boolean):void
        {
            m_box.visible = value;
        }
        
        /**
         * 補助線のうち斜線の可視状態を設定する
         * 
         */
        public function set skewVisible(value:Boolean):void
        {
            m_skew.visible = value;
        }
        
        /**
         * @private
         * 
         */
        protected var m_rect:Rectangle;
        
        /**
         * @private
         * 
         */
        protected var m_box:Shape;
        
        /**
         * @private
         * 
         */
        protected var m_skew:Shape;
        
        /**
         * @private
         * 
         */
        protected var m_divideCount:uint;
        
        private var m_color:uint;
        private var m_alpha:Number;
    }
}
