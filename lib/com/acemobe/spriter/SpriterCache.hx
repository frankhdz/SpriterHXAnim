package com.acemobe.spriter;

import flash.utils.Dictionary;

class SpriterCache
{
    private static var mAnimations : Dictionary = new Dictionary();
    
    public function new()
    {
    }
    
    public static function findAnimation(name : String) : SpriterAnimation
    {
        return Reflect.field(mAnimations, name);
    }
    
    public static function addAnimation(name : String, anim : SpriterAnimation) : SpriterAnimation
    {
        Reflect.setField(mAnimations, name, anim);
        
        return anim;
    }
}
