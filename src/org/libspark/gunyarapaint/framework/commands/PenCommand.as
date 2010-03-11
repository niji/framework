package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.Pen;
    
    /**
     * @private
     * 
     */
    public final class PenCommand implements ICommand
    {
        public static const ID:uint = 3;
        
        public static const THICKNESS:int = 1;
        
        public static const COLOR:int = 2;
        
        public static const ALPHA:int = 3;
        
        public static const BLEND_MODE:int = 4;
        
        public static const SCALE_MODE:int = 5;
        
        public static const CAPS:int = 6;
        
        public static const JOINTS:int = 7;
        
        public static const MITER_LIMIT:int = 8;
        
        public static const PIXEL_HINTING:int = 9;
        
        public function PenCommand()
        {
            m_pen = new Pen();
        }
        
        public function read(bytes:ByteArray):void
        {
            var type:int = bytes.readUnsignedByte();
            switch (type) {
                case THICKNESS:
                    m_pen.thickness = bytes.readUnsignedByte();
                    break;
                case COLOR:
                    m_pen.color = bytes.readUnsignedInt();
                    break;
                case ALPHA:
                    m_pen.alpha = bytes.readDouble();
                    break;
                case MITER_LIMIT:
                    m_pen.miterLimit = bytes.readDouble();
                    break;
                case BLEND_MODE:
                    m_pen.blendMode = bytes.readUTF();
                    break;
                case SCALE_MODE:
                    m_pen.scaleMode = bytes.readUTF();
                    break;
                case CAPS:
                    m_pen.capsStyle = bytes.readUTF();
                    break;
                case JOINTS:
                    m_pen.jointStyle = bytes.readUTF();
                    break;
                case PIXEL_HINTING:
                    m_pen.pixelHinting = bytes.readBoolean();
                    break;
                default:
                    throw new ArgumentError();
            }
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var type:int = args.type;
            bytes.writeByte(commandID);
            bytes.writeByte(type);
            switch (type) {
                case THICKNESS:
                    var thickness:int = args.thickness;
                    bytes.writeByte(thickness);
                    m_pen.thickness = thickness;
                    break;
                case COLOR:
                    var color:uint = args.color;
                    bytes.writeUnsignedInt(color);
                    m_pen.color = color;
                    break;
                case ALPHA:
                    var alpha:Number = args.alpha;
                    bytes.writeDouble(alpha);
                    m_pen.alpha = alpha;
                    break;
                case MITER_LIMIT:
                    var miterLimit:Number = args.miterLimit;
                    bytes.writeDouble(miterLimit);
                    m_pen.miterLimit = miterLimit;
                    break;
                case BLEND_MODE:
                    var blendMode:String = args.blendMode;
                    bytes.writeUTF(blendMode);
                    m_pen.blendMode = blendMode;
                    break;
                case SCALE_MODE:
                    var scaleMode:String = args.scaleMode;
                    bytes.writeUTF(scaleMode);
                    m_pen.scaleMode = scaleMode;
                    break;
                case CAPS:
                    var caps:String = args.capsStyle;
                    bytes.writeUTF(caps);
                    m_pen.capsStyle = caps;
                    break;
                case JOINTS:
                    var joints:String = args.jointStyle;
                    bytes.writeUTF(joints);
                    m_pen.jointStyle = joints;
                    break;
                case PIXEL_HINTING:
                    var hinting:Boolean = args.pixelHinting;
                    bytes.writeBoolean(hinting);
                    m_pen.pixelHinting = hinting;
                    break;
                default:
                    throw new ArgumentError();
            }
        }
        
        public function execute(painter:Painter):void
        {
            painter.pen = m_pen;
        }
        
        public function reset():void
        {
            m_pen.reset();
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_pen:Pen;
    }
}
