package org.libspark.gunyarapaint.framework.events
{
    import flash.events.Event;

    /**
     * プレイヤー再生途中でエラーが発生したときに作られるイベントです
     */
    public final class PlayerErrorEvent extends AbstractEvent
    {
        /**
         * エラー発生時
         */
        public static const ERROR:String = prefix + "error";
        
        /**
         * @inheritDoc 
         */
        public function PlayerErrorEvent(type:String, cause:Error)
        {
            super(type, false, false);
            m_cause = cause;
        }
        
        /**
         * @inheritDoc
         */
        public override function clone():Event
        {
            return new PlayerErrorEvent(type, m_cause);
        }
        
        /**
         * 例外の原因を返します
         */
        public function get cause():Error
        {
            return m_cause;
        }
        
        public static function get prefix():String
        {
            return commonPrefix + "playerErrorEvent.";
        }
        
        private var m_cause:Error;
    }
}
