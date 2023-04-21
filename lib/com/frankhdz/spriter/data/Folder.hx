package com.frankhdz.spriter.data;


class Folder
{
    public var name : String = "";
    public var id : Int = 0;
    public var files : Array<Dynamic> = [];  // <file> tags  
    
    public function new()
    {
    }
    
    public function parseXML(folderXml : FastXML) : Void
    {
        id = folderXml.att.id;
        name = folderXml.att.name;
        
        for (file in folderXml.nodes.file)
        {
            var f : File = new File();
            f.parseXML(file);
            
            files.push(f);
        }
    }
    
    public function parse(folder : Dynamic) : Void
    {
        id = folder.id;
        name = folder.name;
        
        for (a in 0...folder.file.length)
        {
            var f : File = new File();
            f.parse(folder.file[a]);
            
            files.push(f);
        }
    }
}
