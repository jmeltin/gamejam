package efc.camera;

import flambe.Entity;
import flambe.Disposer;
import flambe.Component;
import flambe.System;
import flambe.display.Sprite;
import flambe.util.SignalConnection;
import flambe.script.*;

import efc.body.BodyBurger;
import efc.body.BodyContainer;

class Camera extends Component {

	public var focusSprite (null, set) :Sprite;
	public var isOn (null, default) :Bool = true;
	public function new(){}

	/* --------------------------------------------------------------
	/* GRAB PARENT CONTAINER'S SPRITE
	-------------------------------------------------------------- */
	override public function onStart() : Void
	{
		_ownerSpr = owner.get(Sprite);
		if(_ownerSpr == null)
			owner.add(_ownerSpr = new Sprite());
		owner.addChild(_container);

		_bodyContainer = owner.getFromParents(BodyContainer);
	}

	/* --------------------------------------------------------------
	/* CLEAR SIGNALS FROM MEMORY
	-------------------------------------------------------------- */
	override public function onRemoved() : Void
	{
		cleanSignals();
	}

	/* --------------------------------------------------------------
	/* SET CAMERAS FOCUS AND SET SIGNALS TO FOCUS'S X AND Y
	-------------------------------------------------------------- */
	private function set_focusSprite(spr :Sprite) :Sprite
	{
		focusSprite = spr;

		_sprLastX = focusSprite.x._;
		_sprLastY = focusSprite.y._;

		cleanSignals();
		_signalX = focusSprite.x.changed.connect(onFocusChangeX);
		_signalY = focusSprite.y.changed.connect(onFocusChangeY);

		return focusSprite;
	}

	/* --------------------------------------------------------------
	/* SHIFT OWNER SPRITE'S X POSITION
	-------------------------------------------------------------- */
	private function onFocusChangeX(to :Float, from :Float) : Void
	{
		_ownerSpr.x._ -= to - _sprLastX;
		_sprLastX = to;
		_bodyContainer.setX(_ownerSpr.x._);
	}

	/* --------------------------------------------------------------
	/* SHIFT OWNER SPRITE'S Y POSITION
	-------------------------------------------------------------- */
	private function onFocusChangeY(to :Float, from :Float) : Void
	{
		_ownerSpr.y._ -= to - _sprLastY;
		_sprLastY = to;
		_bodyContainer.setY(_ownerSpr.y._);
	}

	/* --------------------------------------------------------------
	/* CLEAR SIGNALS FROM MEMORY
	-------------------------------------------------------------- */
	private function cleanSignals() : Void
	{
		if(_signalX != null) {
			_signalX.dispose();
			_signalX = null;
		}

		if(_signalY != null) {
			_signalY.dispose();
			_signalY = null;
		}
	}

	private var _container     : Entity = new Entity();
	private var _ownerSpr      : Sprite;
	private var _sprLastX      : Float;
	private var _sprLastY      : Float;
	private var _signalX       : SignalConnection;
	private var _signalY       : SignalConnection;
	private var _bodyContainer : BodyContainer;
}