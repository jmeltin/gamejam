package efc.juice;

import flambe.Component;
import flambe.display.Sprite;
import flambe.script.*;
import flambe.util.Assert;
import flambe.sound.Sound;

class Shaker extends Component
{

	/* -------------------------------------------------------------
	/* CREATE INSTANCE OF SHAKER
	------------------------------------------------------------- */
	public function new(sound :Sound) : Void
	{
		_sound = sound;
	}

	/* -------------------------------------------------------------
	/* SHAKER CAN SHAKER AND ASSERT THAT PARENT CONTAINS SPRITE
	------------------------------------------------------------- */
	override public function onStart() : Void
	{
		_canShake = true;
		Assert.that(owner.get(Sprite)!=null, "Shaker's owner must contain a sprite :Shaker.hx");
	}

	/* -------------------------------------------------------------
	/* REMOVE SOUND FROM MEMORY
	------------------------------------------------------------- */
	override public function onRemoved() : Void
	{
		_sound.dispose();
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

		// _sound.play(impulse);

		owner.add(new Script()).get(Script).run(new Sequence([
			new Shake(shakeX, shakeY, SHAKE_DURATION),
			new CallFunction(function(){
				_canShake = true;
			})
		]));
	}

	private var _sound    :Sound;
	private var _canShake :Bool = false;

	private static inline var MAX_IMPULSE = 1;
	private static inline var MIN_IMPULSE = 0.2;
	private static inline var SHAKE_X_MAX = 11;
	private static inline var SHAKE_Y_MAX = 7;
	private static inline var SHAKE_DURATION = 0.3333333;
}