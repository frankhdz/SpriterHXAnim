package com.acemobe.spriter.data;

import com.acemobe.spriter.SpriterAnimation;

class TimeLine
{
    public static var SPRITE : Int = 0;
    public static var BONE : Int = 1;
    public static var BOX : Int = 2;
    public static var POINT : Int = 3;
    public static var SOUND : Int = 4;
    public static var ENTITY : Int = 5;
    public static var VARIABLE : Int = 6;
    
    public var id : Int = 0;
    public var name : String = "";
    public var objectType : Int = 0;
    
    public var keys : Array<Dynamic> = [];
    
    public function new()
    {
    }
    
    public function parseXML(spriteAnim : SpriterAnimation, timelineXml : FastXML) : Void
    {
        if (timelineXml.node.exists.innerData("@id"))
        {
            id = timelineXml.att.id;
        }
        if (timelineXml.node.exists.innerData("@name"))
        {
            name = timelineXml.att.name;
        }
        if (timelineXml.node.exists.innerData("@object_type"))
        {
            if (timelineXml.att.object_type == "sprite")
            {
                objectType = SPRITE;
            }
            if (timelineXml.att.object_type == "bone")
            {
                objectType = BONE;
            }
            if (timelineXml.att.object_type == "box")
            {
                objectType = BOX;
            }
            if (timelineXml.att.object_type == "point")
            {
                objectType = POINT;
            }
        }
        
        for (timelineKeyXml in timelineXml.nodes.key)
        {
            var timelineKey : TimelineKey = null;
            
            switch (objectType)
            {
                case SPRITE:
                    timelineKey = new SpriteTimelineKey();
                case BONE:
                    timelineKey = new BoneTimelineKey();
                case BOX:
                    timelineKey = new BoxTimelineKey();
                case POINT:
                    timelineKey = new PointTimelineKey();
            }
            
            if (timelineKey != null)
            {
                timelineKey.parseXML(spriteAnim, timelineKeyXml);
                timelineKey.timelineID = id;
                timelineKey.timeline = this;
                
                keys.push(timelineKey);
            }
        }
    }
    
    public function parse(spriteAnim : SpriterAnimation, timelineData : Dynamic) : Void
    {
        id = timelineData.id;
        name = timelineData.name;
        
        if (timelineData.object_type == "sprite")
        {
            objectType = SPRITE;
        }
        else if (timelineData.object_type == "bone")
        {
            objectType = BONE;
        }
        else if (timelineData.object_type == "box")
        {
            objectType = BOX;
        }
        else if (timelineData.object_type == "point")
        {
            objectType = POINT;
        }
        
        for (timelineKeyData/* AS3HX WARNING could not determine type for var: timelineKeyData exp: EField(EIdent(timelineData),key) type: null */ in timelineData.key)
        {
            var timelineKey : TimelineKey = null;
            
            switch (objectType)
            {
                case SPRITE:
                    timelineKey = new SpriteTimelineKey();
                case BONE:
                    timelineKey = new BoneTimelineKey();
                case BOX:
                    timelineKey = new BoxTimelineKey();
                case POINT:
                    timelineKey = new PointTimelineKey();
            }
            
            if (timelineKey != null)
            {
                timelineKey.parse(spriteAnim, timelineKeyData);
                timelineKey.timelineID = id;
                timelineKey.timeline = this;
                
                keys.push(timelineKey);
            }
        }
    }
}
