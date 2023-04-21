package com.frankhdz.spriter.data;

import com.frankhdz.spriterSpriterAnimation;

class PointTimelineKey extends TimelineKey
{
    public function new()
    {
        super();
    }
    
    override public function parseXML(spriteAnim : SpriterAnimation, timelineXml : FastXML) : Void
    {
        super.parseXML(spriteAnim, timelineXml);
        
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@x"))
        {
            x = timelineXml.nodes.object.get(0).att.x;
        }
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@y"))
        {
            y = -timelineXml.nodes.object.get(0).att.y;
        }
    }
    
    override public function parse(spriteAnim : SpriterAnimation, timelineData : Dynamic) : Void
    {
        super.parse(spriteAnim, timelineData);
        
        if (timelineData.object.exists("x"))
        {
            x = timelineData.object.x;
        }
        if (timelineData.object.exists("y"))
        {
            y = -timelineData.object.y;
        }
    }
    
    override public function copy() : Dynamic
    {
        var copy : TimelineKey = new PointTimelineKey();
        clone(copy);
        
        return copy;
    }
    
    override public function clone(clone : TimelineKey) : Void
    {
        super.clone(clone);
    }
    
    override public function paint() : Void
    {
    }
    
    override public function linearKey(keyB : TimelineKey, t : Float) : Void
    {
        linearSpatialInfo(this, keyB, spin, t);
    }
}
