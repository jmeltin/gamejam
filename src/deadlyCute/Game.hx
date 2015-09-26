package deadlyCute;

import flambe.Entity;
import flambe.System;
import flambe.Component;
import flambe.asset.AssetPack;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.display.PatternSprite;

import efc.body.BodyContainer;
import efc.controller.Controller;
import efc.juice.Shaker;
import efc.camera.Camera;
import efc.walker.Walker;

import flambe.input.KeyboardEvent;

import efc.body.BodyBurger;
import efc.body.BodyKinematic;

class Game extends Component
{
	
	public function new(pack :AssetPack) : Void
	{
		_pack = pack;
	}

	override public function onStart() : Void
	{
		var container :Entity = new Entity();
		var pattern   :Entity = new Entity();
		var hills     :Entity = new Entity();
		var burger    :Entity = new Entity();
		var map       :Entity = new Entity();

		pattern
			.add(new PatternSprite(_pack.getTexture("pattern"), 6000, 5000));

		// hills
		// 	.add(new ImageSprite(_pack.getTexture("hills"))
		// 		.setXY(100, 300))
		// 	.add(new BodyKinematic());

		map.add(new GameMap(_pack, "map_1"));

		burger
			.add(new ImageSprite(_pack.getTexture("burger"))
				.setXY(260, 305))
			.add(new BodyBurger())
			.add(new Walker(_pack));

		container
			.add(new Scaler())
			.add(new Camera())
			.add(new Controller())
			.add(new BodyContainer())
			.addChild(pattern)
			.addChild(map)
			.addChild(hills)
			.addChild(burger);


		owner.addChild(container);
	}

	private var _pack       : AssetPack;
}