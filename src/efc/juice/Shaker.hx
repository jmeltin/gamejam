package efc.juice;

import flambe.Component;
import flambe.Entity;
import flambe.display.Sprite;
import flambe.script.*;
import flambe.util.Assert;
import flambe.sound.Sound;

class Shaker extends Component
{

	/* -------------------------------------------------------------
	/* CREATE INSTANCE OF SHAKER
	------------------------------------------------------------- */
	public function new(sound :Sound, shakeLayer :Entity, backLayer :Entity) : Void
	{
		_sound = sound;
		_shakeLayer = shakeLayer;
		_backLayer = backLayer;
	}

	/* -------------------------------------------------------------
	/* SHAKER CAN SHAKER AND ASSERT THAT PARENT CONTAINS SPRITE
	------------------------------------------------------------- */
	override public function onStart() : Void
	{
		var spr = owner.get(Sprite);
		if(spr == null)
			owner.add(spr = new Sprite());
		spr.disablePixelSnapping();
	}

	/* -------------------------------------------------------------
	/* REMOVE SOUND FROM MEMORY
	------------------------------------------------------------- */
	override public function onRemoved() : Void
	{
	}

	/* -------------------------------------------------------------
	/* SHAKE SCREEN BASED ON IMPULSE
	------------------------------------------------------------- */
	public function shake(impulse :Float) : Void
	{
		if(!_canShake || impulse < MIN_IMPULSE)
			return;


		if(impulse > MAX_IMPULSE)
			impulse = MAX_IMPULSE;

		_canShake = false;
		var shakeX = impulse * SHAKE_X_MAX;
		var shakeY = impulse * SHAKE_Y_MAX;

		_sound.play(impulse);

		owner.add(new Script()).get(Script).run(new Sequence([
			new Parallel([
				new Shake(shakeX, shakeY, SHAKE_DURATION),
				new Sequence([
					new AnimateTo(_shakeLayer.get(Sprite).alpha, 1, SHAKE_DURATION/2),
					new AnimateTo(_shakeLayer.get(Sprite).alpha, 0, SHAKE_DURATION/2),
				]),
				new Sequence([
					new AnimateTo(_backLayer.get(Sprite).alpha, 1 - impulse, SHAKE_DURATION/2),
					new AnimateTo(_backLayer.get(Sprite).alpha, 1, SHAKE_DURATION/2),
				]),
			]),
			new CallFunction(function(){
				_canShake = true;
			})
		]));
	}

	private var _sound      :Sound;
	private var _shakeLayer :Entity;
	private var _backLayer  :Entity;
	private var _canShake   :Bool = true;

	private static inline var MAX_IMPULSE = 1;
	private static inline var MIN_IMPULSE = 0.25;
	private static inline var SHAKE_X_MAX = 20;
	private static inline var SHAKE_Y_MAX = 18;
	private static inline var SHAKE_DURATION = 0.5;
}