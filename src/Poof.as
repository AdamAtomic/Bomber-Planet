package
{
	import org.flixel.FlxSprite;
	
	public class Poof extends FlxSprite
	{
		[Embed(source="data/poof.png")] static public var ImgPoof:Class;
		
		public function Poof()
		{
			super();
			loadGraphic(ImgPoof,true);
			addAnimation("poof",[0,1,2,3],12,false);
		}
		
		override public function update():void
		{
			if(finished)
				kill();
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			super.reset(X,Y);
			play("poof",true);
		}
	}
}