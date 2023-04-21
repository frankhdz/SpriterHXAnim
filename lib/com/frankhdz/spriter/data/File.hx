package com.frankhdz.spriter.data;


class File
{
    public var id : Int = 0;
    public var name : String = "";
    public var width : Float = 0;
    public var height : Float = 0;
    public var pivot_x : Float = 0;
    public var pivot_y : Float = 1;
    
    public function new()
    {
    }
    
    public function parseXML(fileXml : FastXML) : Void
    {
        id = fileXml.att.id;
        
        name = fileXml.att.name;
        
        var pos : Int = name.lastIndexOf(".png");
        if (pos != -1)
        {
            name = name.substr(0, pos);
        }
        
        width = fileXml.att.width;
        height = fileXml.att.height;
        pivot_x = fileXml.att.pivot_x;
        pivot_y = fileXml.att.pivot_y;
    }
    
    public function parse(file : Dynamic) : Void
    {
        id = file.id;
        name = file.name;
        
        var pos : Int = name.lastIndexOf(".png");
        if (pos != -1)
        {
            name = name.substr(0, pos);
        }
        
        width = file.width;
        height = file.height;
        pivot_x = file.pivot_x;
        pivot_y = file.pivot_y;
    }
}
