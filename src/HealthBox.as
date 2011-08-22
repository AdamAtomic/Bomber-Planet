package
{
	import org.flixel.FlxSprite;
	
	public class HealthBox extends FlxSprite
	{
		[Embed(source="data/healthbox.png")] static public var ImgHealthBox:Class;
		
		public function HealthBox()
		{
			super();
			loadGraphic(ImgHealthBox,true);
			scrollFactor.x = scrollFactor.y = 0;
			y = 0;
			solid = false;
			moves = false;
		}
	}
}