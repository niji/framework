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
package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;

	/**
	 * ICanvasModule を管理するクラスです
	 */	
    public final class CanvasModuleContext
    {
        /**
         * はじめから使用可能なモジュールを予め登録し、Recorder を紐付けた状態で生成します
         * 
         * @param recorder Recorder オブジェクト
         */
        public function CanvasModuleContext(recorder:Recorder)
        {
            m_modules = {};
            registerModule(new CircleModule(recorder));
            registerModule(new DropperModule(recorder));
            registerModule(new EllipseModule(recorder));
            registerModule(new FloodFillModule(recorder));
            registerModule(new FreeHandModule(recorder));
            registerModule(new LineModule(recorder));
            registerModule(new PixelModule(recorder));
            registerModule(new RectModule(recorder));
            registerModule(new RoundRectModule(recorder));
            registerModule(new TransparentFloodFill(recorder));
            registerModule(new TransparentLineModule(recorder));
        }
        
		/**
		 * ICanvasModule を登録して利用出来るようにします
		 * 
		 * @param module ICanvasModule を実装したクラス
		 */		
        public function registerModule(module:ICanvasModule):void
        {
            m_modules[module.name] = module;
        }
        
		/**
		 * name に対応するモジュールID から ICanvasModule を実装したクラスを返します
		 * 
		 * @param name モジュールID
		 * @return ICanvasModule を実装したクラス
         * @see ICanvasModule#name
		 */		
        public function getModule(name:String):ICanvasModule
        {
            return m_modules[name];
        }
        
        private var m_modules:Object;
    }
}
