package efc.walker;

import flambe.Component;

import efc.body.BodyBurger;

class WalkerState extends Component
{
	public function new(body :BodyBurger, stateManager :WalkerStateManager) : Void
	{
		_body = body;
		_stateManager = stateManager;
	}

	public function update(dt :Float)  : Void{}

	public function moveDown(dt :Float, isFresh :Bool)  : Void{}

	private var _body             :BodyBurger;
	private var _veclocityDown    :Float = 80.0;
	private var _veclocityForward :Float = 100.0;
	private var _stateManager     :WalkerStateManager;
}