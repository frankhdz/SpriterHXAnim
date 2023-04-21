package com.acemobe.spriter;

import haxe.Constraints.Function;
import com.acemobe.spriter.data.Animation;
import com.acemobe.spriter.data.BoxTimelineKey;
import com.acemobe.spriter.data.Entity;
import com.acemobe.spriter.data.Folder;
import com.acemobe.spriter.data.PointTimelineKey;
import com.acemobe.spriter.data.SpriteTimelineKey;
import com.acemobe.spriter.data.TimelineKey;
import flash.utils.Dictionary;
import starling.animation.IAnimatable;
import starling.display.Image;
import starling.display.QuadBatch;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.Deg2rad;

class Spriter extends Sprite implements IAnimatable
{
    public var folders(get, never) : Array<Dynamic>;
    public var entity(never, set) : String;

    private var animation : SpriterAnimation;
    
    private var currentEntity : Int = 0;
    private var currentAnimation : Int = -1;
    private var currentTime : Float = 0.0;
    private var currentColor : Int = 0xffffff;
    
    private var mFrameCallBack : Function = null;
    private var mCompleteCallback : Function = null;
    
    public var playbackSpeed : Float = 1;
    public var activePoints : Array<Dynamic> = [];
    public var activeBoxes : Array<Dynamic> = [];
    
    private var imagesByName : Dynamic;
    private var colorByName : Dynamic;
    
    private var quadBatch : QuadBatch;
    private var nextAnim : String = "";
    private var curAtlas : TextureAtlas;
    
    public function new(name : String, animName : String, data : Dynamic = null, atlas : TextureAtlas = null, entities : Array<Dynamic> = null, animations : Array<Dynamic> = null)
    {
        super();
        
        this.name = name;
        
        imagesByName = { };
        colorByName = { };
        
        animation = SpriterCache.findAnimation(animName);
        
        if (animation == null)
        {
            animation = SpriterCache.addAnimation(animName, new SpriterAnimation(animName, data, atlas, entities, animations));
        }
        
        quadBatch = new QuadBatch();
        addChild(quadBatch);
    }
    
    public function setAnimation(name : String) : Void
    {
        animation = SpriterCache.findAnimation(name);
    }
    
    override public function dispose() : Void
    {
        for (name in Reflect.fields(imagesByName))
        {
            Reflect.field(imagesByName, name).dispose();
            Reflect.setField(imagesByName, name, null);
        }
        
        for (name in Reflect.fields(colorByName))
        {
            Reflect.setField(colorByName, name, null);
        }
        
        quadBatch.dispose();
        removeChildren(0, -1, true);
        
        imagesByName = null;
        colorByName = null;
        
        super.dispose();
    }
    
    public function clearImages() : Void
    {
        for (name in Reflect.fields(imagesByName))
        {
            Reflect.field(imagesByName, name).dispose();
            Reflect.setField(imagesByName, name, null);
        }
        
        imagesByName = [];
    }
    
    public function clearMapping() : Void
    {
        mTextureMapping = new Dictionary();
    }
    
    public function getAnimationName() : String
    {
        return animation.name;
    }
    
    private function get_folders() : Array<Dynamic>
    {
        return animation.folders;
    }
    
    public function getfolder(name : String) : Folder
    {
        for (a in 0...animation.folders.length)
        {
            var folder : Folder = animation.folders[a];
            
            if (folder.name == name)
            {
                return folder;
            }
        }
        
        return null;
    }
    
    public function loadEntity(name : String, animations : Array<Dynamic> = null) : Void
    {
        for (a in 0...animation.entities.length)
        {
            var entity : Entity = try cast(animation.entities[a], Entity) catch(e:Dynamic) null;
            
            if (entity.name == name && !entity.loaded)
            {
                if (Std.is(entity.entityData, FastXML))
                {
                    entity.parseXML(animation, animations);
                }
            }
        }
    }
    
    private function set_entity(name : String) : String
    {
        for (a in 0...animation.entities.length)
        {
            var entity : Entity = animation.entities[a];
            
            if (entity.name == name)
            {
                currentEntity = a;
                return name;
            }
        }
        return name;
    }
    
    public function setEntityTextureAtlas(atlas : TextureAtlas) : Void
    {
        var entity : Entity = try cast(animation.entities[currentEntity], Entity) catch(e:Dynamic) null;
        
        if (entity != null)
        {
            entity.atlas = atlas;
        }
    }
    
    public function hasAnim(animName : String) : Bool
    {
        var entity : Entity = try cast(animation.entities[currentEntity], Entity) catch(e:Dynamic) null;
        
        for (a in 0...entity.animations.length)
        {
            var anim : Animation = try cast(entity.animations[a], Animation) catch(e:Dynamic) null;
            
            if (anim.name == animName && anim.loaded)
            {
                return true;
            }
        }
        
        return false;
    }
    
    public function loadAnim(name : String, animName : String) : Void
    {
        for (e in 0...animation.entities.length)
        {
            var entity : Entity = try cast(animation.entities[e], Entity) catch(e:Dynamic) null;
            
            for (a in 0...entity.animations.length)
            {
                var anim : Animation = try cast(entity.animations[a], Animation) catch(e:Dynamic) null;
                
                if (anim.name == animName && !anim.loaded)
                {
                    anim.parseXML(animation);
                }
            }
        }
    }
    
    public function playAnim(animName : String, nextAnim : String = "", callback : Dynamic = null, force : Bool = false) : Void
    {
        var entity : Entity = try cast(animation.entities[currentEntity], Entity) catch(e:Dynamic) null;
        
        this.nextAnim = nextAnim;
        mCompleteCallback = callback;
        
        for (a in 0...entity.animations.length)
        {
            var anim : Animation = try cast(entity.animations[a], Animation) catch(e:Dynamic) null;
            
            if (anim.name == animName)
            {
                if (currentAnimation != a || force)
                {
                    currentAnimation = a;
                    currentTime = 0;
                }
                else if (anim.currentTime >= anim.length)
                {
                    currentTime = 0;
                }
                
                if (visible == false)
                {
                    visible = true;
                    currentTime = 0;
                }
                return;
            }
        }
    }
    
    public function setFrameCallback(callback : Dynamic) : Void
    {
        mFrameCallBack = callback;
    }
    
    public function advanceTime(time : Float) : Void
    {
        if (!visible)
        {
            return;
        }
        
        var entity : Entity = try cast(animation.entities[currentEntity], Entity) catch(e:Dynamic) null;
        var anim : Animation = try cast(entity.animations[currentAnimation], Animation) catch(e:Dynamic) null;
        curAtlas = entity.atlas;
        
        if (curAtlas == null)
        {
            curAtlas = animation.atlas;
        }
        
        var image : Image;
        
        if (anim != null && curAtlas != null)
        {
            currentTime += (time * playbackSpeed);
            
            anim.setCurrentTime(currentTime * 1000);
            
            as3hx.Compat.setArrayLength(activePoints, 0);
            as3hx.Compat.setArrayLength(activeBoxes, 0);
            
            quadBatch.reset();
            
            for (k in 0...anim.objectKeys.length)
            {
                var key : TimelineKey = try cast(anim.objectKeys[k], TimelineKey) catch(e:Dynamic) null;
                
                if (Std.is(key, SpriteTimelineKey))
                {
                    var spriteKey : SpriteTimelineKey = try cast(key, SpriteTimelineKey) catch(e:Dynamic) null;
                    image = Reflect.field(imagesByName, Std.string(spriteKey.spriteName));
                    
                    if (image == null)
                    {
                        image = getImageByName(spriteKey);
                    }
                    
                    if (image != null)
                    {
                        if (!spriteKey.useDefaultPivot)
                        {
                            image.pivotX = spriteKey.pivot_x * spriteKey.fileRef.width;
                            image.pivotY = (1 - spriteKey.pivot_y) * spriteKey.fileRef.height;
                        }
                        
                        image.x = spriteKey.x;
                        image.y = spriteKey.y;
                        image.color = Reflect.field(colorByName, Std.string(spriteKey.spriteName));
                        image.scaleX = spriteKey.scaleX;
                        image.scaleY = spriteKey.scaleY;
                        image.rotation = deg2rad(fixRotation(spriteKey.angle));
                        image.visible = true;
                        image.alpha = spriteKey.a;
                        
                        quadBatch.addImage(image);
                        
                        if (Reflect.field(colorByName, Std.string(spriteKey.spriteName)) != 0xffffff)
                        
                        //								if (texture && (quad.tinted|| parentAlpha != 1.0)){
                            
                            //									mTinted = true;
                            
                            quadBatch.setQuadColor(quadBatch.numQuads - 1, Reflect.field(colorByName, Std.string(spriteKey.spriteName)));
                        }
                    }
                }
                else if (Std.is(key, PointTimelineKey))
                {
                    var point : PointTimelineKey = try cast(key, PointTimelineKey) catch(e:Dynamic) null;
                    
                    activePoints.push(point);
                }
                else if (Std.is(key, BoxTimelineKey))
                {
                    var box : BoxTimelineKey = try cast(key, BoxTimelineKey) catch(e:Dynamic) null;
                    
                    activeBoxes.push(box);
                }
            }
            
            if (anim.currentTime >= anim.length)
            {
                if (nextAnim != "")
                {
                    playAnim(nextAnim);
                }
                
                if (mCompleteCallback != null)
                {
                    mCompleteCallback(this);
                }
                
                if (anim.loopType == Animation.NO_LOOPING)
                {
                    visible = false;
                }
            }
            else if (anim.looped &&
                (nextAnim != "" || mCompleteCallback != null))
            {
                if (nextAnim != null)
                {
                    playAnim(nextAnim);
                }
                
                if (mCompleteCallback != null)
                {
                    mCompleteCallback(this);
                }
            }
        }
        
        if (mFrameCallBack != null)
        {
            mFrameCallBack(this);
        }
    }
    
    public static function fixRotation(rotation : Float) : Float
    {
        while (rotation < 0)
        {
            rotation += 360;
        }
        
        while (rotation >= 360)
        {
            rotation -= 360;
        }
        
        return 360 - rotation;
    }
    
    public function getImage(name : String) : Image
    {
        return Reflect.field(imagesByName, name);
    }
    
    public function setColor(value : Float) : Void
    {
        for (name in Reflect.fields(imagesByName))
        {
            Reflect.setField(imagesByName, name, value).color;
            Reflect.setField(colorByName, name, value).color;
        }
        
        currentColor = as3hx.Compat.parseInt(value);
    }
    
    public function setImageColor(image : String, value : Float) : Void
    {
        Reflect.setField(colorByName, image, value);
        
        if (Reflect.field(imagesByName, image) != null)
        {
            Reflect.setField(imagesByName, image, value).color;
        }
    }
    
    public var mTextureMapping : Dictionary = new Dictionary();
    
    private function getImageByName(key : SpriteTimelineKey) : Image
    {
        if (Reflect.field(imagesByName, Std.string(key.spriteName)) != null)
        {
            return Reflect.field(imagesByName, Std.string(key.spriteName));
        }
        
        var spriteName : String = key.spriteName;
        var spriteName2 : String = key.spriteName2;
        
        if (mTextureMapping[key.spriteName] != null)
        {
            spriteName = mTextureMapping[key.spriteName];
            
            var pos : Int = spriteName.lastIndexOf("/");
            if (pos != -1)
            {
                spriteName2 = spriteName.substr(pos + 1);
            }
        }
        
        if (mTextureMapping[key.folderRef.name] != null)
        {
            spriteName = mTextureMapping[key.folderRef.name];
            
            pos = spriteName.lastIndexOf("/");
            if (pos != -1)
            {
                spriteName2 = spriteName.substr(pos + 1);
            }
        }
        
        var image : Image;
        var entity : Entity = try cast(animation.entities[currentEntity], Entity) catch(e:Dynamic) null;
        var texture : Texture = curAtlas.getTexture(spriteName);
        
        if (texture == null)
        {
            texture = curAtlas.getTexture(spriteName2);
        }
        
        if (texture != null)
        {
            Reflect.setField(imagesByName, Std.string(key.spriteName), image = new Image(texture));
            image.name = key.spriteName;
            image.pivotX = key.fileRef.pivot_x * key.fileRef.width;
            image.pivotY = (1 - key.fileRef.pivot_y) * key.fileRef.height;
            
            if (Reflect.field(colorByName, Std.string(key.spriteName)) == null)
            {
                Reflect.setField(colorByName, Std.string(key.spriteName), image.color = currentColor);
            }
        }
        else
        {  //				trace ("Missing texture: " + spriteName2);  
            
        }
        
        return image;
    }
}
