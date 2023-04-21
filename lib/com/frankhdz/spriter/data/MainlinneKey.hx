package com.frankhdz.spriter.data;

import com.frankhdz.spriterSpriterAnimation;

class MainlineKey
{
    public static var INSTANT : Int = 0;
    public static var LINEAR : Int = 1;
    public static var QUADRATIC : Int = 2;
    public static var CUBIC : Int = 3;
    
    public var id : Int = 0;
    public var time : Int = 0;
    public var curveType : Int = LINEAR;
    public var boneRefs : Array<Dynamic> = [];
    public var objectRefs : Array<Dynamic> = [];
    
    public function new()
    {
    }
    
    public function parseXML(spriteAnim : SpriterAnimation, animationXml : FastXML) : Void
    {
        id = animationXml.att.id;
        time = animationXml.att.time;
        
        if (animationXml.node.exists.innerData("@curve_type"))
        {
            switch (Std.string(animationXml.att.curve_type))
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
        
        for (boneRefXml in animationXml.nodes.bone_ref)
        {
            var boneRef : Ref = new Ref();
            boneRef.parseXML(boneRefXml);
            
            boneRefs.push(boneRef);
        }
        
        for (objectRefXml in animationXml.nodes.object_ref)
        {
            var objectRef : Ref = new Ref();
            objectRef.parseXML(objectRefXml);
            
            objectRefs.push(objectRef);
        }
    }
    
    public function parse(spriteAnim : SpriterAnimation, animationData : Dynamic) : Void
    {
        id = animationData.id;
        time = animationData.time;
        
        if (animationData.exists("curve_type"))
        {
            var _sw0_ = (animationData.curve_type);            

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
        
        for (boneRefData/* AS3HX WARNING could not determine type for var: boneRefData exp: EField(EIdent(animationData),bone_ref) type: null */ in animationData.bone_ref)
        {
            var boneRef : Ref = new Ref();
            boneRef.parse(boneRefData);
            
            boneRefs.push(boneRef);
        }
        
        for (objectRefData/* AS3HX WARNING could not determine type for var: objectRefData exp: EField(EIdent(animationData),object_ref) type: null */ in animationData.object_ref)
        {
            var objectRef : Ref = new Ref();
            objectRef.parse(objectRefData);
            
            objectRefs.push(objectRef);
        }
    }
}
