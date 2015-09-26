package efc.walker;

import flambe.Component;
import flambe.asset.AssetPack;
import flambe.display.ImageSprite;

import efc.juice.Shaker;
import efc.camera.Camera;
import efc.controller.Controller;
import efc.body.BodyBurger;

import deadlyCute.Scaler;

class Walker extends Component
{
	public var sprite (default, null) : ImageSprite;

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	public function new(pack :AssetPack) : Void
	{
		_pack = pack;
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	override public function onStart() : Void
	{
		_body = owner.get(BodyBurger);
		_body.body.userData.component = this;

		sprite = owner.get(ImageSprite);
		owner.add(_eyes = new WalkerEyes(_pack));


		owner.add(_stateManager = new WalkerStateManager(_body));
		owner.getFromParents(Camera).focusSprite = sprite;

		wireController(owner.getFromParents(Controller));
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	override public function onUpdate(dt :Float) : Void
	{
		var eyeScale = _body.distanceFromBody();
		_eyes.scaleEyes(eyeScale);


		if(_stateManager.state != null)
			_stateManager.state.update(dt);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	public function moveDown(dt :Float, isFresh :Bool) : Void
	{
		_stateManager.state.moveDown(dt, isFresh);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	@:keep public function handleBodyCallback(otherBody :nape.phys.Body) : Void
	{
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	private function flipSprite(direction :Direction) : Void
	{
		switch (direction) {
			case Left: sprite.scaleX._ = -1 * Math.abs(sprite.scaleX._);
			case Right: sprite.scaleX._ = Math.abs(sprite.scaleX._);
		}
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	private function wireController(ctrlr :Controller) : Void
	{
		ctrlr.fn_KeyDown  = moveDown;
	}

	private var _pack         : AssetPack;
	private var _body         : BodyBurger;
	private var _stateManager : WalkerStateManager;
	private var _eyes         : WalkerEyes;
}

enum Direction
{
	Left;
	Right;
}



