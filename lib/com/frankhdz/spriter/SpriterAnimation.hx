package com.frankhdz.spriter;

import com.frankhdz.spriterparsers.SpriterJSON;
import com.frankhdz.spriterparsers.SpriterXML;
import starling.textures.TextureAtlas;

class SpriterAnimation
{
    public var name : String = "";
    
    public var folders : Array<Dynamic> = [];
    public var entities : Array<Dynamic> = [];  // <entity> tags  
    public var activeCharacterMap : Array<Dynamic> = [];
    public var atlas : TextureAtlas;
    
    public function new(name : String, data : Dynamic, atlas : TextureAtlas = null, entities : Array<Dynamic> = null, animations : Array<Dynamic> = null)
    {
        this.name = name;
        this.atlas = atlas;
        
        if (Std.is(data, FastXML))
        {
            SpriterXML.parse(this, data, entities, animations);
        }
        else
        {
            SpriterJSON.parse(this, data, entities, animations);
        }
    }
}
