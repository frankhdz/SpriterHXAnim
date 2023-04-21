package com.frankhdz.spriter.data;

import com.frankhdz.spriterSpriter;
import com.frankhdz.spriterSpriterAnimation;
import starling.utils.Deg2rad;

class TimelineKey
{
    public static var INSTANT : Int = 0;
    public static var LINEAR : Int = 1;
    public static var QUADRATIC : Int = 2;
    public static var CUBIC : Int = 3;
    
    public var id : Int = 0;
    public var timelineID : Int = 0;
    public var name : String = "";
    public var curveType : Int = LINEAR;
    public var time : Int = 0;
    public var c1 : Float = 0;
    public var c2 : Float = 0;
    public var spin : Int = 1;
    
    //		SpatialInfo;
    public var x : Float = 0;
    public var y : Float = 0;
    public var angle : Float = 0;
    public var scaleX : Float = 1;
    public var scaleY : Float = 1;
    public var a : Float = 1;
    
    public var timeline : TimeLine = null;
    
    public function new()
    {
    }
    
    public function copy() : Dynamic
    {
        var copy : TimelineKey = new TimelineKey();
        clone(copy);
        
        return copy;
    }
    
    public function clone(clone : TimelineKey) : Void
    {
        clone.id = this.id;
        clone.timelineID = this.timelineID;
        clone.name = this.name;
        clone.curveType = this.curveType;
        clone.time = this.time;
        clone.c1 = this.c1;
        clone.c2 = this.c2;
        clone.spin = this.spin;
        
        clone.x = this.x;
        clone.y = this.y;
        clone.angle = this.angle;
        clone.scaleX = this.scaleX;
        clone.scaleY = this.scaleY;
        clone.a = this.a;
        clone.timeline = this.timeline;
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
        if (timelineXml.node.exists.innerData("@time"))
        {
            time = timelineXml.att.time;
        }
        if (timelineXml.node.exists.innerData("@c1"))
        {
            c1 = timelineXml.att.c1;
        }
        if (timelineXml.node.exists.innerData("@c2"))
        {
            c2 = timelineXml.att.c2;
        }
        if (timelineXml.node.exists.innerData("@spin"))
        {
            spin = timelineXml.att.spin;
        }
        if (timelineXml.node.exists.innerData("@curve_type"))
        {
            switch (Std.string(timelineXml.att.curve_type))
            {
                case "instant":
                    curveType = INSTANT;
                case "linear":
                    curveType = LINEAR;
                case "quadratic":
                    curveType = QUADRATIC;
                case "cubic":
                    curveType = CUBIC;
            }
        }
    }
    
    public function parse(spriteAnim : SpriterAnimation, timelineData : Dynamic) : Void
    {
        id = timelineData.id;
        name = timelineData.name;
        time = timelineData.time;
        
        if (timelineData.exists("c1"))
        {
            c1 = timelineData.c1;
        }
        if (timelineData.exists("c2"))
        {
            c2 = timelineData.c2;
        }
        if (timelineData.exists("spin"))
        {
            spin = timelineData.spin;
        }
        
        var _sw0_ = (timelineData.curveType);        

        switch (_sw0_)
        {
            case "instant":
                curveType = INSTANT;
            case "linear":
                curveType = LINEAR;
            case "quadratic":
                curveType = QUADRATIC;
            case "cubic":
                curveType = CUBIC;
        }
    }
    
    public function paint() : Void
    {
    }
    
    public function interpolate(nextKey : TimelineKey, nextKeyTime : Int, currentTime : Float) : Void
    {
        linearKey(nextKey, getTWithNextKey(nextKey, nextKeyTime, currentTime));
    }
    
    public function linearKey(keyB : TimelineKey, t : Float) : Void
    {  // overridden in inherited types  return linear(this,keyB,t);  
        
    }
    
    public function getTWithNextKey(nextKey : TimelineKey, nextKeyTime : Int, currentTime : Float) : Float
    {
        if (curveType == INSTANT || time == nextKeyTime)
        {
            return 0;
        }
        
        var t : Float = (currentTime - time) / (nextKeyTime - time);
        
        if (curveType == LINEAR)
        {
            return t;
        }
        else if (curveType == QUADRATIC)
        {
            return (quadratic(0.0, c1, 1.0, t));
        }
        else if (curveType == CUBIC)
        {
            return (cubic(0.0, c1, c2, 1.0, t));
        }
        
        return 0;
    }
    
    public function linear(a : Float, b : Float, t : Float) : Float
    {
        return ((b - a) * t) + a;
    }
    
    public function linearSpatialInfo(infoA : TimelineKey, infoB : TimelineKey, spin : Int, t : Float) : Void
    {
        x = linear(infoA.x, infoB.x, t);
        y = linear(infoA.y, infoB.y, t);
        angle = angleLinear(infoA.angle, infoB.angle, spin, t);
        scaleX = linear(infoA.scaleX, infoB.scaleX, t);
        scaleY = linear(infoA.scaleY, infoB.scaleY, t);
        a = linear(infoA.a, infoB.a, t);
    }
    
    public function angleLinear(angleA : Float, angleB : Float, spin : Int, t : Float) : Float
    {
        if (spin == 0)
        {
            return angleA;
        }
        if (spin > 0)
        {
            if ((angleB - angleA) < 0)
            {
                angleB += 360;
            }
        }
        else if (spin < 0)
        {
            if ((angleB - angleA) > 0)
            {
                angleB -= 360;
            }
        }
        
        return linear(angleA, angleB, t);
    }
    
    public function quadratic(a : Float, b : Float, c : Float, t : Float) : Float
    {
        return linear(linear(a, b, t), linear(b, c, t), t);
    }
    
    public function cubic(a : Float, b : Float, c : Float, d : Float, t : Float) : Float
    {
        return linear(quadratic(a, b, c, t), quadratic(b, c, d, t), t);
    }
    
    public function unmapFromParent(parentInfo : TimelineKey) : Void
    {
        if (parentInfo.scaleX * parentInfo.scaleY < 0)
        {
            angle = (360 - angle) + parentInfo.angle;
        }
        else
        {
            angle += parentInfo.angle;
        }
        
        scaleX *= parentInfo.scaleX;
        scaleY *= parentInfo.scaleY;
        a *= parentInfo.a;
        
        if (x != 0 || y != 0)
        {
            var new_angle : Float = deg2rad(Spriter.fixRotation(parentInfo.angle));
            var preMultX : Float = x * parentInfo.scaleX;
            var preMultY : Float = y * parentInfo.scaleY;
            var s : Float = Math.sin(new_angle);
            var c : Float = Math.cos(new_angle);
            x = (preMultX * c) - (preMultY * s);
            y = (preMultX * s) + (preMultY * c);
            x += parentInfo.x;
            y += parentInfo.y;
        }
        // Mandatory optimization for future features
        else
        {
            
            x = parentInfo.x;
            y = parentInfo.y;
        }
    }
}

