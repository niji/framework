package org.libspark.gunyarapaint.framework
{
    public final class Version
    {
        /**
         * ログのバージョン番号
         */
        public static const LOG_VERSION:uint = 22;
        
        /**
         * ペインター自体のバージョン
         */
        public static const DATE:uint = 20100701;
        
        /**
         * ペインターのバージョン文字列
         */
        public static const DATE_STRING:String = "ver." + DATE;
        
        public static function compareDate(date:uint):int
        {
            return compareUInt(date, DATE);
        }
        
        public static function compareLogVersion(version:uint):int
        {
            return compareUInt(version, LOG_VERSION);
        }
        
        private static function compareUInt(src:uint, target:uint):int
        {
            if (src > target)
                return 1;
            else if (src < target)
                return -1;
            else
                return 0;
        }
    }
}
