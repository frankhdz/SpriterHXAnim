package com.frankhdz.spriter.data;

import com.frankhdz.spriterSpriterAnimation;

class BoneTimelineKey extends TimelineKey
{
    public var length : Int = 200;
    public var width : Int = 10;
    public var paintDebugBones : Bool = true;
    
    public function new()
    {
        super();
    }
    
    override public function parseXML(spriteAnim : SpriterAnimation, timelineXml : FastXML) : Void
    {
        super.parseXML(spriteAnim, timelineXml);
        
        if (timelineXml.nodes.bone.get(0).node.exists.innerData("@x"))
        {
            x = timelineXml.nodes.bone.get(0).att.x;
        }
        if (timelineXml.nodes.bone.get(0).node.exists.innerData("@y"))
        {
            y = -timelineXml.nodes.bone.get(0).att.y;
        }
        if (timelineXml.nodes.bone.get(0).node.exists.innerData("@angle"))
        {
            angle = timelineXml.nodes.bone.get(0).att.angle;
        }
        if (timelineXml.nodes.bone.get(0).node.exists.innerData("@scale_x"))
        {
            scaleX = timelineXml.nodes.bone.get(0).att.scale_x;
        }
        if (timelineXml.nodes.bone.get(0).node.exists.innerData("@scale_y"))
        {
            scaleY = timelineXml.nodes.bone.get(0).att.scale_y;
        }
        if (timelineXml.nodes.bone.get(0).node.exists.innerData("@a"))
        {
            a = timelineXml.nodes.bone.get(0).att.a;
        }
        
        if (timelineXml.node.exists.innerData("@length"))
        {
            length = timelineXml.att.length;
        }
        if (timelineXml.node.exists.innerData("@width"))
        {
            width = timelineXml.att.width;
        }
    }
    
    override public function parse(spriteAnim : SpriterAnimation, timelineData : Dynamic) : Void
    {
        super.parse(spriteAnim, timelineData);
        
        if (timelineData.bone.exists("x"))
        {
            x = timelineData.bone.x;
        }
        if (timelineData.bone.exists("y"))
        {
            y = -timelineData.bone.y;
        }
        if (timelineData.bone.exists("angle"))
        {
            angle = timelineData.bone.angle;
        }
        if (timelineData.bone.exists("scale_x"))
        {
            scaleX = timelineData.bone.scale_x;
        }
        if (timelineData.bone.exists("scale_y"))
        {
            scaleY = timelineData.bone.scale_y;
        }
        if (timelineData.bone.exists("a"))
        {
            a = timelineData.bone.a;
        }
        
        if (timelineData.exists("length"))
        {
            length = timelineData.length;
        }
        if (timelineData.exists("width"))
        {
            width = timelineData.width;
        }
    }
    
    override public function paint() : Void
    {
        if (paintDebugBones)
        {
            var drawLength : Float = length * scaleX;
            var drawHeight : Float = width * scaleY;
        }
    }
    
    override public function copy() : Dynamic
    {
        var copy : TimelineKey = new BoneTimelineKey();
        clone(copy);
        
        return copy;
    }
    
    override public function clone(clone : TimelineKey) : Void
    {
        super.clone(clone);
        
        var c : BoneTimelineKey = try cast(clone, BoneTimelineKey) catch(e:Dynamic) null;
        
        c.length = this.length;
        c.width = this.width;
    }
    
    override public function linearKey(keyB : TimelineKey, t : Float) : Void  // keyB must be BoneTimelineKeys  
    {
        linearSpatialInfo(this, keyB, spin, t);
        
        if (paintDebugBones)
        {
            var keyBBone : BoneTimelineKey = try cast(keyB, BoneTimelineKey) catch(e:Dynamic) null;
            length = linear(length, keyBBone.length, t);
            width = linear(width, keyBBone.width, t);
        }
    }
}
