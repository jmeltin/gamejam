package deadlyCute;

import flambe.Entity;
import flambe.System;
import flambe.Component;
import flambe.asset.AssetPack;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.display.PatternSprite;
import flambe.display.FillSprite;
import flambe.animation.Sine;
import flambe.sound.Playback;

import efc.body.BodyContainer;
import efc.controller.Controller;
import efc.juice.Shaker;
import efc.camera.Camera;
import efc.walker.Walker;

import flambe.input.KeyboardEvent;

import efc.body.BodyBurger;
import efc.body.BodyLibrary;

class Game extends Component
{
	
	public function new(pack :AssetPack) : Void
	{
		_pack = pack;
	}

	override public function onUpdate(dt :Float) : Void
	{
		_patternFrontNormal.get(Sprite).x.update(dt);
		_patternFrontNormal.get(Sprite).y.update(dt);

		_patternFrontRed.get(Sprite).x.update(dt);
		_patternFrontRed.get(Sprite).y.update(dt);

		_patternFrontBlue.get(Sprite).x.update(dt);
		_patternFrontBlue.get(Sprite).y.update(dt);

		_patternShaker.get(Sprite).x.update(dt);
		_patternShaker.get(Sprite).y.update(dt);

		_patternBack.get(Sprite).alpha.update(dt);
		_patternShaker.get(Sprite).alpha.update(dt);
	}

	override public function onStart() : Void
	{
		var container    :Entity = new Entity();
		var foreGround   :Entity = new Entity();
		var hills        :Entity = new Entity();
		var burger       :Entity = new Entity();
		var map          :Entity = new Entity();

		_bfx = _pack.getSound("sound/bfx").loop();


		BodyLibrary.initialize();

		_patternBack
			.add(new PatternSprite(_pack.getTexture("pattern"), 20000, 7000).setXY(-5000, -1000));

		_patternFrontNormal
			.add(new FillSprite(0xfffac3, 2000, 1000).setAlpha(1).setBlendMode(Multiply));

		_patternFrontRed
			.add(new PatternSprite(_pack.getTexture("overlayRed"), 2000, 1000).setAlpha(0.8).setBlendMode(Multiply));
		addSine(_patternFrontRed, 60, 5);

		_patternFrontBlue
			.add(new PatternSprite(_pack.getTexture("overlayBlue"), 2000, 1000).setBlendMode(Multiply));
		addSine(_patternFrontBlue, 60, 5, 2.5);

		_patternShaker
			.add(new PatternSprite(_pack.getTexture("shake"), 2000, 1000).setAlpha(0).setBlendMode(Screen));

		var shaker :Shaker;
		map
			.add(shaker = new Shaker(_pack.getSound("sound/shake"), _patternShaker, _patternBack))
			.add(new GameMap(_pack, "map_2"));
		var burgerPos = map.get(GameMap).playerPosition();

		burger
			.add(new ImageSprite(_pack.getTexture("burger"))
				.setXY(burgerPos.x, burgerPos.y))
			.add(new BodyBurger())
			.add(new Walker(_pack, shaker, _patternBack, _patternShaker, resetGame, muteSound));

		container
			
			.add(new Scaler())
			.add(new Camera())
			.add(new Controller())
			.add(new BodyContainer())
			.addChild(_patternBack)
			.addChild(map)
			.addChild(hills)
			.addChild(burger);

		owner
			.addChild(container)
			.addChild(foreGround);

		foreGround
			.addChild(_patternFrontRed)
			.addChild(_patternFrontBlue)
			.addChild(_patternFrontNormal)
			.addChild(_patternShaker);


	}

	private function addSine(e :Entity, amount :Float, speed :Float, offset :Float = 0) : Void
	{
		e.get(Sprite).setXY(-amount, -amount);
		e.get(Sprite).disablePixelSnapping();
		e.get(Sprite).x.behavior = new Sine(e.get(Sprite).x._, e.get(Sprite).x._ + amount, speed, 0, offset);	
		e.get(Sprite).y.behavior = new Sine(e.get(Sprite).y._, e.get(Sprite).y._ + amount, speed, 0, offset);	
	}

	private function muteSound() : Void
	{
		_bfx.volume.animateTo(0, 1);
	}

	private function resetGame() : Void
	{
		var main = owner;
		main.disposeChildren();
		main.add(new Game(_pack));
		muteSound();
	}

	private var _pack       : AssetPack;

	private var _patternFrontNormal :Entity = new Entity();
	private var _patternFrontRed    :Entity = new Entity();
	private var _patternFrontBlue   :Entity = new Entity();
	private var _patternShaker      :Entity = new Entity();
	private var _patternBack        :Entity = new Entity();

	private var _bfx :Playback;
}