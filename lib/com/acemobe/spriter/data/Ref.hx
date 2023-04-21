package com.acemobe.spriter.data;


class Ref
{
    public var id : Int = 0;
    public var parent : Int = -1;
    public var timeline : Int = 0;
    public var key : Int = 0;
    public var z_index : Int = 0;
    
    public var abs_pivot_x : Float = 0;
    public var abs_pivot_y : Float = 0;
    
    public function new()
    {
    }
    
    public function parseXML(refXml : FastXML) : Void
    {
        id = refXml.att.id;
        
        if (refXml.node.exists.innerData("@parent"))
        {
            parent = refXml.att.parent;
        }
        if (refXml.node.exists.innerData("@timeline"))
        {
            timeline = refXml.att.timeline;
        }
        if (refXml.node.exists.innerData("@key"))
        {
            key = refXml.att.key;
        }
        if (refXml.node.exists.innerData("@z_index"))
        {
            z_index = refXml.att.z_index;
        }
        if (refXml.node.exists.innerData("@abs_pivot_x"))
        {
            abs_pivot_x = refXml.att.abs_pivot_x;
        }
        if (refXml.node.exists.innerData("@abs_pivot_y"))
        {
            abs_pivot_y = refXml.att.abs_pivot_y;
        }
    }
    
    public function parse(refData : Dynamic) : Void
    {
        id = refData.id;
        
        if (refData.exists("parent"))
        {
            parent = refData.parent;
        }
        if (refData.exists("timeline"))
        {
            timeline = refData.timeline;
        }
        if (refData.exists("key"))
        {
            key = refData.key;
        }
        if (refData.exists("z_index"))
        {
            z_index = refData.z_index;
        }
        if (refData.exists("abs_pivot_x"))
        {
            abs_pivot_x = refData.abs_pivot_x;
        }
        if (refData.exists("abs_pivot_y"))
        {
            abs_pivot_y = refData.abs_pivot_y;
        }
    }
}
