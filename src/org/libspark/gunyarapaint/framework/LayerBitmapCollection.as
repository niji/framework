package org.libspark.gunyarapaint.framework
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import org.libspark.gunyarapaint.framework.errors.AddLayerError;
    import org.libspark.gunyarapaint.framework.errors.MergeLayersError;
    import org.libspark.gunyarapaint.framework.errors.RemoveLayerError;
    import org.libspark.gunyarapaint.framework.errors.TooManyLayersError;
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;
    
    /**
     * 複数のレイヤーを管理するクラスです
     */
    public class LayerBitmapCollection implements IEventDispatcher
    {
        /**
         * 作成出来る最大レイヤー数
         */
        public static const MAX:uint = 8;
        
        /**
         * 連結したレイヤー画像で受け付ける最大ピクセル数
         */
        public static const MAX_PIXEL:uint = 2880;
        
        /**
         * 画像の幅及び高さからレイヤーの配列を生成します.
         * 
         * <p>
         * レイヤーの配列が生成されると、一番目のレイヤーに "Background" という
         * 名前の白背景のレイヤーが自動的に生成されます。
         * </p>
         * 
         * @param width 画像の幅
         * @param height 画像の高さ
         */
        public function LayerBitmapCollection(width:int, height:int)
        {
            currentIndex = 0;
            doCompositeAll = true;
            m_width = width;
            m_height = height;
            m_layers = new Vector.<LayerBitmap>();
            m_sprite = new Sprite();
            m_drawingSprite = new Sprite();
            m_drawingSprite.mouseEnabled = false;
            // 白い背景を作成してレイヤー群に追加する
            var layer:LayerBitmap = new LayerBitmap(
                new BitmapData(width, height, true, uint.MAX_VALUE)
            );
            layer.name = TranslatorRegistry.tr("Background");
            composited = new BitmapData(width, height, true, 0x0);
            m_layers.push(layer);
            m_sprite.addChild(layer.displayObject);
        }
        
        /**
         * レイヤーを作成して追加します.
         * 
         * <p>完全に透明なレイヤーが作成される。また、現在の番号が一つ上にずれます。</p>
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
            layer.name = TranslatorRegistry.tr("Layer") + currentIndex;
            m_layers.splice(currentIndex, 0, layer);
            m_sprite.addChildAt(layer.displayObject, currentIndex);
            compositeAll();
            resetIndex();
        }
        
        /**
         * 指定された番号のレイヤーを取り出します
         * 
         * @param index レイヤー番号
         * @return LayerBitmap
         */
        public function at(index:int):LayerBitmap
        {
            return m_layers[index];
        }
        
        /**
         * レイヤーをコピーして現在の番号の次に追加します
         */
        public function copy():void
        {
            copyAt(currentIndex);
        }
        
        /**
         * レイヤーをコピーして指定された番号の次に作成します.
         * 
         * <p>コピー元の画像が複製されて追加される。また、現在の番号が一つ上にずれます</p>
         * 
         * @param index　レイヤー番号
         */
        public function copyAt(index:int):void
        {
            if (m_layers.length >= MAX)
                throw new AddLayerError(MAX);
            var selected:LayerBitmap = m_layers[index];
            var layer:LayerBitmap = selected.clone();
            layer.name = TranslatorRegistry.tr("%s's copy", selected.name);
            m_layers.splice(index, 0, layer);
            m_sprite.addChildAt(layer.displayObject, index);
            compositeAll();
            resetIndex();
        }
        
        /**
         * レイヤーを指定された番号と交換します
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
            resetIndex();
        }
        
        /**
         * 現在のレイヤーを下のレイヤーと合成します
         *
         * @throws MergeLayersError レイヤーが一つ、あるいは対象のうち片方が不可視の場合
         */
        public function merge():void
        {
            mergeAt(currentIndex);
        }
        
        /**
         * 指定された番号のレイヤーを下のレイヤーと合成します.
         * 
         * <p>
         * 両方のレイヤーは可視 (visible=true) である必要があります。
         * また、合成後は現在のレイヤーは下のレイヤーに変更され、完全に不透明になります
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
                    resetIndex();
                    return;
                }
            }
            throw new MergeLayersError();
        }
        
        /**
         * 現在のレイヤーを削除します
         * 
         * @throws RemoveLayerError レイヤーが一つの場合
         */
        public function remove():void
        {
            removeAt(currentIndex);
        }
        
        /**
         * 指定された番号のレイヤーを削除します.
         * 
         * <p>レイヤーが削除されると 現在の番号が一つ下にずれます。</p>
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
            resetIndex();
        }
        
        /**
         * 表示オブジェクトから現在のビューを削除します
         *
         * @param parent 親となる表示オブジェクト
         */
        public function removeView(parent:Sprite):void
        {
            parent.removeChild(m_sprite);
        }
        
        /**
         * 現在のビューを表示オブジェクトに設定します
         *
         * @param parent 親となる表示オブジェクト
         */
        public function setView(parent:Sprite):void
        {
            parent.addChild(m_sprite);
        }
        
        /**
         * 現在の全てのレイヤー情報を dataProvider に適用出来る形で返します
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
        
        /**
         * 連結されたレイヤー画像とメタデータから復元します
         *
         * @param layerBitmaps 縦に連結されたレイヤー画像
         * @param metadata メタデータ
         * @see LayerBitmapCollection#newLayerBitmapData
         */
        public function load(layerBitmap:BitmapData, metadata:Object):void
        {
            var i:uint = 0;
            var width:uint = metadata.width;
            var height:uint = metadata.height;
            var layersInfo:Array = metadata.layer_infos;
            var layerCount:uint = layerBitmap.height / height;
            var destination:Point = new Point(0, 0);
            var rectangle:Rectangle = new Rectangle(0, 0, width, height);
            // 古いバージョンだとメタデータが存在しないので空データを作る
            if (!layersInfo) {
                layersInfo = [];
                for (i = 0; i < layerCount; i++) {
                    // レイヤー名は各レイヤー毎に異なるため、毎回コピーを作成する
                    var data:Object = at(0).toJSON();
                    if (i > 0)
                        data.name = TranslatorRegistry.tr("Layer") + i;
                    layersInfo.push(data);
                }
            }
            // 現在保管しているレイヤーを全て消去する
            clear();
            for (i = 0; i < layerCount; i++) {
                // レイヤー画像は縦につながっているので、切り出しを行う
                var bitmapData:BitmapData = new BitmapData(width, height);
                rectangle.y = i * height;
                bitmapData.copyPixels(layerBitmap, rectangle, destination);
                var layer:LayerBitmap = new LayerBitmap(bitmapData);
                layer.fromJSON(layersInfo[i]);
                m_layers.push(layer);
                m_sprite.addChild(layer.displayObject);
            }
            resetIndex();
        }
        
        /**
         * 連結されたレイヤー画像とメタデータを保存します
         * 
         * @param layerBitmaps 縦に連結されたレイヤー画像
         * @param metadata メタデータ
         * @see LayerBitmapCollection#newLayerBitmapData
         */
        public function save(layerBitmap:BitmapData, metadata:Object):void
        {
            // まずはレイヤー画像が規定以内かどうかを確認する
            if (layerBitmap.height > MAX_PIXEL) {
                var count:uint = Math.min(Math.floor((1.0 * MAX_PIXEL) / height), MAX);
                throw new TooManyLayersError(count);
            }
            var layersInfo:Array = [];
            var layerCount:uint = layerBitmap.height / height;
            var rectangle:Rectangle = new Rectangle(0, 0, width, height);
            var destination:Point = new Point(0, 0);
            // レイヤー画像を描写するので、ここでロックを掛ける
            layerBitmap.lock();
            for (var i:uint = 0; i < layerCount; i++) {
                var layer:LayerBitmap = m_layers[i];
                destination.y = i * height;
                // 描写を行い、下の方向に縦のピクセル分ずらすことを繰り返す
                layerBitmap.copyPixels(layer.bitmapData, rectangle, destination);
                layersInfo.push(layer.toJSON());
            }
            layerBitmap.unlock();
            metadata.width = width;
            metadata.height = height;
            metadata.layer_infos = layersInfo;
        }
        
        /**
         * 現在のレイヤー配列にあるレイヤーのインデックスを更新します
         */
        public function resetIndex():void
        {
            var c:uint = count;
            for (var i:uint = 0; i < c; i++) {
                var layer:LayerBitmap = m_layers[i];
                layer.setIndex(i);
            }
        }
        
        /**
         * @copy flash.events.IEventDispatcher#addEventListener()
         */
        public function addEventListener(type:String,
                                         listener:Function,
                                         useCapture:Boolean = false,
                                         priority:int = 0,
                                         useWeakReference:Boolean = false):void
        {
            m_sprite.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        
        /**
         * @copy flash.events.IEventDispatcher#removeEventListener()
         */
        public function removeEventListener(type:String,
                                            listener:Function,
                                            useCapture:Boolean = false):void
        {
            m_sprite.removeEventListener(type, listener, useCapture);
        }
        
        /**
         * @copy flash.events.IEventDispatcher#dispatchEvent()
         */
        public function dispatchEvent(event:Event):Boolean
        {
            return m_sprite.dispatchEvent(event);
        }
        
        /**
         * @copy flash.events.IEventDispatcher#hasEventListener()
         */
        public function hasEventListener(type:String):Boolean
        {
            return m_sprite.hasEventListener(type);
        }
        
        /**
         * @copy flash.events.IEventDispatcher#willTrigger()
         */
        public function willTrigger(type:String):Boolean
        {
            return m_sprite.willTrigger(type);
        }
        
        /**
         * 全てのレイヤーを削除します
         */
        internal function clear():void
        {
            var count:uint = m_layers.length;
            for (var i:uint = 0; i < count; i++) {
                var layer:LayerBitmap = m_layers[i];
                // ここから例外を送出することは不具合が無ければないと考えられる
                m_sprite.removeChild(layer.displayObject);
            }
            m_layers.splice(0, count);
        }
        
        /**
         * 全てのレイヤーの画像を合成します
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
         * saveState で保存したオブジェクトを復元します
         *
         * @param undoData saveStateで保存したオブジェクト
         * @see #saveState
         */
        internal function loadState(undoData:Object):void
        {
            var layers:Vector.<Object> = undoData.layers;
            var count:uint = layers.length;
            clear();
            for (var i:uint = 0; i < count; i++) {
                var data:Object = layers[i];
                var newLayer:LayerBitmap = new LayerBitmap(data.bitmapData);
                newLayer.fromJSON(data);
                m_sprite.addChild(newLayer.displayObject);
                m_layers.push(newLayer);
            }
            currentIndex = undoData.index;
            compositeAll();
        }
        
        /**
         * 画像データを含むすべてのレイヤー情報を保存します
         *
         * @param undoData 保存先となる空のオブジェクト
         * @see #loadState
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
        
        internal function startDrawing(engine:PaintEngine):void
        {
            // 裏うつりしないレイヤーは今ないよね？
            if (m_tempLayer == null) {
                var layer:LayerBitmap = currentLayer;
                var blendMode:String = layer.blendMode;
                // ペンの状態は必ずリセットします
                engine.resetPen();
                m_drawingSprite.blendMode =
                    blendMode == BlendMode.NORMAL ? BlendMode.LAYER : blendMode;
                m_drawingSprite.alpha = layer.alpha;
                // 裏うつりしない描写用のレイヤーを敷く
                m_tempLayer = currentLayer.newDisplayObject;
                m_tempLayer.blendMode = BlendMode.NORMAL;
                m_tempLayer.alpha = 1.0;
                // 下に先程のレイヤーが、上に描いた内容が入った表示オブジェクトを作成する
                m_drawingSprite.addChild(m_tempLayer);
                m_drawingSprite.addChild(engine.shape);
                // 現在のレイヤーと先程の表示オブジェクトを入れ替える
                m_sprite.removeChild(layer.displayObject);
                m_sprite.addChildAt(m_drawingSprite, currentIndex);
            }
        }
        
        internal function stopDrawing(engine:PaintEngine):void
        {
            // 裏うつりしないレイヤーは今あるよね？
            if (m_tempLayer != null) {
                var layer:LayerBitmap = currentLayer;
                var blendMode:String = m_drawingSprite.blendMode;
                layer.blendMode =
                    blendMode == BlendMode.LAYER ? BlendMode.NORMAL : blendMode;
                layer.alpha = m_drawingSprite.alpha;
                // 現在のレイヤーと startDrawing で作成した表示オブジェクトを入れ替える
                m_sprite.removeChild(m_drawingSprite);
                m_sprite.addChildAt(layer.displayObject, currentIndex);
                // 描いた内容を消去してリセットする
                engine.clear();
                // 裏うつりしないレイヤーと描いた内容を表示オブジェクトから外す
                m_drawingSprite.removeChild(m_tempLayer);
                m_drawingSprite.removeChild(engine.shape);
                // 裏うつりしないレイヤーを開放
                m_tempLayer = null;
            }
        }
        
        /**
         * 現在のレイヤー画像を設定します
         */
        internal function setCurrentLayer(value:LayerBitmap):void
        {
            m_layers[currentIndex] = value;
        }
        
        /**
         * 現在のレイヤー画像の幅を返します
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
         * 現在のレイヤー画像を返します
         */
        public function get currentLayer():LayerBitmap
        {
            return m_layers[currentIndex];
        }
        
        /**
         * 現在のレイヤー数を返します
         */
        public function get count():uint
        {
            return m_layers.length;
        }
        
        /**
         * 全てのレイヤーを結合した結果の BitmapData のコピーを返します
         */
        public function get compositedBitmapData():BitmapData
        {
            return composited.clone();
        }
        
        /**
         * レイヤーを保存するために必要な BitmapData を生成します
         * 
         * @see #load()
         * @see #save()
         */
        public function get newLayerBitmapData():BitmapData
        {
            // レイヤーの数の分だけ縦につながった空白の画像が作成されます
            return new BitmapData(width, height * count, true, 0x0);
        }
        
        /**
         * スプライトオブジェクトを返します
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
         * 全てのレイヤーが合成された結果の画像データです
         * 
         * @default null
         */
        internal var composited:BitmapData;
        
        private var m_sprite:Sprite;
        private var m_layers:Vector.<LayerBitmap>;
        private var m_drawingSprite:Sprite;
        private var m_tempLayer:DisplayObject;
        private var m_width:uint;
        private var m_height:uint;
    }
}
