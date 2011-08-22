package
{
	import org.flixel.*;
	
	public class Powerup extends FlxSprite
	{
		[Embed(source="data/powerups.png")] static public var ImgPowerups:Class;
		[Embed(source="data/bomb_up.mp3")] static public var SndBomb:Class;
		[Embed(source="data/health_up.mp3")] static public var SndHealth:Class;
		[Embed(source="data/health_refill.mp3")] static public var SndHealthRefill:Class;
		
		public var sounds:Array;
		public var index:uint;
		
		public function Powerup()
		{
			super();
			loadGraphic(ImgPowerups,true);
			sounds = new Array(SndBomb,SndHealth,SndHealthRefill);
			index = 0;
		}

		public function resetPowerup(X:Number, Y:Number, Type:uint, Index:uint=0):void
		{
			reset(X,Y);
			frame = Type;
			index = Index;
		}
		
		override public function kill():void
		{
			super.kill();
			FlxG.play(sounds[frame],0.65);
			if(frame == 1) //health increase
			{
				FlxG.levels[index] = true;
				
				var save:FlxSave = new FlxSave();
				if(save.bind("escape"))
				{
					save.data["health"][index.toString()] = true;
					save.close();
				}
			}
		}
	}
}