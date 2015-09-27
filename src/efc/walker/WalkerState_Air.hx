package efc.walker;

import efc.body.BodyBurger;
import flambe.Entity;
import flambe.Disposer;
import flambe.script.*;
import flambe.animation.Ease;
import flambe.animation.AnimatedFloat;
import flambe.asset.AssetPack;

import deadlyCute.Scaler;

class WalkerState_Air extends WalkerState
{

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	public function new(body :BodyBurger, stateManager :WalkerStateManager, pack :AssetPack) :Void
	{
		super(body, stateManager, pack);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	override public function update(dt :Float) : Void
	{
		var curY = _body.body.position.y;
		if(curY > _lastY) {
			owner.getFromParents(Scaler).shrink(dt);
		}
		_lastY = curY;
	}
	
	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	override public function moveDown(dt :Float, isFresh :Bool) : Void
	{
		super.moveDown(dt, isFresh);
		_body.body.velocity.y += _veclocityDown;
	}

	private var _container  :Entity;
	private var _lastY = 0.0;
}