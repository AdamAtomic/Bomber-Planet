package
{
	import org.flixel.*;
	
	public class StoryState extends FlxState
	{
		[Embed(source="data/stars.png")] static public var ImgStars:Class;
		
		public var ok:Boolean;
		public var text:FlxText;
		
		override public function create():void
		{
			ok = false;
			FlxG.flash(0xff000000,5);
			
			add(new FlxSprite(0,0,ImgStars));
			
			text = new FlxText(40,FlxG.height,FlxG.width-80,"Crashing on this island was about the best I could hope for, given the condition of the ship.  According to my records there should be an abandoned spacepad on a mountain nearby.  My best chance for escape lies in locating this spacepad...\n\n...if it even exists.\n\nThankfully, my suit's speed boosters still work (X) and I might be able to use these spent fuel cells to help get by obstacles (C).\n\nLet's see what's out there...");
			text.velocity.y = -10;
			add(text);
		}
		
		override public function update():void
		{
			super.update();
			
			if((text.y < 0) || FlxG.keys.any())
				FlxG.fade(0xff000000,1,skip);
		}
		
		public function skip():void
		{
			FlxG.switchState(new PlayState());
		}
	}
}