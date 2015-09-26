package efc.walker;

import efc.body.BodyBurger;
import flambe.Entity;
import flambe.Disposer;
import flambe.script.*;
import flambe.animation.Ease;
import flambe.animation.AnimatedFloat;

class WalkerState_Ground extends WalkerState
{

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	public function new(body :BodyBurger, stateManager :WalkerStateManager) :Void
	{
		super(body, stateManager);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	override public function moveDown(dt :Float, isFresh :Bool) : Void
	{
		_body.body.velocity.y += _veclocityDown;
	}

	private var _container :Entity;
}