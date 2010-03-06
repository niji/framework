package org.libspark.gunyarapaint.framework
{
    import flash.display.Shape;
    import flash.events.EventDispatcher;
    
    import org.libspark.gunyarapaint.framework.errors.NotSupportedVersionError;
    import org.libspark.gunyarapaint.framework.events.UndoEvent;
    
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
            if (hasEventListener(UndoEvent.UNDO))
                dispatchEvent(new UndoEvent(UndoEvent.UNDO, m_undo.undoCount, m_undo.redoCount));
        }
        
        /**
         * お絵描き操作のやり直しを実行する
         */
        public function redo():void
        {
            m_undo.redo(m_painter);
            if (hasEventListener(UndoEvent.REDO))
                dispatchEvent(new UndoEvent(UndoEvent.REDO, m_undo.undoCount, m_undo.redoCount));
        }
        
        /**
         * 現在のお絵描き操作をアンドゥログを追加する
         */
        public function pushUndo():void
        {
            m_undo.push(m_painter);
            if (hasEventListener(UndoEvent.PUSH))
                dispatchEvent(new UndoEvent(UndoEvent.PUSH, m_undo.undoCount, m_undo.redoCount));
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
                pushUndo();
        }
        
        /**
         * Painter オブジェクトを作成する
         * 
         * @param width 画像の幅
         * @param height 画像の高さ
         * @param version ペイントログのバージョン
         */
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
            m_width = width;
            m_height = height;
            m_version = version;
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
        
        /**
         * UndoStack オブジェクトを設定する
         * 
         * @return ログのバージョン
         */
        internal function setUndo(value:UndoStack):void
        {
            m_undo = value;
        }
        
        private var m_version:uint;
        private var m_painter:Painter;
        private var m_undo:UndoStack;
        private var m_width:uint;
        private var m_height:uint;
    }
}
