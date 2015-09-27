package efc.walker;

import flambe.Component;
import flambe.asset.AssetPack;

import efc.body.BodyBurger;

class WalkerState extends Component
{
	public function new(body :BodyBurger, stateManager :WalkerStateManager, pack :AssetPack) : Void
	{
		_body = body;
		_stateManager = stateManager;
		_pack = pack;
	}

	public function update(dt :Float)  : Void{}

	public function moveDown(dt :Float, isFresh :Bool)  : Void
	{
		if(isFresh) {
			var index = Math.floor(Math.random() * sounds.length);
			_pack.getSound("sound/" + sounds[index]).play(2);
		}
	}

	private var sounds = [
		"cute1",
		"cute2",
		"cute3",
		"cute4"
	];

	private var _body             :BodyBurger;
	private var _veclocityDown    :Float = 130.0;
	private var _veclocityForward :Float = 100.0;
	private var _stateManager     :WalkerStateManager;
	private var _pack             :AssetPack;
}