package org.libspark.gunyarapaint.framework
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    
    import org.libspark.gunyarapaint.framework.errors.MergeLayersError;
    import org.libspark.gunyarapaint.framework.errors.RemoveLayerError;
    
    /**
     * 複数のレイヤーを管理する
     * 
     */
    public class LayerBitmapCollection
    {
        public function LayerBitmapCollection(width:int, height:int)
        {
            currentIndex = 0;
            doCompositeAll = true;
            m_width = width;
            m_height = height;
            layers = new Vector.<LayerBitmap>();
            spriteToView = new Sprite();
            // 白い背景を作成してレイヤー群に追加する
            var layer:LayerBitmap = new LayerBitmap(
                new BitmapData(width, height, true, uint.MAX_VALUE)
            );
            layer.name = "Background";
            composited = new BitmapData(width, height, true, 0x0);
            layers.push(layer);
            spriteToView.addChild(layer.bitmap);
        }
        
        /**
         * レイヤーを作成して追加する
         * 
         * 完全に透明なレイヤーが作成される。また、現在の番号が一つ上にずれる。
         * 
         */
        public function add():void
        {
            var layer:LayerBitmap = new LayerBitmap(
                new BitmapData(m_width, m_height, true, 0x0)
            );
            currentIndex++;
            layers.splice(currentIndex, 0, layer);
            spriteToView.addChildAt(layer.bitmap, currentIndex);
            compositeAll();
            resetLayersIndex();
        }
        
        /**
         * 指定された番号のレイヤーを取り出す
         * 
         * @param index レイヤー番号
         * @return 
         */
        public function at(index:int):LayerBitmap
        {
            return layers[index];
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
            var layer:LayerBitmap = layers[index].clone();
            layer.name += "'s copy";
            layers.splice(index, 0, layer);
            spriteToView.addChildAt(layer.bitmap, index);
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
            var layer:LayerBitmap = layers[from];
            layers[from] = layers[to];
            layers[to] = layer;
            spriteToView.swapChildrenAt(from, to);
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
                var current:LayerBitmap = layers[index];
                var prev:LayerBitmap = layers[index - 1];
                // 両方可視である必要がある
                if (current.visible && prev.visible) {
                    current.compositeTo(prev.bitmapData);
                    // 合成後の LayerBitmap は完全に不透明にしておく
                    prev.alpha = 1.0;
                    layers.splice(index, 1);
                    spriteToView.removeChildAt(index);
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
         * レイヤーが削除されると LayerBitmap は削除され、画像データにアクセス出来なくなる。
         * また、現在の番号が一つ下にずれる。
         * </p>
         * 
         * @param index 現在のレイヤー番号
         * @throws RemoveLayerError レイヤーが一つの場合
         */
        public function removeAt(index:int):void
        {
            if (layers.length <= 1)
                throw new RemoveLayerError();
            layers[index].bitmapData.dispose();
            layers.splice(index, 1);
            spriteToView.removeChildAt(index);
            if (currentIndex > 0 && index >= currentIndex)
                currentIndex -= 1;
            compositeAll();
            resetLayersIndex();
        }
        
        /**
         * 現在の全てのレイヤー情報を dataProvider に適用出来る形で返す
         * 
         * @return Array dataProvider に適用出来る配列
         */
        public function toDataProvider():Array
        {
            var ret:Array = [];
            var count:uint = layers.length;
            for (var i:uint = 0; i < count; i++) {
                ret.push(layers[i]);
            }
            return ret.reverse();
        }
        
        /**
         * 全てのレイヤーを削除する
         * 
         */
        internal function clear():void
        {
            var count:uint = layers.length;
            for (var i:uint = 0; i < count; i++) {
                var layer:LayerBitmap = layers[i];
                var bitmap:Bitmap = layer.bitmap;
                if (spriteToView.contains(bitmap))
                    spriteToView.removeChild(bitmap);
                else
                    trace(layer.name + " is not child of spriteToView.");
            }
            layers.splice(0, count);
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
                    var layer:LayerBitmap = layers[i];
                    layer.compositeTo(composited);
                }
            }
        }
        
        /**
         * 現在のレイヤー画像を設定する
         * 
         */
        internal function setCurrentLayer(value:LayerBitmap):void
        {
            layers[currentIndex] = value;
        }
        
        // LayerBitmap の name で正しい番号で作成されるように調整する
        private function resetLayersIndex():void
        {
            var c:uint = count;
            for (var i:uint = 0; i < c; i++) {
                var layer:LayerBitmap = layers[i];
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
            return layers[currentIndex];
        }
        
        /**
         * 現在のレイヤー数を返す
         * 
         */
        public function get count():uint
        {
            return layers.length;
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
        internal var spriteToView:Sprite;
        
        /**
         * 全てのレイヤーが合成された結果の画像データ
         * 
         * @default null
         */
        internal var composited:BitmapData;
        
        /**
         * レイヤーの配列
         * 
         * @default null
         */
        internal var layers:Vector.<LayerBitmap>;
        
        private var m_width:uint;
        private var m_height:uint;
    }
}
