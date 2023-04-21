package com.frankhdz.spriter.data;

import com.frankhdz.spriterSpriterAnimation;

class SpriteTimelineKey extends TimelineKey
{
    public var folder : Int;  // index of the folder within the ScmlObject  
    public var file : Int;
    public var useDefaultPivot : Bool = true;  // true if missing pivot_x and pivot_y in object tag  
    public var pivot_x : Float = 0;
    public var pivot_y : Float = 1;
    
    public var spriteName : String = "";
    public var spriteName2 : String = "";
    public var fileRef : File;
    public var folderRef : Folder;
    
    public function new()
    {
        super();
    }
    
    override public function parseXML(spriteAnim : SpriterAnimation, timelineXml : FastXML) : Void
    {
        super.parseXML(spriteAnim, timelineXml);
        
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@x"))
        {
            x = timelineXml.nodes.object.get(0).att.x;
        }
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@y"))
        {
            y = -timelineXml.nodes.object.get(0).att.y;
        }
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@angle"))
        {
            angle = timelineXml.nodes.object.get(0).att.angle;
        }
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@scale_x"))
        {
            scaleX = timelineXml.nodes.object.get(0).att.scale_x;
        }
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@scale_y"))
        {
            scaleY = timelineXml.nodes.object.get(0).att.scale_y;
        }
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@a"))
        {
            a = timelineXml.nodes.object.get(0).att.a;
        }
        
        folder = timelineXml.nodes.object.get(0).att.folder;
        file = timelineXml.nodes.object.get(0).att.file;
        
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@pivot_x"))
        {
            pivot_x = timelineXml.nodes.object.get(0).att.pivot_x;
            useDefaultPivot = false;
        }
        if (timelineXml.nodes.object.get(0).node.exists.innerData("@pivot_y"))
        {
            pivot_y = timelineXml.nodes.object.get(0).att.pivot_y;
            useDefaultPivot = false;
        }
        
        folderRef = try cast(spriteAnim.folders[folder], Folder) catch(e:Dynamic) null;
        fileRef = try cast(folderRef.files[file], File) catch(e:Dynamic) null;
        spriteName = fileRef.name;
        
        var pos : Int = spriteName.lastIndexOf("/");
        if (pos != -1)
        {
            spriteName2 = spriteName.substr(pos + 1);
        }
    }
    
    override public function parse(spriteAnim : SpriterAnimation, timelineData : Dynamic) : Void
    {
        super.parse(spriteAnim, timelineData);
        
        if (timelineData.object.exists("x"))
        {
            x = timelineData.object.x;
        }
        if (timelineData.object.exists("y"))
        {
            y = -timelineData.object.y;
        }
        if (timelineData.object.exists("angle"))
        {
            angle = timelineData.object.angle;
        }
        
        folder = timelineData.object.folder;
        file = timelineData.object.file;
        
        if (timelineData.object.exists("scale_x"))
        {
            scaleX = timelineData.object.scale_x;
        }
        if (timelineData.object.exists("scale_y"))
        {
            scaleY = timelineData.object.scale_y;
        }
        if (timelineData.object.exists("a"))
        {
            a = timelineData.object.a;
        }
        
        if (timelineData.object.exists("pivot_x"))
        {
            pivot_x = timelineData.object.pivot_x;
            useDefaultPivot = false;
        }
        if (timelineData.object.exists("pivot_y"))
        {
            pivot_y = timelineData.object.pivot_y;
            useDefaultPivot = false;
        }
        
        folderRef = try cast(spriteAnim.folders[folder], Folder) catch(e:Dynamic) null;
        fileRef = try cast(folderRef.files[file], File) catch(e:Dynamic) null;
        spriteName = fileRef.name;
        
        var pos : Int = spriteName.lastIndexOf("/");
        if (pos != -1)
        {
            spriteName2 = spriteName.substr(pos + 1);
        }
    }
    
    override public function copy() : Dynamic
    {
        var copy : TimelineKey = new SpriteTimelineKey();
        clone(copy);
        
        return copy;
    }
    
    override public function clone(clone : TimelineKey) : Void
    {
        super.clone(clone);
        
        var c : SpriteTimelineKey = try cast(clone, SpriteTimelineKey) catch(e:Dynamic) null;
        
        c.pivot_x = this.pivot_x;
        c.pivot_y = this.pivot_y;
        c.folder = this.folder;
        c.file = this.file;
        c.useDefaultPivot = this.useDefaultPivot;
        c.spriteName = this.spriteName;
        c.spriteName2 = this.spriteName2;
        c.fileRef = this.fileRef;
        c.folderRef = this.folderRef;
    }
    
    override public function paint() : Void
    {  /*			var	paintPivotX:int;
			var	paintPivotY:int;
			
			if (useDefaultPivot)
			{
//				paintPivotX = ScmlObject.activeCharacterMap[folder].files[file].pivotX;
//				paintPivotY = ScmlObject.activeCharacterMap[folder].files[file].pivotY;
			}
			else
			{
				paintPivotX = pivot_x;
				paintPivotY = pivot_y;
			}
			
			// paint image represented by
			// ScmlObject.activeCharacterMap[folder].files[file],fileReference 
			// at x,y,angle (counter-clockwise), offset by paintPivotX,paintPivotY		
*/  
        
    }
    
    override public function linearKey(keyB : TimelineKey, t : Float) : Void
    {
        linearSpatialInfo(this, keyB, spin, t);
        
        if (!useDefaultPivot)
        {
            var keyBSprite : SpriteTimelineKey = try cast(keyB, SpriteTimelineKey) catch(e:Dynamic) null;
            
            pivot_x = linear(pivot_x, keyBSprite.pivot_x, t);
            pivot_y = linear(pivot_y, keyBSprite.pivot_y, t);
        }
    }
}
