package com.acemobe.spriter.data;

import com.acemobe.spriter.SpriterAnimation;

class MapInstruction
{
    public var folder : Int = 0;
    public var file : Int = 0;
    public var tarFolder : Int = -1;
    public var tarFile : Int = -1;
    
    public function new()
    {
    }
    
    public function parseXML(spriteAnim : SpriterAnimation, mapInstructionXml : FastXML) : Void
    {
        folder = mapInstructionXml.att.folder;
        file = mapInstructionXml.att.file;
        
        if (mapInstructionXml.node.exists.innerData("@tarFolder"))
        {
            tarFolder = mapInstructionXml.att.tarFolder;
        }
        if (mapInstructionXml.node.exists.innerData("@tarFile"))
        {
            tarFile = mapInstructionXml.att.tarFile;
        }
    }
    
    public function parse(spriteAnim : SpriterAnimation, mapInstructionData : Dynamic) : Void
    {
        folder = mapInstructionData.folder;
        file = mapInstructionData.file;
        
        if (mapInstructionData.exists("tarFolder"))
        {
            tarFolder = mapInstructionData.tarFolder;
        }
        if (mapInstructionData.exists("tarFile"))
        {
            tarFile = mapInstructionData.tarFile;
        }
    }
}
