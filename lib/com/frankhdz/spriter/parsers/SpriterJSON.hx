package com.frankhdz.spriter.parsers;

import com.frankhdz.spriterSpriterAnimation;
import com.frankhdz.spriterdata.Entity;
import com.frankhdz.spriterdata.Folder;

class SpriterJSON
{
    public function new()
    {
    }
    
    public static function parse(spriteAnim : SpriterAnimation, data : Dynamic, entities : Array<Dynamic> = null, animations : Array<Dynamic> = null) : Void
    {
        for (folderData/* AS3HX WARNING could not determine type for var: folderData exp: EField(EIdent(data),folder) type: null */ in data.folder)
        {
            var folder : Folder = new Folder();
            folder.parse(folderData);
            
            spriteAnim.folders.push(folder);
        }
        
        for (entityData/* AS3HX WARNING could not determine type for var: entityData exp: EField(EIdent(data),entity) type: null */ in data.entity)
        {
            var entity : Entity = new Entity();
            entity.name = entityData.name;
            entity.entityData = entityData;
            
            if (entities == null || Lambda.indexOf(entities, entity.name) != -1)
            {
                entity.parse(spriteAnim, animations);
            }
            
            spriteAnim.entities.push(entity);
        }
    }
}
