package efc.walker;

import efc.body.BodyBurger;
import flambe.Entity;
import flambe.Disposer;
import flambe.script.*;
import flambe.animation.Ease;
import flambe.animation.AnimatedFloat;
import flambe.asset.AssetPack;

class WalkerState_Ground extends WalkerState
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
	override public function moveDown(dt :Float, isFresh :Bool) : Void
	{
		super.moveDown(dt, isFresh);
		_body.body.velocity.y += _veclocityDown;
	}

	private var _container :Entity;
}