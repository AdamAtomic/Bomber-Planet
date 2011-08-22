package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		[Embed(source="data/title.png")] static public var ImgTitle:Class;
		[Embed(source="data/star_particles.png")] static public var ImgStars:Class;
		
		public var clickText:FlxText;
		public var blinkTimer:Number;
		
		override public function create():void
		{
			var emitter:FlxEmitter = new FlxEmitter();
			emitter.makeParticles(ImgStars,200,0,true,0);
			emitter.width = FlxG.width;
			emitter.y = FlxG.height;
			emitter.setYSpeed(-100,-20);
			emitter.setXSpeed();
			emitter.setRotation();
			emitter.start(false,0,0.1);
			add(emitter);
			
			add(new FlxSprite(0,0,ImgTitle));
			
			var t:FlxText;
			t = new FlxText(0,2,FlxG.width,"a 48-hour game by Adam 'Atomic' Saltsman");
			t.alignment = "center";
			t.color = 0x00648c;
			add(t);
			
			clickText = new FlxText(FlxG.width/2-50,FlxG.height-111,100,"CLICK TO PLAY");
			clickText.alignment = "center";
			add(clickText);
			blinkTimer = 0;
			
			FlxG.mouse.show();
		}

		override public function update():void
		{
			super.update();

			if(FlxG.mouse.justPressed())
			{
				FlxG.mouse.hide();
				FlxG.fade(0xff000000,1,onFade);
				clickText.exists = false;
			}
			
			if(clickText.exists)
			{
				blinkTimer += FlxG.elapsed;
				if(blinkTimer - int(blinkTimer) < 0.2)
					clickText.visible = false;
				else
					clickText.visible = true;
			}
		}
		
		public function onFade():void
		{
			FlxG.switchState(new StoryState());
		}
		
		static public function eraseData():void
		{
			var save:FlxSave = new FlxSave();
			if(save.bind("escape"))
				save.erase();
			for(var i:uint = 0; i < FlxG.levels.length; i++)
				FlxG.levels[i] = false;
		}
	}
}
