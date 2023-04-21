package com.frankhdz.spriter.data;

import com.frankhdz.spriterSpriterAnimation;

class ObjectInfo
{
    public static var BOX : Int = 0;
    public static var BONE : Int = 1;
    
    public var name : String = "";
    public var type : Int = 0;
    public var w : Float;
    public var h : Float;
    public var pivot_x : Float;
    public var pivot_y : Float;
    
    public function new()
    {
    }
    
    public function parseXML(spriteAnim : SpriterAnimation, objectInfoXml : FastXML) : Void
    {
        name = objectInfoXml.att.name;
        w = objectInfoXml.att.w;
        h = objectInfoXml.att.h;
        
        if (objectInfoXml.node.exists.innerData("@pivot_x"))
        {
            pivot_x = objectInfoXml.att.pivot_x;
        }
        if (objectInfoXml.node.exists.innerData("@pivot_y"))
        {
            pivot_y = objectInfoXml.att.pivot_y;
        }
        
        if (objectInfoXml.node.exists.innerData("@type"))
        {
            if (objectInfoXml.att.type == "box")
            {
                type = BOX;
            }
            else if (objectInfoXml.att.type == "bone")
            {
                type = BONE;
            }
        }
    }
    
    public function parse(spriteAnim : SpriterAnimation, objectInfoData : Dynamic) : Void
    {
        name = objectInfoData.name;
        w = objectInfoData.w;
        h = objectInfoData.h;
        
        if (objectInfoData.exists("pivot_x"))
        {
            pivot_x = objectInfoData.pivot_x;
        }
        if (objectInfoData.exists("pivot_y"))
        {
            pivot_y = objectInfoData.pivot_y;
        }
        
        if (objectInfoData.type == "box")
        {
            type = BOX;
        }
        else if (objectInfoData.type == "bone")
        {
            type = BONE;
        }
    }
}
