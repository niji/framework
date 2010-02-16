package org.libspark.gunyarapaint
{
    import flash.display.Shape;
    import flash.events.EventDispatcher;
    
    import org.libspark.gunyarapaint.errors.NotSupportedVersionError;
    
    public class CanvasContext extends EventDispatcher
    {
        public static const PAINTER_LOG_VERSION:uint = 10;
        
        public static const PAINTER_VERSION_STRING:String = "ver.20091205";
        
        public function CanvasContext()
        {
            super(null);
            m_version = PAINTER_LOG_VERSION;
        }
        
        /**
         * お絵描き操作の巻き戻しを実行する
         */
        public function undo():void
        {
            m_undo.undo(m_painter);
        }
        
        /**
         * お絵描き操作のやり直しを実行する
         */
        public function redo():void
        {
            m_undo.redo(m_painter);
        }
        
        /**
         * 現在のお絵描き操作をアンドゥログを追加する
         */
        public function pushUndo():void
        {
            m_undo.push(m_painter);
        }
        
        /**
         * 必要であれば現在のお絵描き操作をアンドゥログに追加する
         * 
         * これはレイヤー操作もアンドゥログに含まれていた為、ログのバージョンが古いか、
         * レイヤー操作もアンドゥに含めてもいい選択が入っている場合にアンドゥログに追加する
         */
        public function pushUndoIfNeed():void
        {
            if (m_version <= 21)
                m_undo.push(m_painter);
        }
        
        protected function createPainter(width:int, height:int, version:uint):void
        {
            var engine:PaintEngine = new PaintEngine(new Shape());
            if (version > 0 && version <= 10) {
                m_painter = new PainterV1(width, height, engine);
            }
            else if (version > 10 && version <= 21) {
                m_painter = new PainterV2(width, height, engine);
            }
            else {
                throw new NotSupportedVersionError(version.toString());
            }
        }
        
        /**
         * お絵描きを実行するオブジェクトを返す
         * 
         * @return お絵描きを実行するオブジェクト
         */
        public function get painter():Painter
        {
            return m_painter;
        }
        
        /**
         * 現在のお絵描きログのバージョンを返す
         * 
         * @return ログのバージョン
         */
        public function get version():uint
        {
            return m_version;
        }
        
        /**
         * 描写するキャンバスの幅を返す
         * 
         * @return 画像の幅
         */
        public function get width():uint
        {
            return m_width;
        }
        
        /**
         * 描写するキャンバスの高さを返す
         * 
         * @return 画像の高さ
         */
        public function get height():uint
        {
            return m_height;
        }
        
        protected var m_version:uint;
        protected var m_painter:Painter;
        protected var m_undo:UndoStack;
        protected var m_width:uint;
        protected var m_height:uint;
    }
}
