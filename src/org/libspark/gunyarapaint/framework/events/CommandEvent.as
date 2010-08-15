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
package org.libspark.gunyarapaint.framework.events
{
    import flash.events.Event;
    
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * コマンド関連のイベントです
     */
    public final class CommandEvent extends AbstractEvent
    {
        /**
         * 先読みでログから対応するコマンドオブジェクトが取得出来た後
         */
        public static const PREPARSE:String = prefix + "preparse";
        
        /**
         * ログから対応するコマンドオブジェクトが取得出来た後
         */
        public static const PARSE:String = prefix + "parse";
        
        /**
         * コマンド登録後
         */
        public static const REGISTERED:String = prefix + "registered";
        
        /**
         * コマンド解除後
         */
        public static const UNREGISTERED:String = prefix + "unregistered";
        
        /**
         * コマンドが書き込まれ、実行した後
         */
        public static const COMMITTED:String = prefix + "committed";
        
        /**
         * @inheritDoc 
         */
        public function CommandEvent(type:String, command:ICommand)
        {
            super(type, false, false);
            m_command = command;
        }
        
        /**
         * @inheritDoc
         */
        public override function clone():Event
        {
            return new CommandEvent(type, m_command);
        }
        
        /**
         * コマンドオブジェクトを返します
         */
        public function get command():ICommand
        {
            return m_command;
        }
        
        public static function get prefix():String
        {
            return commonPrefix + "commandEvent.";
        }
        
        private var m_command:ICommand;
    }
}
