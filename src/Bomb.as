package
{
	import org.flixel.*;
	
	public class Bomb extends FlxSprite
	{
		[Embed(source="data/bomb.png")] static public var ImgBomb:Class;
		[Embed(source="data/bomb_place.mp3")] static public var SndPlace:Class;
		[Embed(source="data/bomb_explode.mp3")] static public var SndExplode:Class;
		
		public var timeout:Number;
		
		public function Bomb()
		{
			super();
			loadGraphic(ImgBomb,true);
			addAnimation("tick",[0,1,2,3],2,false);
			immovable = true;
		}
		
		override public function update():void
		{
			timeout -= FlxG.elapsed;
			if(timeout <= 0)
				kill();
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			super.reset(X,Y);
			play("tick");
			timeout = 2;
			FlxG.play(SndPlace,0.5);
		}
		
		override public function kill():void
		{
			super.kill();
			
			FlxG.play(SndExplode,0.35);
			((FlxG.state as PlayState).hitboxes.recycle(Hitbox) as Hitbox).resetHitbox(x-12,y-12,40,40);
			((FlxG.state as PlayState).poofs.recycle(Poof) as Poof).reset(x-16,y-16);
			FlxG.camera.shake(0.01,0.2);
			
			free();
		}
		
		public function free():void
		{
			(FlxG.state as PlayState).player.bombsInc();
		}
	}
}