package org.libspark.gunyarapaint
{
    import flash.display.BitmapData;
    import flash.display.Sprite;
    
    import org.libspark.gunyarapaint.errors.MergeLayersError;

    public class LayerBitmapCollection
    {
        public function LayerBitmapCollection(width:int, height:int)
        {
            currentIndex = 0;
            doCompositeAll = false;
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
            spriteToView.addChild(layer);
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
            spriteToView.addChildAt(layer, currentIndex);
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
            spriteToView.addChildAt(layer, index);
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
         */
        public function merge():void
        {
            mergeAt(currentIndex);
        }
        
        /**
         * 指定された番号のレイヤーを下のレイヤーと合成する
         * 
         * 両方のレイヤーは可視 (visible=true) である必要がある。
         * どちらか不可視だと MergeLayersError を送出する。
         * また、合成後は現在のレイヤーは下のレイヤーに変更され、完全に不透明になる。
         * 
         * @param index レイヤー番号
         */
        public function mergeAt(index:int):void
        {
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
            }
            else {
                throw new MergeLayersError();
            }
        }
        
        /**
         * 現在のレイヤーを削除する
         * 
         */
        public function remove():void
        {
            removeAt(currentIndex);
        }
        
        /**
         * 指定された番号のレイヤーを削除する
         * 
         * レイヤーが削除されると LayerBitmap は削除され、画像データにアクセス出来なくなる。
         * また、現在の番号が一つ下にずれる。
         * 
         * @param index 現在のレイヤー番号
         */
        public function removeAt(index:int):void
        {
            layers[index].bitmapData.dispose();
            layers.splice(index, 1);
            spriteToView.removeChildAt(index);
            if (index >= currentIndex)
                currentIndex -= 1;
            compositeAll();
            resetLayersIndex();
        }
        
        internal function clear():void
        {
            var count:uint = layers.length;
            for (var i:uint = 0; i < count; i++) {
                var layer:LayerBitmap = layers[i];
                spriteToView.removeChild(layer);
            }
            layers.length = 0;
        }
        
        /**
         * 全てのレイヤーの画像を合成する
         * 
         */
        internal function compositeAll():void
        {
            if (doCompositeAll) {
                var c:uint = count;
                composited.fillRect(composited.rect, 0x0);
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
         * 現在のレイヤー画像を返す
         * 
         * @return レイヤー画像 (LayerBitmap)
         */
        public function get currentLayer():LayerBitmap
        {
            return layers[currentIndex];
        }
        
        /**
         * 現在のレイヤー数を返す
         * 
         * @return レイヤー数
         */
        public function get count():uint
        {
            return layers.length;
        }
        
        public var currentIndex:uint;
        public var doCompositeAll:Boolean;
        internal var spriteToView:Sprite;
        internal var composited:BitmapData;
        internal var layers:Vector.<LayerBitmap>;
        private var m_width:uint;
        private var m_height:uint;
    }
}
