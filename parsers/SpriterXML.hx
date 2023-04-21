package com.frankhdz.spriter.parsers;

import com.frankhdz.spriterdata.Entity;
import com.frankhdz.spriterdata.Folder;
import com.frankhdz.spriterSpriterAnimation;

class SpriterXML
{
    public function new()
    {
    }
    
    public static function parse(spriteAnim : SpriterAnimation, data : FastXML, entities : Array<Dynamic> = null, animations : Array<Dynamic> = null) : Void
    {
        for (folderXml in data.nodes.folder)
        {
            var folder : Folder = new Folder();
            folder.parseXML(folderXml);
            
            spriteAnim.folders.push(folder);
        }
        
        for (entityXml in data.nodes.entity)
        {
            var entity : Entity = new Entity();
            entity.name = entityXml.att.name;
            entity.entityData = entityXml;
            
            if (entities == null || Lambda.indexOf(entities, entity.name) != -1)
            {
                entity.parseXML(spriteAnim, animations);
            }
            
            spriteAnim.entities.push(entity);
        }
    }
}
