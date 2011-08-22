package
{
	import org.flixel.*;
	
	public class CameraHelper extends FlxSprite
	{
		protected var _player:Player;
		protected var _target:FlxPoint;
		
		public function CameraHelper(PlayerRef:Player)
		{
			super();
			_player = PlayerRef;
			_target = new FlxPoint();
			checkTarget();
			x = _target.x - width*0.5;
			y = _target.y - height*0.5;
			path = new FlxPath(new Array(new FlxPoint(),new FlxPoint()));
		}
		
		override public function update():void
		{
			preUpdate();
			
			if(pathSpeed == 0)
			{
				velocity.x = velocity.y = 0;
				checkTarget();
				if((x + width*0.5 != _target.x) || (y + height*0.5 != _target.y))
				{
					path.nodes[0].x = x + width*0.5;
					path.nodes[0].y = y + height*0.5;
					path.nodes[1].x = _target.x;
					path.nodes[1].y = _target.y;
					followPath(path,300);
				}
			}
			
			postUpdate();
		}
		
		protected function checkTarget():void
		{
			var px:int = _player.x;
			if(_player.velocity.x < 0)
				px += 16;
			var py:int = _player.y;
			if(_player.velocity.y < 0)
				py += 16;
			_target.x = int(px/FlxG.width)*FlxG.width + FlxG.width*0.5;
			_target.y = int(py/FlxG.height)*FlxG.height + FlxG.height*0.5;
		}
	}
}