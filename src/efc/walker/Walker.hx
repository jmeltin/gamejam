package efc.walker;

import flambe.Component;
import flambe.Entity;
import flambe.asset.AssetPack;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.display.Font;
import flambe.math.FMath;
import flambe.animation.Ease;
import flambe.animation.Jitter;
import flambe.sound.Sound;
import flambe.sound.Mixer;
import flambe.script.*;

import efc.juice.Shaker;
import efc.camera.Camera;
import efc.controller.Controller;
import efc.body.BodyBurger;

import nape.callbacks.InteractionCallback;
import nape.dynamics.InteractionFilter;

import deadlyCute.Scaler;

class Walker extends Component
{
	public var sprite (default, null) : ImageSprite;

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	public function new(pack :AssetPack, shaker :Shaker, background :Entity, foreground :Entity, resetFn :Void -> Void, muteFn :Void -> Void) : Void
	{
		_pack = pack;
		_shaker = shaker;
		_background = background;
		_foreground = foreground;
		_resetFn = resetFn;
		_muteFn = muteFn;
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

		_body.body.velocity.x = 100;


		owner.add(_stateManager = new WalkerStateManager(_body, _pack));
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

		if(!hasVelocity()) {
			_stopElapsed += dt;
			if(_stopElapsed > _maxStoppage && !_hasCuteness) {
				_pack.getSound("sound/lazy").play();
				cuteness();
			}
		}
		else {
			_stopElapsed = 0;
		}

		if(_body.body.position.y > 3000) {
			if(!_hasFallen && !_hasCuteness) {
				_hasFallen = true;
				_pack.getSound("sound/falling").play();
				cuteness();
			}
		}


		if(_stateManager.state != null)
			_stateManager.state.update(dt);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	public function moveDown(dt :Float, isFresh :Bool) : Void
	{
		if(_stateManager.state != null)
			_stateManager.state.moveDown(dt, isFresh);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	@:keep public function handleBodyCallback(impulse :Float) : Void
	{
		impulse /= 30000;
		_shaker.shake(Math.abs(impulse));
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	@:keep public function handleBodyDangerCallback(totalImpulse :nape.geom.Vec3) : Void
	{
		var maxVelocity = 2000;
		_pack.getSound("sound/spike").play();
		_body.body.velocity.x = FMath.clamp(totalImpulse.x, -maxVelocity, maxVelocity);
		_body.body.velocity.y = FMath.clamp(totalImpulse.y, -maxVelocity, maxVelocity);
		cuteness();
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

	private function hasVelocity() : Bool
	{
		var v = _body.body.velocity;
		var min = 20;

		if(v.x < min && v.x > -min && v.y < min && v.y > -min)
			return false;

		return true;
	}

	private function cuteness() : Void
	{
		if(_hasCuteness)
			return;

		_hasCuteness = true;
		_background.get(Sprite).alpha.animateTo(0, 1, Ease.sineOut);
		_foreground.get(Sprite).alpha.behavior = new Jitter(0.25, 0.25);
		_body.body.setShapeFilters(new InteractionFilter(1, 4));
		_muteFn();

		initSounds();
		showText();
	}

	private function showText() : Void
	{
		var text :TextSprite;
		owner.addChild(new Entity()
			.add(text = cast new TextSprite(new Font(_pack, "font/default"), "")
				.setWrapWidth(670)
				.setXY(130, 0)));

		var curLetter = 0;
		var quoteIndex = Math.floor(jadenQuotes.length * Math.random());
		var quote = randomQuote();

		var temp = new Entity();
		owner.addChild(temp);
		temp.add(new Script()).get(Script).run(new Sequence([
			new Delay(1),
			new Repeat(new Sequence([
				new CallFunction(function() {
					text.text = quote.substr(0, ++curLetter);
					text.y._ = -text.getNaturalHeight() * 0.25;
					randomSound().play(Math.random());
				}),
				new Delay(0.05)
			]), quote.length),
			new Delay(2),
			new CallFunction(_resetFn)
		]));
	}

	private function initSounds() : Void
	{
		_soundMap = new Map<String, Sound>();
		for(id in typeSounds)
			_soundMap.set(id, _pack.getSound("sound/" + id));
	}

	private function randomSound() : Sound
	{
		var sIndex = Math.floor(typeSounds.length * Math.random());
		return _soundMap.get(typeSounds[sIndex]);
	}

	private function randomQuote() : String
	{
		var quoteIndex = Math.floor(jadenQuotes.length * Math.random());
		return jadenQuotes[quoteIndex] + " -jaden smith";
	}


	private var jadenQuotes = [
		"Jealousy Just Reassures Your Love.",
		"You Do Not Know Who You Are Or Why Your Here So When You See Someone Who Dose The Society Comes Together As A Whole And Destroys Them.",
		"To The Artist Of This Coming Generation And Of The Renaissance. The People That Truly Understand Your Art are The People Who Don't Comment",
		"I Encourage You All To Unfollow Me So I Can Be Left With The People Who Actually Appreciate Philosophy And Poetry. #CoolTapeVol2",
		"We Need To Stop Teaching The Youth About The Past And Encourage Them To Change The Future.",
		"There Is No Nutrients In Our Food Anymore Or In Our Soil OR IN OUR WATER.",
		"I Should Just Stop Tweeting, The Human Consciousness Must Raise Before I Speak My Juvenile Philosophy. ",
		"Gravity is the greatest film of our generation.",
		"The Great Gatsby Is One Of The Greatest Movies Of All Time, Coachella.",
		"Everybody Get Off Your Phones And Go Do What You Actually Wanna Do",
		"If Everybody In The World Dropped Out Of School We Would Have A Much More Intelligent Society.",
		"If Newborn Babies Could Speak They Would Be The Most Intelligent Beings On Planet Earth.",
		"Education Is Rebellion.",
		"School Is The Tool To Brainwash The Youth.",
		"People Use To Ask Me What Do You Wanna Be When You Get Older And I Would Say What A Stupid Question The Real Question Is What Am I Right Now",
		"If A Book Store Never Runs Out Of A Certain Book, Dose That Mean That Nobody Reads It, Or Everybody Reads It",
		"I Honestly Love When People Hate Even When There Close To You.",
		"Ill Never Forget The Blogs That Believed In Me Since The Begging.",
		"I Only Apply To The Sixth Amendment"
	];

	private var typeSounds = [
		"type1",
		"type2",
		"type3",
		"type4",
		"type5",
		"type6",
		"type7",
		"type8",
	];

	private var _pack         : AssetPack;
	private var _background   : Entity;
	private var _foreground   : Entity;
	private var _shaker       : Shaker;
	private var _muteFn      : Void -> Void;
	private var _resetFn      : Void -> Void;
	private var _body         : BodyBurger;
	private var _stateManager : WalkerStateManager;
	private var _eyes         : WalkerEyes;
	private var _hasCuteness  : Bool = false;
	private var _hasFallen    : Bool = false;
	private var _soundMap     : Map<String, Sound>;

	private var _maxStoppage = 0.5;
	private var _stopElapsed = 0.0;
}

enum Direction
{
	Left;
	Right;
}



