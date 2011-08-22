package
{
	import org.flixel.*;
	
	public class Block extends FlxSprite
	{
		[Embed(source="data/block.png")] static public var ImgBlock:Class;
		
		public function Block(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			loadGraphic(ImgBlock,true);
			immovable = true;
		}
		
		override public function kill():void
		{
			super.kill();
			exists = true;
			visible = true;
			frame = 1;
			solid = false;
			
			var bb:FlxEmitter = (FlxG.state as PlayState).blockbits;
			bb.at(this);
			bb.start(true,0.65,0,8);
			bb.update(); //cheating!!
			
			if(FlxG.random()<0.35)
				(FlxG.state as PlayState).spawnPowerup(x,y);
		}
	}
}