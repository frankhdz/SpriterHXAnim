package com.frankhdz.spriter.data;

import com.frankhdz.spriterSpriterAnimation;

class CharacterMap
{
    public var id : Int = 0;
    public var name : Int = 0;
    public var maps : Array<Dynamic> = [];
    
    public function new()
    {
    }
    
    public function parseXML(spriteAnim : SpriterAnimation, characterMapXml : FastXML) : Void
    {
        id = characterMapXml.att.id;
        name = characterMapXml.att.name;
        
        for (mapXml in characterMapXml.nodes.map)
        {
            var map : MapInstruction = new MapInstruction();
            map.parseXML(spriteAnim, mapXml);
            
            maps.push(map);
        }
    }
    
    public function parse(spriteAnim : SpriterAnimation, characterMapData : Dynamic) : Void
    {
        id = characterMapData.id;
        name = characterMapData.name;
        
        for (mapXml/* AS3HX WARNING could not determine type for var: mapXml exp: EField(EIdent(characterMapData),map) type: null */ in characterMapData.map)
        {
            var map : MapInstruction = new MapInstruction();
            map.parse(spriteAnim, mapXml);
            
            maps.push(map);
        }
    }
}
