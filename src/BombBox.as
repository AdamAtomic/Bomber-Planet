package
{
	import org.flixel.FlxSprite;
	
	public class BombBox extends FlxSprite
	{
		[Embed(source="data/bombbox.png")] static public var ImgBombBox:Class;
		
		public function BombBox()
		{
			super();
			loadGraphic(ImgBombBox,true);
			scrollFactor.x = scrollFactor.y = 0;
			y = 0;
			solid = false;
			moves = false;
		}
	}
}