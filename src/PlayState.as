package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source="data/map.png")] static public var ImgMap:Class;
		[Embed(source="data/tiles.png")] static public var ImgTiles:Class;
		[Embed(source="data/footsteps.png")] static public var ImgFootsteps:Class;
		[Embed(source="data/blockbits.png")] static public var ImgBlockBits:Class;
		[Embed(source="data/music.mp3")] static public var SndMusic:Class;
		[Embed(source="data/launchpad.png")] static public var ImgLaunchpad:Class;
		[Embed(source="data/shipwreck.png")] static public var ImgShipwreck:Class;
		
		public var map:FlxTilemap;
		public var player:Player;
		public var bombs:FlxGroup;
		public var footsteps:FlxEmitter;
		public var cameraHelper:CameraHelper;
		public var blocks:FlxGroup;
		public var enemies:FlxGroup;
		
		public var solidStuff:FlxGroup;
		public var movingStuff:FlxGroup;
		
		public var vulnerable:FlxGroup;
		public var hitboxes:FlxGroup;
		
		public var poofs:FlxGroup;
		public var blockbits:FlxEmitter;
		
		public var healthBoxes:FlxGroup;
		public var bombBoxes:FlxGroup;
		
		public var powerups:FlxGroup;
		
		public var launchpad:FlxSprite;
		public var foundLaunchpad:Boolean;
		
		override public function create():void
		{
			FlxG.bgColor = 0xff24323f;
			
			player = new Player();
			
			//Processing the map data to get trap locations before making a simple collision/pathfinding hull		
			var emptyColor:uint = 0xff000000;
			var blockColor:uint = 0xff3c565c;
			var healthColor:uint = 0xff24323f;
			var enemyColor:uint = 0xffffffff;
			var mapSprite:FlxSprite = new FlxSprite(0,0,ImgMap);
			var blockLocations:Array = mapSprite.replaceColor(blockColor,emptyColor,true);
			blocks = new FlxGroup();
			addBlocks(blockLocations);
			var enemyLocations:Array = mapSprite.replaceColor(enemyColor,emptyColor,true);
			enemies = new FlxGroup();
			addEnemies(enemyLocations);
			var healthLocations:Array = mapSprite.replaceColor(healthColor,emptyColor,true);
			powerups = new FlxGroup();
			addHealthUps(healthLocations);
			
			//Create a color map of the different world zones
			var clrStart:uint = 0xa7702d;
			var clrForest:uint = 0x529023;
			var clrGrass:uint = 0xa6cd33;
			var clrDesert:uint = 0xea903e;
			var clrBeach:uint = 0xf7e176;
			var clrRed:uint = 0xbe3241;
			var clrIce:uint = 0x3ea5f2;
			var clrPink:uint = 0xdf7a92;
			var clrNight:uint = 0x00648c;
			var clrMountain:uint = 0x574a38;
			var clrPeak:uint = 0xa1a1a1;
			var clrWater:uint = 0xb3dbee;
			var colorMap:Array = new Array(	0, clrStart, clrForest, clrGrass, clrDesert, clrBeach, clrRed,
											clrIce, clrPink, clrNight, clrMountain, clrPeak, clrWater );
			
			//Then load the map auto-indexed to our tile map based on those colors
			map = new FlxTilemap().loadMap(FlxTilemap.bitmapToCSV(mapSprite.pixels,false,1,colorMap),ImgTiles);
			add(map);
			
			var ship:FlxSprite = new FlxSprite(119*16,112*16,ImgShipwreck);
			ship.immovable = true;
			add(ship);
			
			footsteps = new FlxEmitter();
			footsteps.makeParticles(ImgFootsteps,50,0,true,0);
			footsteps.setRotation();
			footsteps.setXSpeed(0);
			footsteps.setYSpeed(0);
			footsteps.gravity = 0;
			footsteps.start(false,0,0.15);
			add(footsteps);
			
			foundLaunchpad = false;
			launchpad = new FlxSprite(118*16,27*16,ImgLaunchpad);
			add(launchpad);
			
			add(blocks);
			
			add(enemies);
			
			bombBoxes = new FlxGroup();
			healthBoxes = new FlxGroup();
			
			add(player);

			add(powerups);
			
			bombs = new FlxGroup();
			add(bombs);
			
			solidStuff = new FlxGroup();
			solidStuff.add(blocks);
			solidStuff.add(bombs);
			solidStuff.add(map);
			
			movingStuff = new FlxGroup();
			movingStuff.add(player);
			movingStuff.add(enemies);
			
			vulnerable = new FlxGroup();
			vulnerable.add(blocks);
			vulnerable.add(player);
			vulnerable.add(enemies);
			vulnerable.add(bombs);
			
			hitboxes = new FlxGroup();
			add(hitboxes);
			
			blockbits = new FlxEmitter();
			blockbits.makeParticles(ImgBlockBits,40,64,true,0);
			blockbits.setRotation(-720,720);
			blockbits.setYSpeed(-300,-150);
			blockbits.setXSpeed(-200,200);
			blockbits.gravity = 800;
			add(blockbits);
			
			poofs = new FlxGroup();
			add(poofs);
			
			//drawn on top since its the hud
			add(healthBoxes);
			add(bombBoxes);
			
			//camera helper figures out when and where to scroll but shouldn't be added to state
			cameraHelper = new CameraHelper(player);
			FlxG.camera.follow(cameraHelper);
			
			FlxG.playMusic(SndMusic,0.35);
			FlxG.flash(0xff000000,1);
		}
		
		override public function update():void
		{
			//DEBUG: CTRL+SHIFT+E erases the local saved data & restarts the game
			if(FlxG.keys.CONTROL && FlxG.keys.SHIFT && FlxG.keys.E)
			{
				MenuState.eraseData();
				FlxG.resetState();
			}
			
			if(cameraHelper.pathSpeed == 0)
			{
				FlxG.worldBounds.x = FlxG.camera.scroll.x-10;
				FlxG.worldBounds.y = FlxG.camera.scroll.y-10;
					
				super.update();
				
				footsteps.at(player);
				footsteps.y += 4;
				
				FlxG.collide(solidStuff,movingStuff);
				if(hitboxes.countLiving() > 0)
					FlxG.overlap(vulnerable,hitboxes,null,onHitbox);
				FlxG.overlap(enemies,player,null,onEnemyPlayer);
				FlxG.overlap(powerups,player,null,onPowerup);
				
				if(player.overlaps(launchpad))
				{
					if(!foundLaunchpad)
					{
						FlxG.music.fadeOut(3);
						foundLaunchpad = true;
					}
					player.launchpad = true;
				}
				else
					player.launchpad = false;
			}
			cameraHelper.update();
		}
		
		public function addBlocks(Locations:Array):void
		{
			var l:int = Locations.length;
			while(l--)
				blocks.add(new Block(Locations[l].x*16,Locations[l].y*16));
		}
		
		public function addEnemies(Locations:Array):void
		{
			var l:int = Locations.length;
			while(l--)
				enemies.add(new Enemy(Locations[l].x*16,Locations[l].y*16));
		}
		
		public function addHealthUps(Locations:Array):void
		{
			var p:Powerup;
			var l:int = Locations.length;
			
			if(FlxG.levels.length <= 0) //no in-memory save data at the moment
			{
				var i:uint;
				for(i = 0; i < l; i++)
					FlxG.levels[i] = false;
				
				//check the local shared session to see if there's any data
				var save:FlxSave = new FlxSave();
				if(save.bind("escape"))
				{
					if(save.data["health"] == null)
					{
						//no data found, so create new data
						save.data["health"] = new Object();
						for(i = 0; i < l; i++)
							save.data["health"][i.toString()] = false;
					}
					else
					{
						//a ha!  data found - update our local copy
						for(i = 0; i < l; i++)
							FlxG.levels[i] = save.data["health"][i.toString()];
					}
					save.close();
				}
			}

			while(l--)
			{
				if(FlxG.levels[l])
				{
					//copy pasta from onPowerup()
					player.maxHealth += 2;
					player.health = player.maxHealth;
				}
				else
				{
					p = new Powerup();
					p.resetPowerup(Locations[l].x*16,Locations[l].y*16,1,l);
					powerups.add(p);
				}
			}
		}
		
		public function onHitbox(A:FlxObject,B:FlxObject):void
		{
			if(A is Hitbox)
				B.hurt(1);
			else
				A.hurt(1);
		}
		
		public function onEnemyPlayer(A:FlxObject,B:FlxObject):void
		{
			if(A is Player)
				A.hurt(1);
			else
				B.hurt(1);
		}
		
		public function onPowerup(A:FlxObject,B:FlxObject):void
		{
			var powerup:Powerup;
			if(A is Powerup)
				powerup = A as Powerup;
			else
				powerup = B as Powerup;
			if((powerup.frame == 0) && player.maxBombs < 5)
			{
				player.maxBombs++;
				player.bombs = player.maxBombs;
				updateBombHUD();
			}
			else if(powerup.frame == 1)
			{
				player.maxHealth += 2;
				player.health = player.maxHealth;
				updateHealthHUD();
			}
			else if(powerup.frame == 2)
			{
				player.health++;
				if(player.health > player.maxHealth)
					player.health = player.maxHealth;
				updateHealthHUD();
			}
			powerup.kill();
		}
		
		public function updateHealthHUD():void
		{
			var Health:Number = player.health;
			var MaxHealth:Number = player.maxHealth;
			
			var numBoxes:uint = FlxU.ceil(MaxHealth*0.5);
			while(healthBoxes.length < numBoxes)
				healthBoxes.add(new HealthBox());
			
			var i:uint = 0;
			var l:uint = healthBoxes.length;
			var healthbox:HealthBox;
			while(i < l)
			{
				healthbox = healthBoxes.members[i++];
				healthbox.frame = ((Health>2)?2:((Health<0)?0:Health));
				Health -= 2;
				healthbox.x = FlxG.width - (l+1-i)*12 - 4;
			}
		}
		
		public function updateBombHUD():void
		{
			var Bombs:int = player.bombs;
			var MaxBombs:int = player.maxBombs;
			
			while(bombBoxes.length < MaxBombs)
				bombBoxes.add(new BombBox());
			
			var i:uint = 0;
			var l:uint = bombBoxes.length;
			var bombbox:BombBox;
			while(i < l)
			{
				bombbox = bombBoxes.members[i++];
				bombbox.frame = ((Bombs>1)?1:((Bombs<0)?0:Bombs));
				Bombs--;
				bombbox.x = (i-1)*12;
			}
		}
		
		public function spawnPowerup(X:Number,Y:Number):void
		{
			//0 = bomb up
			//1 = health up
			//2 = health
			var type:uint;
			if(FlxG.random() < 0.15)
				type = 0;
			else
				type = 2;
			(powerups.recycle(Powerup) as Powerup).resetPowerup(X,Y,type);
		}
	}
}
