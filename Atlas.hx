package kha2dUtils;

import kha.Assets;
import kha.Image;
import kha2dUtils.Rectangle;
import kha2dUtils.Sprite;

using StringTools;

/**
 * ...
 * @author Sergii
 */

typedef TileRects = 
{
	var rect:Rectangle;
	var frame:Rectangle;
}

class Atlas
{
	var tiles:Map<String, TileRects>;
	var atlasImg:Image;
	
	public function getMovieClip(name:String)
	{
		var endIndex = name.length - 1;
		var anim:Array<String> = new Array();
		var frames:Array<Sprite> = null;
		for (key in tiles.keys())
		{
			if (key.startsWith(name))
			{
				if (key.charCodeAt(name.length) > 47 && key.charCodeAt(name.length) < 58)
				{
					if (frames == null) frames = new Array();
					
					var s:Sprite = getTile(key);
					frames.push(s);
				}
			}
		}
		
		if (frames != null) 
		{
			frames.sort(function(a, b)
			{
				a.name < b.name?return -1:return 1;
			});
		}
		
		return frames;
	}
	
	public function new(atlasName:String) 
	{
		var atlasXML = Std.string(Reflect.field(Assets.blobs, atlasName + "_xml"));
		atlasImg = Reflect.field(Assets.images, atlasName);
		
		tiles = new Map<String, TileRects>();
		
		var x = new haxe.xml.Fast( Xml.parse(atlasXML).firstElement() );
		
		for (texture in x.nodes.SubTexture)
		{
			var name = texture.att.name;
			var rect = new Rectangle(
				Std.parseFloat(texture.att.x), Std.parseFloat(texture.att.y),
				Std.parseFloat(texture.att.width), Std.parseFloat(texture.att.height)
			);
			
			var frame = if (texture.has.frameX) // trimmed
					new Rectangle(
						Std.parseInt(texture.att.frameX), Std.parseInt(texture.att.frameY),
						Std.parseInt(texture.att.frameWidth), Std.parseInt(texture.att.frameHeight));
				else 
					new Rectangle(0, 0, rect.width, rect.height);
			
			
			//var tr = new TileRects();
			//tr.rect = rect;
			//tr.frame = frame;
			tiles.set(name, {rect:rect, frame:frame});
		}
		
		//getMovieClip("anim_");
	}
	
	public function getTile(name:String):Sprite
	{
		if (!tiles.exists(name)) return null;
		
		var t = tiles.get(name);
		var s = new Sprite(atlasImg, t.rect);
		s.name = name;
		s.aFrame = t.frame;
		return s;
	}
	
}