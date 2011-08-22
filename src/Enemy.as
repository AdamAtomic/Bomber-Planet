package
{
	import org.flixel.*;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source="data/enemy.png")] static public var ImgEnemy:Class;
		
		public static var midworld:FlxPoint;
		
		public var timeout:Number;
		public var speed:Number;
		
		public function Enemy(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			loadGraphic(ImgEnemy,true);
			addAnimation("walk",[0,1,0,2],8);
			addAnimation("dead",[3],0,false);
			play("walk");
			width = height = 12;
			offset.x = offset.y = 2;
			
			if(midworld == null)
				midworld = new FlxPoint(256*8.5,256*8.5);
			var ratio:Number = FlxU.getDistance(getMidpoint(),midworld)/(256*9);
			if(ratio > 1)
				ratio = 1;
			ratio *= ratio;
			
			timeout = 0;
			speed = 20 + int(ratio*120);
			health = 1 + int(ratio*5);
			
			if(health >= 4)
				color = 0xdf7a92;
			else if(health == 3)
				color = 0xbe3241;
			else if(health == 2)
				color = 0xf7e176;
			
			elasticity = 1;
		}
		
		override public function update():void
		{
			if(!alive || !onScreen())
				return;
			
			timeout -= FlxG.elapsed;
			if(timeout <= 0)
			{
				timeout = 1 + FlxG.random();
				if(velocity.x == 0)
				{
					velocity.x = speed*((FlxG.random()>0.5)?-1:1);
					velocity.y = 0;
				}
				else
				{
					velocity.x = 0;
					velocity.y = speed*((FlxG.random()>0.5)?-1:1);
				}
			}
		}
		
		override public function hurt(Damage:Number):void
		{
			if(flickering)
				return;
			super.hurt(Damage);
			if(alive)
				flicker();
		}
		
		override public function kill():void
		{
			super.kill();
			exists = true;
			visible = true;
			play("dead");
			solid = false;
			velocity.x = 0;
			velocity.y = 0;
			if(FlxG.random()<0.65)
				(FlxG.state as PlayState).spawnPowerup(x,y);
		}
	}
}