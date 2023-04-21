package com.frankhdz.spriter.data;

import com.frankhdz.spriterSpriterAnimation;

class BoxTimelineKey extends TimelineKey
{
    public var useDefaultPivot : Bool = true;  // true if missing pivot_x and pivot_y in object tag  
    public var pivot_x : Float = 0;
    public var pivot_y : Float = 1;
    
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
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@scale_x"))
        {
            scaleX = timelineXml.nodes.object.get(0).att.scale_x;
        }
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@scale_y"))
        {
            scaleY = timelineXml.nodes.object.get(0).att.scale_y;
        }
        if (timelineXml.node.exists.innerData("@pivot_x"))
        {
            pivot_x = timelineXml.att.pivot_x;
            useDefaultPivot = false;
        }
        if (timelineXml.node.exists.innerData("@pivot_y"))
        {
            pivot_y = timelineXml.att.pivot_y;
            useDefaultPivot = false;
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
        if (timelineData.object.exists("scale_x"))
        {
            scaleX = timelineData.object.scale_x;
        }
        if (timelineData.object.exists("scale_y"))
        {
            scaleY = timelineData.object.scale_y;
        }
        if (timelineData.exists("pivot_x"))
        {
            pivot_x = timelineData.pivot_x;
            useDefaultPivot = false;
        }
        if (timelineData.exists("pivot_y"))
        {
            pivot_y = timelineData.pivot_y;
            useDefaultPivot = false;
        }
    }
    
    override public function copy() : Dynamic
    {
        var copy : TimelineKey = new BoxTimelineKey();
        clone(copy);
        
        return copy;
    }
    
    override public function clone(clone : TimelineKey) : Void
    {
        super.clone(clone);
        
        var c : BoxTimelineKey = try cast(clone, BoxTimelineKey) catch(e:Dynamic) null;
        
        c.pivot_x = this.pivot_x;
        c.pivot_y = this.pivot_y;
        c.useDefaultPivot = this.useDefaultPivot;
    }
    
    override public function paint() : Void
    {
        var paintPivotX : Int;
        var paintPivotY : Int;
        
        if (useDefaultPivot)
        {
            paintPivotX = 0;
            paintPivotY = 1;
        }
        else
        {
            paintPivotX = as3hx.Compat.parseInt(pivot_x);
            paintPivotY = as3hx.Compat.parseInt(pivot_y);
        }
    }
    
    override public function linearKey(keyB : TimelineKey, t : Float) : Void
    {
        linearSpatialInfo(this, keyB, spin, t);
        
        if (!useDefaultPivot)
        {
            var keyBSprite : BoxTimelineKey = try cast(keyB, BoxTimelineKey) catch(e:Dynamic) null;
            
            pivot_x = linear(pivot_x, keyBSprite.pivot_x, t);
            pivot_y = linear(pivot_y, keyBSprite.pivot_y, t);
        }
    }
}
