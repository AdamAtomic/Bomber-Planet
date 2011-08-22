package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="data/player.png")] static public var ImgPlayer:Class;
		[Embed(source="data/hurt.mp3")] static public var SndHurt:Class;
		
		public var target:int;
		public var moving:uint;
		public var walkSpeed:Number;
		public var restartTimeout:Number;
		public var maxHealth:Number;
		
		public var bombs:int;
		public var maxBombs:int;
		
		public var updated:Boolean;
		
		public var launchpad:Boolean;
		public var firedFlare:Boolean;
		
		public function Player()
		{
			super(119*16+8,115*16); //starting tile - may change!
			loadGraphic(ImgPlayer,true,true);
			
			var walkFR:Number = 8;
			addAnimation("idle_up",[3],0,false);
			addAnimation("idle_down",[0],0,false);
			addAnimation("idle_side",[6],0,false);
			addAnimation("walk_up",[3,4,3,5],walkFR);
			addAnimation("walk_down",[0,1,0,2],walkFR);
			addAnimation("walk_side",[6,7,6,8],walkFR);
			addAnimation("dead",[9],0,false);

			moving = NONE;
			facing = DOWN;
			
			maxHealth = 2;
			health = maxHealth;
			maxBombs = 1;
			bombs = maxBombs;
			
			launchpad = false;
			firedFlare = false;
			
			updated = false;
		}
		
		override public function update():void
		{
			if(!updated)
			{
				(FlxG.state as PlayState).updateHealthHUD();
				(FlxG.state as PlayState).updateBombHUD();
				updated = true;
			}
			
			if(!alive)
			{
				restartTimeout -= FlxG.elapsed;
				if(restartTimeout <= 0)
					FlxG.resetState();
				return;
			}
			
			//WALKIN AROUND AND SHIT
			walkSpeed = 64;
			if(flickering)
				walkSpeed *= 0.5;
			else if(FlxG.keys.X)
				walkSpeed *= 2;
			if(touching)
			{
				moving = NONE;
				velocity.x = velocity.y = 0;
			}
			if(moving == NONE)
				queryAll();
			switch(moving)
			{
				case LEFT:
					queryLeft();
					if(x <= target)
					{
						x = target;
						moving = NONE;
						velocity.x = 0;
					}
					else
					{
						velocity.x = -walkSpeed;
						facing = LEFT;
					}
					break;
				case RIGHT:
					queryRight();
					if(x >= target)
					{
						x = target;
						moving = NONE;
						velocity.x = 0;
					}
					else
					{
						velocity.x = walkSpeed;
						facing = RIGHT;
					}
					break;
				case UP:
					queryUp();
					if(y <= target)
					{
						y = target;
						moving = NONE;
						velocity.y = 0;
					}
					else
					{
						velocity.y = -walkSpeed;
						facing = UP;
					}
					break;
				case DOWN:
					queryDown();
					if(y >= target)
					{
						y = target;
						moving = NONE;
						velocity.y = 0;
					}
					else
					{
						velocity.y = walkSpeed;
						facing = DOWN;
					}
					break;
				default:
					velocity.x = velocity.y = 0;
					break;
			}
			
			//bombs!!
			if(FlxG.keys.justPressed("C"))
			{
				if(launchpad)
				{
					if(!firedFlare)
					{
						(FlxG.state as PlayState).add(new Flare(x,y));
						firedFlare = true;
						FlxG.fade(0xff000000,5,youWon);
					}
				}
				else if(bombs > 0)
				{
					var bomb:FlxPoint = new FlxPoint();
					bomb.x = x;
					bomb.y = y;
					
					if((moving == LEFT) || (moving == RIGHT))
						bomb.x = target;
					else if((moving == UP) || (moving == DOWN))
						bomb.y = target;
					
					if(facing == LEFT)
						bomb.x -= 16;
					else if(facing == RIGHT)
						bomb.x += 16;
					else if(facing == UP)
						bomb.y -= 16;
					else if(facing == DOWN)
						bomb.y += 16;
					
					bombsDec();
					((FlxG.state as PlayState).bombs.recycle(Bomb) as Bomb).reset(bomb.x,bomb.y);
				}
			}
			
			//animation
			var suffix:String;
			if(facing == UP)
				suffix = "up";
			else if(facing == DOWN)
				suffix = "down";
			else
				suffix = "side";
			if((velocity.x != 0) || (velocity.y != 0))
				play("walk_"+suffix);
			else
				play("idle_"+suffix);
		}
		
		public function queryLeft():Boolean
		{
			if(FlxG.keys.LEFT)
			{
				moving = LEFT;
				target = snap(x-1);
				return true;
			}
			return false;
		}
		
		public function queryRight():Boolean
		{
			if(FlxG.keys.RIGHT)
			{
				moving = RIGHT;
				target = snap(x+8);
				return true;
			}
			return false;
		}
		
		public function queryUp():Boolean
		{
			if(FlxG.keys.UP)
			{
				moving = UP;
				target = snap(y-1);
				return true;
			}
			return false;
		}
		
		public function queryDown():Boolean
		{
			if(FlxG.keys.DOWN)
			{
				moving = DOWN;
				target = snap(y+8);
				return true;
			}
			return false;
		}
		
		public function queryAll():Boolean
		{
			return queryLeft() || queryRight() || queryUp() || queryDown();
		}
		
		public function snap(Value:Number):int
		{
			return int(Value/8) * 8;
		}
		
		override public function hurt(Damage:Number):void
		{
			if(flickering)
				return;
			super.hurt(Damage);
			if(alive)
				flicker();
			(FlxG.state as PlayState).updateHealthHUD();
			FlxG.play(SndHurt,0.8);
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
			FlxG.music.stop();
			restartTimeout = 2;
		}
		
		public function bombsDec():void
		{
			if(bombs > 0)
				bombs--;
			(FlxG.state as PlayState).updateBombHUD();
		}
		
		public function bombsInc():void
		{
			if(bombs < maxBombs)
				bombs++;
			(FlxG.state as PlayState).updateBombHUD();
		}
		
		public function youWon():void
		{
			FlxG.switchState(new VictoryState());
		}
	}
}