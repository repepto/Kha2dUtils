package kha2dUtils;

import kha.Scheduler;
import kha2dUtils.Atlas;
import kha2dUtils.Sprite;

/**
 * ...
 * @author Sergii
 */

 enum PlayModes {
  Normal;
  Reversed;
}

class MovieClip
{
	var playDirection:Int = 1;
	var playMode:PlayModes = Normal;
	
	public var frames:Array<Sprite>;
	var currentFrame:Int = 0;
	
	var nextFrameTimer:Float = .1;
	var elapsedTime:Float = 0;
	var previousTime:Float = 0;
	
	var isLooped:Bool;
	var disposeAfterFinish:Bool;
	var isPaused:Bool = false;
	
	public var x:Float;
	public var y:Float;
	public var z(default, set):Int;
	
	public var rotation:Float = 0;
	public var scaleX:Float = 1;
	public var scaleY:Float = 1;
	
	public var width:Float;
	public var height:Float;

	public function new(atlas:Atlas, name:String = "anim", fps:UInt = 18, isLooped:Bool = false, disposeAfterFinish:Bool = true) 
	{
		nextFrameTimer = 1 / fps;
		
		this.isLooped = isLooped;
		this.disposeAfterFinish = disposeAfterFinish;
		
		frames = atlas.getMovieClip(name);
		if (frames == null) throw "there is no sequnce '${name}'.";
		
		setOrigins();
		
		for (f in frames)
		{
			f.visible = false;
			f.parent = this;
		}
		frames[0].visible = true;
		
		width = frames[0].aFrame.width;
		height = frames[0].aFrame.height;
	}
	
	public function set_z(z:Int)
	{
		this.z = z;
		for (s in frames)
		{
			s.z = z;
		}
		return z;
	}
	
	public function setOrigins(x:Float = 0, y:Float = 0)
	{
		for (f in frames)
		{
			f.originX = x + f.aFrame.x;
			f.originY = y + f.aFrame.y;
		}
	}
	
	public function setZindex(z:UInt = 0)
	{
		for (f in frames)
		{
			f.z = z;
		}
	}
	
	public function setPlayMode(reversed:Bool = false)
	{
		reversed?playDirection = -1:playDirection = 1;
	}
	
	public function play(f:Int = -1)
	{
		isPaused = false;
		if (f > -1) 
		{
			frames[currentFrame].visible = false;
			currentFrame = f - 1;
		}
	}
	
	public function stop()
	{
		isPaused = true;
	}
	
	public function dispose()
	{
		for (f in frames)
		{
			Scene.the.removeHero(f);
		}
		
		Scene.the.removeMovieClip(this);
		
		frames = null;
	}
	
	public function update()
	{
		if (isPaused) return;
		
		var currentTime:Float = Scheduler.time();
		var deltaTime:Float = (currentTime - previousTime);
		previousTime = currentTime;
		
		elapsedTime+= deltaTime;
		
		if (elapsedTime >= nextFrameTimer)
		{
			elapsedTime = 0;
			
			if(currentFrame > -1) frames[currentFrame].visible = false;
			if (currentFrame == frames.length - 1) currentFrame = -1;
			
			//trace(frames[currentFrame].rotation);
			currentFrame ++;
			frames[currentFrame].visible = true;
		}
	}
}