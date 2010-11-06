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
package com.github.niji.framework.events
{
/// @endcond
    import flash.events.Event;

    /**
     * @private
     */
    public final class PenEvent extends AbstractEvent
    {
        /**
         * 太さが変更された
         */
        public static const THICKNESS:String = prefix + "thickness";
        
        /**
         * 色が変更された
         */
        public static const COLOR:String = prefix + "color";
        
        /**
         * 不透明度が変更された
         */
        public static const ALPHA:String = prefix + "alpha";
        
        /**
         * ブレンドモードが変更された
         */
        public static const BLEND_MODE:String = prefix + "blendMode";
        
        /**
         * スケールモードが変更された
         */
        public static const SCALE_MODE:String = prefix + "scaleMode";
        
        /**
         * キャップモードが変更された
         */
        public static const CAPS_STYLE:String = prefix + "capsStyle";
        
        /**
         * ジョイントモードが変更された
         */
        public static const JOINT_STYLE:String = prefix + "jointStyle";
        
        /**
         * マイター値が変更された
         */
        public static const MITER_LIMIT:String = prefix + "miterLimit";
        
        /**
         * ピクセルヒンティングが変更された
         */
        public static const PIXEL_HINTING:String = prefix + "pixelHinting";
        
        /**
         * @private
         */
        public static const BITMAP:String = prefix + "bitmap";
        
        /**
         * @private
         */
        public static const MATRIX:String = prefix + "matrix";
        
        /**
         * @inheritDoc 
         */
        public function PenEvent(type:String)
        {
            super(type, false, false);
        }
        
        /**
         * @inheritDoc
         */
        public override function clone():Event
        {
            return new PenEvent(type);
        }
        
        public static function get prefix():String
        {
            return commonPrefix + "penEvent.";
        }
    }
}
