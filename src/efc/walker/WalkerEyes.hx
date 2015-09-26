package efc.walker;

import flambe.Entity;
import flambe.Component;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.script.*;
import flambe.math.FMath;

class WalkerEyes extends Component
{
	public function new(pack :AssetPack) : Void
	{
		_pack = pack;
	}

	override public function onUpdate(dt :Float) : Void
	{
		blink(dt);
	}

	override public function onAdded() : Void
	{
		var parentSpr = owner.get(Sprite);
		owner.addChild(_container);
		_container.add(_eyes = cast new ImageSprite(_pack.getTexture("eyes"))
			.centerAnchor()
			.setXY(48, 62));
	}

	public function scaleEyes(amount :Float) :Void
	{
		if(_isBlinking)
			return;
	}

	private function blink(dt :Float) : Void
	{
		_elapsedB += dt;

		if(_elapsedB > _durationB) {
			_isBlinking = true;
			_container.add(new Script()).get(Script).run(new Sequence([
				new AnimateTo(_eyes.scaleY, 0, 0.1625),
				new AnimateTo(_eyes.scaleY, 1, 0.1625),
				new CallFunction(function() {
					_isBlinking = false;
				})
			]));
			_elapsedB = 0;
			_durationB = 3 + Math.random()*7;
		}
	}

	private var _pack       :AssetPack;
	private var _container  :Entity = new Entity();
	private var _eyes       :ImageSprite;
	private var _isBlinking :Bool = false;

	private var _durationB :Float = 6;
	private var _elapsedB  :Float = 0;
}