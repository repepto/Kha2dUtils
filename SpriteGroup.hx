package kha2dUtils;

import kha2dUtils.Sprite;

/**
 * ...
 * @author Sergii
 */
class SpriteGroup 
{
	public var sprites:Array<Sprite>;
	
	public var x:Float = 0;
	public var y:Float = 0;
	public var z(default, set):UInt;
	public var rotation:Float = 0;
	public var scaleX:Float = 1;
	public var scaleY:Float = 1;
	public var originX:Float = 0;
	public var originY:Float = 0;
	public var isAddedToScene:Bool = false;
	

	public function new() 
	{
		sprites = new Array();
	}
	
	public function addChild(s:Sprite)
	{
		sprites.push(s);
		s.parent = this;
		if(isAddedToScene) Scene.the.addHero(s);
	}
	
	public function removeChild(s:Sprite)
	{
		sprites.remove(s);
		if (s.isAddedToScene) 
		{
			s.isAddedToScene = false;
			Scene.the.removeHero(s);		
		}
	}
	
	public function set_z(z:UInt)
	{
		for (s in sprites)
		{
			s.z = z;
		}
		return z;
	}
	
	public function update()
	{
		for (s in sprites)
		{
			var tx = s.x - (s.originX * scaleX - s.originX) / scaleX;
			var ty = s.y - (s.originY * scaleY - s.originY) / scaleY;
			
			var d = Math.sqrt((tx - originX) * (tx - originX) + (ty - originY) * (ty - originY));
			var a = Math.atan2(ty - originY, tx - originX);
			
			s.renderData = 
			{
				x:scaleX * d * Math.cos(rotation + a) + x, 
				y:scaleY * d * Math.sin(rotation + a) + y, 
				r:rotation, 
				sx:scaleX * s.scaleX, 
				sy:scaleY * s.scaleY, 
				ox:s.originX * scaleX,
				oy:s.originY * scaleY
			};
		}
	}
}