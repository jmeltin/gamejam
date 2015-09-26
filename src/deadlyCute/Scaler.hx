package deadlyCute;

import flambe.Entity;
import flambe.Component;
import flambe.asset.AssetPack;
import flambe.display.Sprite;
import flambe.swf.Library;
import flambe.swf.MoviePlayer;

import efc.body.MovieBody;

class Scaler extends Component {

	public function new() : Void
	{
	}

	override public function onStart() : Void
	{
		_sprite = owner.get(Sprite);
		if(_sprite == null)
			owner.add(_sprite = new Sprite());
	}

	public function shrink(dt :Float) : Void
	{
	}

	public function reset() : Void
	{
		_sprite.setScale(1);
	}




	private var _sprite :Sprite;

}