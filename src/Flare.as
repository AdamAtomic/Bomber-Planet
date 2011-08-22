package
{
	import org.flixel.*;
	
	public class Flare extends FlxSprite
	{
		[Embed(source="data/flare.png")] static public var ImgFlare:Class;
		[Embed(source="data/flare.mp3")] static public var SndFlare:Class;
		
		public function Flare(X:Number=0, Y:Number=0)
		{
			super(X, Y, ImgFlare);
			velocity.y = -150;
			angularVelocity = 800;
			FlxG.play(SndFlare,0.65);
		}
		
		override public function update():void
		{
			scale.y += FlxG.elapsed*2;
			scale.x = scale.y;
		}
	}
}