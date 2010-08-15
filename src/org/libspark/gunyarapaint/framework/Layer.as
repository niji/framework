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
package org.libspark.gunyarapaint.framework
{
    import flash.geom.ColorTransform;

    public class Layer
    {
        public function Layer()
        {
            m_colorTransform = new ColorTransform(
                1.0,
                1.0,
                1.0,
                1.0,
                0,
                0,
                0,
                0
            );
        }
        
        /**
         * @inheritDoc
         */
        public function fromJSON(data:Object):void
        {
            alpha = data.alpha;
            blendMode = data.blendMode;
            locked = data.lock == "true";
            name = data.name;
            visible = data.visible == "true";
        }
        
        /**
         * @inheritDoc
         */
        public function toJSON():Object
        {
            return {
                "alpha": alpha,
                "blendMode": blendMode,
                "lock": locked ? "true" : "false",
                    "name": name,
                    "visible": visible ? "true" : "false"
            };
        }
        
        public function setIndex(index:uint):void
        {
            m_index = index;
        }
        
        /**
         * @inheritDoc
         */
        public function get alpha():Number
        {
            return 0.0;
        }
        
        /**
         * @inheritDoc
         */
        public function get blendMode():String
        {
            return "";
        }
        /**
         * @inheritDoc
         */
        public function get index():uint
        {
            return m_index;
        }
        
        /**
         * @inheritDoc
         */
        public function get locked():Boolean
        {
            return m_locked;
        }
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return m_name;
        }
        
        /**
         * @inheritDoc
         */
        public function get visible():Boolean
        {
            return false;
        }
        
        /**
         * @inheritDoc
         */
        public function set alpha(value:Number):void
        {
            m_colorTransform.alphaMultiplier = value;
        }
        
        /**
         * @inheritDoc
         */
        public function set blendMode(value:String):void
        {
        }
        
        /**
         * @inheritDoc
         */
        public function set locked(value:Boolean):void
        {
            m_locked = value;
        }
        
        /**
         * @inheritDoc
         */
        public function set name(value:String):void
        {
            m_name = value;
        }
        
        /**
         * @inheritDoc
         */
        public function set visible(value:Boolean):void
        {
        }
        
        protected var m_colorTransform:ColorTransform;
        
        private var m_index:uint;
        
        private var m_locked:Boolean;
        
        private var m_name:String;
    }
}