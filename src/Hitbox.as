package
{
	import org.flixel.*;
	
	public class Hitbox extends FlxObject
	{
		public var timeout:Number;
		
		public function Hitbox()
		{
			super();
		}
		
		override public function update():void
		{
			timeout -= FlxG.elapsed;
			if(timeout <= 0)
				kill();
		}
		
		public function resetHitbox(X:Number, Y:Number, Width:Number=0, Height:Number=0):void
		{
			reset(X,Y);
			width = Width;
			height = Height;
			timeout = 0.25;
		}
	}
}