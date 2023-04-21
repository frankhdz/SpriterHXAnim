package com.frankhdz.spriter.data;

import com.frankhdz.spriterSpriterAnimation;

class Animation
{
    public static var NO_LOOPING : Int = 0;
    public static var LOOPING : Int = 1;
    
    public var id : Int = 0;
    public var name : String = "";
    public var animationData : Dynamic;
    public var loopType : Int = LOOPING;
    public var length : Int = 0;
    public var loaded : Bool = false;
    
    public var looped : Bool = true;
    
    public var mainlineKeys : Array<Dynamic> = [];
    public var timelines : Array<Dynamic> = [];
    
    public var currentTime : Int = 0;
    
    public var objectKeys : Array<Dynamic> = [];
    public var transformedBoneKeys : Array<Dynamic> = [];
    
    public function new()
    {
    }
    
    public function parseXML(spriteAnim : SpriterAnimation) : Void
    {
        var xml : FastXML = try cast(animationData, FastXML) catch(e:Dynamic) null;
        
        id = xml.att.id;
        length = xml.att.length;
        
        if (xml.node.exists.innerData("@looping"))
        {
            if (xml.att.looping == "true")
            {
                loopType = LOOPING;
            }
            else
            {
                loopType = NO_LOOPING;
            }
        }
        
        for (mainlineXml/* AS3HX WARNING could not determine type for var: mainlineXml exp: EField(EField(EIdent(xml),mainline),key) type: null */ in xml.nodes.mainline.node.key.innerData)
        {
            var mainline : MainlineKey = new MainlineKey();
            mainline.parseXML(spriteAnim, mainlineXml);
            
            mainlineKeys.push(mainline);
        }
        
        for (timelineXml in xml.nodes.timeline)
        {
            var timeline : TimeLine = new TimeLine();
            timeline.parseXML(spriteAnim, timelineXml);
            
            timelines.push(timeline);
        }
        
        loaded = true;
    }
    
    public function parse(spriteAnim : SpriterAnimation) : Void
    {
        id = animationData.id;
        length = animationData.length;
        
        if (animationData.exists("looping"))
        {
            if (animationData.looping == "true")
            {
                loopType = LOOPING;
            }
            else
            {
                loopType = NO_LOOPING;
            }
        }
        
        for (mainlineData/* AS3HX WARNING could not determine type for var: mainlineData exp: EField(EField(EIdent(animationData),mainline),key) type: null */ in animationData.mainline.key)
        {
            var mainline : MainlineKey = new MainlineKey();
            mainline.parse(spriteAnim, mainlineData);
            
            mainlineKeys.push(mainline);
        }
        
        for (timelineData/* AS3HX WARNING could not determine type for var: timelineData exp: EField(EIdent(animationData),timeline) type: null */ in animationData.timeline)
        {
            var timeline : TimeLine = new TimeLine();
            timeline.parse(spriteAnim, timelineData);
            
            timelines.push(timeline);
        }
        
        for (soundlineData/* AS3HX WARNING could not determine type for var: soundlineData exp: EField(EIdent(animationData),soundline) type: null */ in animationData.soundline)
        {  /*				var	timeline:TimeLine = new TimeLine ();
				timeline.parse (spriteAnim, timelineData);
				
				timelines.push (timeline);
*/  
        }
        
        loaded = true;
    }
    
    public function setCurrentTime(newTime : Float) : Void
    {
        looped = false;
        
        if (newTime >= length)
        {
            looped = true;
        }
        
        if (loopType == NO_LOOPING)
        {
            currentTime = Math.min(newTime, length);
        }
        else if (loopType == LOOPING)
        {
            currentTime = as3hx.Compat.parseInt(newTime % length);
        }
        
        updateCharacter(mainlineKeyFromTime(currentTime), currentTime);
    }
    
    public function updateCharacter(mainKey : MainlineKey, newTime : Int) : Void
    {
        var currentRef : Ref;
        var currentKey : TimelineKey;
        
        as3hx.Compat.setArrayLength(transformedBoneKeys, 0);
        as3hx.Compat.setArrayLength(objectKeys, 0);
        
        for (b in 0...mainKey.boneRefs.length)
        {
            currentRef = mainKey.boneRefs[b];
            
            if (mainKey.curveType != MainlineKey.INSTANT)
            {
                currentKey = keyFromRef(currentRef, newTime);
            }
            else
            {
                currentKey = timelines[currentRef.timeline].keys[currentRef.key].copy();
            }
            
            if (currentRef.parent >= 0)
            {
                currentKey.unmapFromParent(transformedBoneKeys[currentRef.parent]);
            }
            
            transformedBoneKeys.push(currentKey);
        }
        
        for (o in 0...mainKey.objectRefs.length)
        {
            currentRef = mainKey.objectRefs[o];
            if (mainKey.curveType != MainlineKey.INSTANT)
            {
                currentKey = keyFromRef(currentRef, newTime);
            }
            else
            {
                currentKey = timelines[currentRef.timeline].keys[currentRef.key].copy();
            }
            
            if (currentRef.parent >= 0)
            {
                currentKey.unmapFromParent(transformedBoneKeys[currentRef.parent]);
            }
            
            objectKeys.push(currentKey);
        }
    }
    
    public function mainlineKeyFromTime(time : Int) : MainlineKey
    {
        var currentMainKey : Int = 0;
        for (m in 0...mainlineKeys.length)
        {
            if (mainlineKeys[m].time <= currentTime)
            {
                currentMainKey = m;
            }
            
            if (mainlineKeys[m].time >= currentTime)
            {
                break;
            }
        }
        
        return mainlineKeys[currentMainKey];
    }
    
    public function keyFromRef(ref : Ref, newTime : Int) : TimelineKey
    {
        var timeline : TimeLine = timelines[ref.timeline];
        var keyA : TimelineKey = timeline.keys[ref.key].copy();
        
        if (timeline.keys.length == 1)
        {
            return keyA;
        }
        
        var nextKeyIndex : Int = as3hx.Compat.parseInt(ref.key + 1);
        
        if (nextKeyIndex >= timeline.keys.length)
        {
            if (loopType == LOOPING)
            {
                nextKeyIndex = 0;
            }
            else
            {
                return keyA;
            }
        }
        
        var keyB : TimelineKey = timeline.keys[nextKeyIndex];
        var keyBTime : Int = keyB.time;
        
        if (keyBTime < keyA.time)
        {
            keyBTime = as3hx.Compat.parseInt(keyBTime + length);
        }
        
        keyA.interpolate(keyB, keyBTime, currentTime);
        return keyA;
    }
}
