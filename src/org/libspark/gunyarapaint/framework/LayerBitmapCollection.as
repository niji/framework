package org.libspark.gunyarapaint.framework
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import org.libspark.gunyarapaint.framework.errors.AddLayerError;
    import org.libspark.gunyarapaint.framework.errors.MergeLayersError;
    import org.libspark.gunyarapaint.framework.errors.RemoveLayerError;
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;
    
    /**
     * 複数のレイヤーを管理する
     * 
     */
    public class LayerBitmapCollection implements IEventDispatcher
    {
        /**
         * 作成出来る最大レイヤー数
         */
        public static const MAX:uint = 8;
        
        public function LayerBitmapCollection(width:int, height:int)
        {
            currentIndex = 0;
            doCompositeAll = true;
            m_width = width;
            m_height = height;
            m_layers = new Vector.<LayerBitmap>();
            m_sprite = new Sprite();
            // 白い背景を作成してレイヤー群に追加する
            var layer:LayerBitmap = new LayerBitmap(
                new BitmapData(width, height, true, uint.MAX_VALUE)
            );
            layer.name = TranslatorRegistry.tr("Background");
            composited = new BitmapData(width, height, true, 0x0);
            addLayer(layer);
        }
        
        /**
         * レイヤーを作成して追加する
         * 
         * 完全に透明なレイヤーが作成される。また、現在の番号が一つ上にずれる。
         * 
         */
        public function add():void
        {
            if (m_layers.length >= MAX)
                throw new AddLayerError(MAX);
            var layer:LayerBitmap = new LayerBitmap(
                new BitmapData(m_width, m_height, true, 0x0)
            );
            currentIndex++;
            m_layers.splice(currentIndex, 0, layer);
            m_sprite.addChildAt(layer.displayObject, currentIndex);
            compositeAll();
            resetLayersIndex();
        }
        
        /**
         * レイヤーオブジェクトを追加する
         * 
         * @param layer レイヤーオブジェクト
         */
        public function addLayer(layer:LayerBitmap):void
        {
            if (m_layers.length >= MAX)
                throw new AddLayerError(MAX);
            m_layers.push(layer);
            m_sprite.addChild(layer.displayObject);
        }
        
        /**
         * 指定された番号のレイヤーを取り出す
         * 
         * @param index レイヤー番号
         * @return 
         */
        public function at(index:int):LayerBitmap
        {
            return m_layers[index];
        }
        
        /**
         * レイヤーをコピーして現在の番号の次に追加する
         * 
         */
        public function copy():void
        {
            copyAt(currentIndex);
        }
        
        /**
         * レイヤーをコピーして指定された番号の次に作成する
         * 
         * コピー元の画像が複製されて追加される。また、現在の番号が一つ上にずれる。
         * 
         * @param index　レイヤー番号
         */
        public function copyAt(index:int):void
        {
            if (m_layers.length >= MAX)
                throw new AddLayerError(MAX);
            var layer:LayerBitmap = m_layers[index].clone();
            layer.name += "'s copy";
            m_layers.splice(index, 0, layer);
            m_sprite.addChildAt(layer.displayObject, index);
            compositeAll();
            resetLayersIndex();
        }
        
        /**
         * レイヤーを指定された番号と交換する
         * 
         * @param from 入れ替え元のレイヤー番号
         * @param to 入れ替え先のレイヤー番号
         */
        public function swap(from:int, to:int):void
        {
            var layer:LayerBitmap = m_layers[from];
            m_layers[from] = m_layers[to];
            m_layers[to] = layer;
            m_sprite.swapChildrenAt(from, to);
            compositeAll();
            resetLayersIndex();
        }
        
        /**
         * 現在のレイヤーを下のレイヤーと合成する 
         * 
         * @throws MergeLayersError レイヤーが一つ、あるいは対象のうち片方が不可視の場合
         */
        public function merge():void
        {
            mergeAt(currentIndex);
        }
        
        /**
         * 指定された番号のレイヤーを下のレイヤーと合成する
         * 
         * <p>
         * 両方のレイヤーは可視 (visible=true) である必要がある。
         * また、合成後は現在のレイヤーは下のレイヤーに変更され、完全に不透明になる。
         * </p>
         * 
         * @param index レイヤー番号
         * @throws MergeLayersError レイヤーが一つ、あるいは対象のうち片方が不可視の場合
         */
        public function mergeAt(index:int):void
        {
            // レイヤーは必ず2つ以上
            if (currentIndex > 0) {
                var current:LayerBitmap = m_layers[index];
                var prev:LayerBitmap = m_layers[index - 1];
                // 両方可視である必要がある
                if (current.visible && prev.visible) {
                    current.compositeTo(prev.bitmapData);
                    // 合成後の LayerBitmap は完全に不透明にしておく
                    prev.alpha = 1.0;
                    m_layers.splice(index, 1);
                    m_sprite.removeChildAt(index);
                    if (index >= currentIndex)
                        currentIndex -= 1;
                    compositeAll();
                    resetLayersIndex();
                    return;
                }
            }
            throw new MergeLayersError();
        }
        
        /**
         * 現在のレイヤーを削除する
         * 
         * @throws RemoveLayerError レイヤーが一つの場合
         */
        public function remove():void
        {
            removeAt(currentIndex);
        }
        
        /**
         * 指定された番号のレイヤーを削除する
         * 
         * <p>
         * レイヤーが削除されると 現在の番号が一つ下にずれる。
         * </p>
         * 
         * @param index 現在のレイヤー番号
         * @throws RemoveLayerError レイヤーが一つの場合
         */
        public function removeAt(index:int):void
        {
            if (m_layers.length <= 1)
                throw new RemoveLayerError();
            m_layers.splice(index, 1);
            m_sprite.removeChildAt(index);
            if (currentIndex > 0 && index >= currentIndex)
                currentIndex -= 1;
            compositeAll();
            resetLayersIndex();
        }
        
        /**
         * 表示オブジェクトから現在のビューを削除する
         *
         * @param parent 親となる表示オブジェクト
         */
        public function removeView(parent:Sprite):void
        {
            parent.removeChild(m_sprite);
        }
        
        /**
         * 現在のビューを表示オブジェクトに設定する
         *
         * @param parent 親となる表示オブジェクト
         */
        public function setView(parent:Sprite):void
        {
            parent.addChild(m_sprite);
        }
        
        /**
         * 現在の全てのレイヤー情報を dataProvider に適用出来る形で返す
         * 
         * @return Array dataProvider に適用出来る配列
         */
        public function toDataProvider():Array
        {
            var ret:Array = [];
            var count:uint = m_layers.length;
            for (var i:uint = 0; i < count; i++) {
                ret.push(m_layers[i]);
            }
            return ret.reverse();
        }
        
        public function addEventListener(type:String,
                                         listener:Function,
                                         useCapture:Boolean = false,
                                         priority:int = 0,
                                         useWeakReference:Boolean = false):void
        {
            m_sprite.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        
        public function removeEventListener(type:String,
                                            listener:Function,
                                            useCapture:Boolean = false):void
        {
            m_sprite.removeEventListener(type, listener, useCapture);
        }
        
        public function dispatchEvent(event:Event):Boolean
        {
            return m_sprite.dispatchEvent(event);
        }
        
        public function hasEventListener(type:String):Boolean
        {
            return m_sprite.hasEventListener(type);
        }
        
        public function willTrigger(type:String):Boolean
        {
            return m_sprite.willTrigger(type);
        }
        
        /**
         * 全てのレイヤーを削除する
         * 
         */
        internal function clear():void
        {
            var count:uint = m_layers.length;
            for (var i:uint = 0; i < count; i++) {
                m_sprite.removeChildAt(i);
            }
            m_layers.splice(0, count);
        }
        
        /**
         * 全てのレイヤーの画像を合成する
         * 
         */
        internal function compositeAll():void
        {
            if (doCompositeAll) {
                var c:uint = count;
                // 操作毎にBitmapDataが生成されるため、逆にGarbageCollectionを発生させやすくしている。
                // そのため、これがないとBitmapDataによるメモリリークが余計にひどくなる。
                composited = new BitmapData(m_width, m_height, true, 0x0);
                for (var i:uint = 0; i < c; i++) {
                    var layer:LayerBitmap = m_layers[i];
                    layer.compositeTo(composited);
                }
            }
        }
        
        /**
         * saveState で保存したオブジェクトを復元する
         *
         */
        internal function loadState(undoData:Object):void
        {
            var i:uint = 0;
            var layers:Vector.<Object> = undoData.layers;
            var oldLayerCount:uint = m_layers.length;
            var newLayerCount:uint = layers.length;
            // レイヤー切り替えが発生しないケースの対処
            // 古いレイヤーが一緒に消えないようにする必要がある
            var c:uint = newLayerCount > oldLayerCount ? oldLayerCount : newLayerCount;
            for (i = 0; i < c; i++) {
                var data:Object = layers[i];
                var newLayer:LayerBitmap = new LayerBitmap(data.bitmapData);
                newLayer.fromJSON(data);
                m_sprite.removeChildAt(i);
                m_sprite.addChildAt(newLayer.displayObject, i);
                m_layers[i] = newLayer;
            }
            currentIndex = undoData.index;
            compositeAll();
        }
        
        /**
         * 画像データを含むすべてのレイヤー情報を保存する
         *
         */
        internal function saveState(undoData:Object):void
        {
            var c:uint = count;
            var layers:Vector.<Object> = new Vector.<Object>(c, true);
            for (var i:uint = 0; i < c; i++) {
                var layer:LayerBitmap = m_layers[i];
                var data:Object = layer.toJSON();
                data.bitmapData = layer.bitmapData;
                layers[i] = data;
            }
            undoData.index = currentIndex;
            undoData.layers = layers;
        }
        
        /**
         * 現在のビューに対して表示オブジェクトの入れ替えを行う
         *
         */
        internal function swapChild(from:DisplayObject, to:DisplayObject):void
        {
            m_sprite.removeChild(from);
            m_sprite.addChildAt(to, currentIndex);
        }
        
        /**
         * 現在のレイヤー画像を設定する
         * 
         */
        internal function setCurrentLayer(value:LayerBitmap):void
        {
            m_layers[currentIndex] = value;
        }
        
        // LayerBitmap の name で正しい番号で作成されるように調整する
        private function resetLayersIndex():void
        {
            var c:uint = count;
            for (var i:uint = 0; i < c; i++) {
                var layer:LayerBitmap = m_layers[i];
                layer.index = i;
            }
        }
        
        /**
         * 現在のレイヤー画像の幅を返す
         * 
         */
        public function get width():uint
        {
            return m_width;
        }
        
        /**
         * 現在のレイヤー画像の高さを返す
         * 
         */
        public function get height():uint
        {
            return m_height;
        }
        
        /**
         * 現在のレイヤー画像を返す
         * 
         */
        public function get currentLayer():LayerBitmap
        {
            return m_layers[currentIndex];
        }
        
        /**
         * 現在のレイヤー数を返す
         * 
         */
        public function get count():uint
        {
            return m_layers.length;
        }
        
        /**
         * 全てのレイヤーを結合した結果の BitmapData のコピーを返す
         * 
         */
        public function get compositedBitmapData():BitmapData
        {
            return composited.clone();
        }
        
        /**
         * スプライトオブジェクトを返す
         * 
         */
        internal function get view():Sprite
        {
            return m_sprite;
        }
        
        /**
         * 現在のレイヤー番号
         * 
         * @default 0
         */
        public var currentIndex:uint;
        
        /**
         * 全てのレイヤーを合成するかどうか
         * 
         * @default false
         */
        public var doCompositeAll:Boolean;
        
        /**
         * キャンバス用のスプライトオブジェクト
         * 
         * @default null
         */
        private var m_sprite:Sprite;
        
        /**
         * 全てのレイヤーが合成された結果の画像データ
         * 
         * @default null
         */
        internal var composited:BitmapData;
        
        private var m_layers:Vector.<LayerBitmap>;
        private var m_width:uint;
        private var m_height:uint;
    }
}
