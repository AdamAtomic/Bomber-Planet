package
{
	import org.flixel.*;
	[SWF(width="512", height="512", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class ESC extends FlxGame
	{
		public function ESC()
		{
			super(256,256,MenuState,2,30,30);
		}
	}
}
