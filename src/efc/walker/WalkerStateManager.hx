package efc.walker;

import flambe.Entity;
import flambe.Component;
import flambe.asset.AssetPack;

import efc.body.BodyBurger;

class WalkerStateManager extends Component
{
	public var state (default, null) : WalkerState;

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	public function new(body :BodyBurger, pack :AssetPack) : Void
	{
		_body = body;
		_pack = pack;
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	override public function onUpdate(dt :Float) : Void
	{
		if(_body.body.shapes.length < 1)
			return;

		if(_body.inOnBody())
			state = _stateMap.get(Ground);
		else
			state = _stateMap.get(Air);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	override public function onStart() : Void
	{
		addState(owner, Air);
		addState(owner, Ground);
		
		this.state = _stateMap.get(Ground);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	public function setState(state :E_State) : Void
	{
		this.state = _stateMap.get(state);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	private function addState(e :Entity, e_state :E_State) : Void
	{
		var walkerState :WalkerState;
		switch (e_state) {
			case Air: walkerState = new WalkerState_Air(_body, this, _pack);
			case Ground: walkerState = new WalkerState_Ground(_body, this, _pack);
		}
		_stateMap.set(e_state, walkerState);
		e.addChild(new Entity().add(walkerState));
	}

	private var _body     :BodyBurger;
	private var _pack     :AssetPack;
	private var _stateMap = new Map<E_State, WalkerState>();
}

enum E_State
{
	Air;
	Ground;
}