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
/// @cond
package com.github.niji.framework.commands
{
/// @endcond
    import com.github.niji.framework.Painter;
    import com.github.niji.framework.Pen;
    
    import flash.errors.IllegalOperationError;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
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
        
        public function read(bytes:IDataInput):void
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
            m_type = type;
        }
        
        public function write(bytes:IDataOutput, args:Object):void
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
            m_type = type;
        }
        
        public function execute(painter:Painter):void
        {
            painter.pen = m_pen;
        }
        
        public function reset():void
        {
            m_pen.reset();
        }
        
        public function toString():String
        {
            var ret:String = "[PenCommand ";
            switch (m_type) {
                case THICKNESS:
                    ret += "thickness=" + m_pen.thickness + "]";
                    break;
                case COLOR:
                    ret += "color=0x" + m_pen.color.toString(16) + "]";
                    break;
                case ALPHA:
                    ret += "alpha=" + m_pen.alpha.toPrecision(4) + "]";
                    break;
                case MITER_LIMIT:
                    ret += "miterLimit=" + m_pen.miterLimit.toPrecision(4) + "]";
                    break;
                case BLEND_MODE:
                    ret += "blendMode=" + m_pen.blendMode + "]";
                    break;
                case SCALE_MODE:
                    ret += "scaleMode=" + m_pen.scaleMode + "]";
                    break;
                case CAPS:
                    ret += "capsStyle=" + m_pen.capsStyle + "]";
                    break;
                case JOINTS:
                    ret += "jointStyle=" + m_pen.jointStyle + "]";
                    break;
                case PIXEL_HINTING:
                    ret += "pixelHinting=" + m_pen.pixelHinting + "]";
                    break;
                default:
                    throw new IllegalOperationError();
            }
            return ret;
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        public function get type():uint
        {
            return m_type;
        }
        
        private var m_pen:Pen;
        private var m_type:uint;
    }
}
