package com.acemobe.spriter.data;

import com.acemobe.spriter.SpriterAnimation;
import starling.textures.TextureAtlas;

class Entity
{
    public var id : Int = 0;
    public var name : String = "";
    public var loaded : Bool = false;
    public var characterMaps : Array<Dynamic> = [];
    public var animations : Array<Dynamic> = [];
    public var objectInfos : Array<Dynamic> = [];
    public var entityData : Dynamic;
    public var atlas : TextureAtlas;
    
    public function new()
    {
    }
    
    public function parseXML(spriteAnim : SpriterAnimation, anims : Array<Dynamic> = null) : Void
    {
        var xml : FastXML = try cast(entityData, FastXML) catch(e:Dynamic) null;
        
        id = xml.att.id;
        
        for (objInfoXml in xml.nodes.obj_info)
        {
            var objectInfo : ObjectInfo = new ObjectInfo();
            objectInfo.parseXML(spriteAnim, objInfoXml);
            
            objectInfos.push(objectInfo);
        }
        
        for (characterMapXml in xml.nodes.character_map)
        {
            var characterMap : CharacterMap = new CharacterMap();
            characterMap.parseXML(spriteAnim, characterMapXml);
            
            characterMaps.push(characterMap);
        }
        
        for (animationXml in xml.nodes.animation)
        {
            var animation : Animation = new Animation();
            animation.name = animationXml.att.name;
            animation.animationData = animationXml;
            
            if (anims == null || Lambda.indexOf(anims, animation.name) != -1)
            {
                animation.parseXML(spriteAnim);
            }
            
            animations.push(animation);
        }
        
        loaded = true;
    }
    
    public function parse(spriteAnim : SpriterAnimation, anims : Array<Dynamic> = null) : Void
    {
        id = entityData.id;
        
        for (objInfoData/* AS3HX WARNING could not determine type for var: objInfoData exp: EField(EIdent(entityData),obj_info) type: null */ in entityData.obj_info)
        {
            var objectInfo : ObjectInfo = new ObjectInfo();
            objectInfo.parse(spriteAnim, objInfoData);
            
            objectInfos.push(objectInfo);
        }
        
        for (characterMapData/* AS3HX WARNING could not determine type for var: characterMapData exp: EField(EIdent(entityData),character_map) type: null */ in entityData.character_map)
        {
            var characterMap : CharacterMap = new CharacterMap();
            characterMap.parse(spriteAnim, characterMapData);
            
            characterMaps.push(characterMap);
        }
        
        for (animationData/* AS3HX WARNING could not determine type for var: animationData exp: EField(EIdent(entityData),animation) type: null */ in entityData.animation)
        {
            var animation : Animation = new Animation();
            animation.name = animationData.name;
            animation.animationData = animationData;
            
            if (anims == null || Lambda.indexOf(anims, animation.name) != -1)
            {
                animation.parse(spriteAnim);
            }
            
            animations.push(animation);
        }
        
        loaded = true;
    }
}
