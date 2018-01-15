package kha2dUtils;

import kha.Color;
import kha.graphics2.Graphics;
import kha.Image;
import kha.math.FastMatrix3;
import kha.math.Matrix3;
import kha.math.Vector2;

typedef RenderData = {x:Float, y:Float, r:Float, sx:Float, sy:Float, ox:Float, oy:Float};

@:expose
class Sprite {
	private var image: Image;
	private var animation: Animation;
	private var collider: Rectangle;
	
	public var x: Float;
	public var y: Float;
	public var speedx: Float;
	public var speedy: Float;
	public var accx: Float;
	public var accy: Float;
	public var maxspeedy: Float;
	public var collides: Bool;
	public var z: Int;
	public var removed: Bool = false;
	public var rotation: Float = 0.0;
	public var originX(default, set): Float = 0.0;
	public var originY(default, set): Float = 0.0;
	
	public var scaleX(default, set): Float = 1;
	public var scaleY(default, set): Float = 1;
	public var visible: Bool = true;
	
	var w: Float;
	var h: Float;
	var tempcollider: Rectangle;
	
	
	public var aFrame:Rectangle;
	
	public var divOriginX:Float = .0;
	public var divOriginY:Float = .0;
	public var frame:Rectangle = null;
	var rgb = {r:255, g:255, b:255};
	public var alpha:Float = 1.0;
	
	public var name:String;
	
	public var data:Dynamic;
	
	public var renderData:RenderData;
	
	public var parent:Dynamic = null;
	
	public var isAddedToScene:Bool = false;
	
	
	
	function set_scaleX(scale:Float)
	{
		scaleX = scale;
		return scale;
	}
	
	function set_scaleY(scale:Float)
	{
		scaleY = scale;
		return scale;
	}
	
	function set_originX(originX:Float)
	{
		if(width != 0) divOriginX = originX / width;
		this.originX = originX;
		return originX;
	}
	
	function set_originY(originY:Float)
	{
		if(height != 0) divOriginY = originY / height;
		this.originY = originY;
		return originY;
	}
	
	
	public function setColor(r:Int, g:Int, b:Int)
	{
		rgb.r = r;
		rgb.g = g;
		rgb.b = b;
	}
	
	public function new(image: Image, frame:Rectangle = null, width: Int = 0, height: Int = 0, z: Int = 1) 
	{
		this.image = image;
		x = 0;
		y = 0;
		
		aFrame = new Rectangle();
		
		if (frame == null)
		{
			frame = new Rectangle(x, y, image.width, image.height);
		}
		
		h = height;
		w = width;
		this.frame = frame;
		this.width = frame.width;
		this.height = frame.height;
		
		this.z = z;
		collider = new Rectangle(0, 0, this.width, this.height);
		speedx = speedy = 0;
		accx = 0;
		accy = 0.2;
		animation = Animation.create(0);
		maxspeedy = 5.0;
		collides = true;
		tempcollider = new Rectangle(0, 0, 0, 0);
	}
	
	// change sprite x,y, width, height as collisionrect and add a image rect
	public function collisionRect(): Rectangle {
		tempcollider.x = x;
		tempcollider.y = y;
		tempcollider.width  = collider.width * scaleX;
		tempcollider.height = collider.height * scaleY;
		return tempcollider;
	}
	
	public function setAnimation(animation: Animation): Void {
		this.animation.take(animation);
	}
	
	public function update(): Void {
		animation.next();
		
	}
	
	
	
	
	public function render(g: Graphics): Void {
		
		var d = renderData;
		if (d == null)
		{
			d = {x:x, y:y, r:rotation, sx:scaleX, sy:scaleY, ox:originX, oy:originY};
		}
		
		if (image != null && visible && alpha > 0 && Math.abs(d.sx) > .001 && Math.abs(d.sy) > .001) {
			
			
			
			g.color = Color.fromBytes(rgb.r, rgb.g, rgb.b, Math.round(255 * alpha));
			
			
			
			/*scaleX = d.sx;
			scaleY = d.sy;*/
			
			originX = width * divOriginX;
			originY = height * divOriginY;
			
			
			if (d.r != 0)
			{
				g.pushTransformation(g.transformation
				.multmat(FastMatrix3.translation((d.x + originX) - width * divOriginX, (d.y + originY) - height * divOriginY))
				.multmat(FastMatrix3.rotation(d.r)).multmat(FastMatrix3.translation(( -d.x - originX), ( -d.y - originY))));
				
				g.drawScaledSubImage(image, frame.x, frame.y, 
				w, h, Math.round(d.x - collider.x * d.sx), Math.round(d.y - collider.y * d.sy), width * d.sx / scaleX, height * d.sy / scaleY);
				
				g.popTransformation();
			}
			
			else g.drawScaledSubImage(image, frame.x, frame.y, 
			w, h, Math.round(d.x - collider.x * d.sx) - width * divOriginX, Math.round(d.y - collider.y * d.sy) - height * divOriginY, width * d.sx / scaleX, height * d.sy / scaleY);
			
			//if (d.r != 0) g.popTransformation();
		}
		#if debug_collisions
			g.color = Color.fromBytes(255, 0, 0);
			g.drawRect(x - collider.x * scaleX, y - collider.y * scaleY, width, height);
			g.color = Color.fromBytes(0, 255, 0);
			g.drawRect(tempcollider.x, tempcollider.y, tempcollider.width, tempcollider.height);
		#end
	}
	
	public function hitFrom(dir: Direction): Void {
		
	}
	
	public function hit(sprite: Sprite): Void {
		
	}
	
	public function setImage(image: Image): Void {
		this.image = image;
	}
	
	public function outOfView(): Void {
		
	}
	
	function get_width(): Float {
		return w * scaleX;
	}
	
	function set_width(value: Float): Float {
		return w = value;
	}
	
	public var width(get, set): Float;
	
	function get_height(): Float {
		return h * scaleY;
	}
	
	function set_height(value: Float): Float {
		return h = value;
	}
	
	public var height(get, set): Float;
	
	public function setPosition(pos : Vector2) {
		x = pos.x;
		y = pos.y;
	}
}