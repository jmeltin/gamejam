package deadlyCute;

import flambe.Entity;
import flambe.System;
import flambe.Component;
import flambe.asset.AssetPack;
import flambe.display.Sprite;
import flambe.swf.Library;
import flambe.swf.MoviePlayer;

import efc.body.MovieBody;

class GameMap extends Component {

	public function new(pack :AssetPack, map :String) : Void
	{
		_pack = pack;
		_map = map;

		init();
	}

	override public function onStart() : Void
	{
		owner.addChild(_container);
	}

	private function init() : Void
	{
		// var map = new MoviePlayer(new Library(_pack, _map)).loop("default");
		// var matrix = map.movie._.getLayer("player").get(Sprite).getViewMatrix();
		// var x = System.stage.width/2 - 200;
		// var y = System.stage.height/2 + 30;

		// map.movie._.setAnchor(x, y);
		// map.movie._.setXY(x, y);


		// // _container.addChild(new Entity().add(new MovieBody(map.movie._.getLayer("banana_1"))));
		// _container.addChild(new Entity().add(new MovieBody(map.movie._.getLayer("banana_2"))));
		// // _container.addChild(new Entity().add(new MovieBody(map.movie._.getLayer("banana_3"))));
		// // _container.addChild(new Entity().add(new MovieBody(map.movie._.getLayer("banana_4"))));
		// // _container.addChild(new Entity().add(new MovieBody(map.movie._.getLayer("banana_5"))));
		// // _container.addChild(new Entity().add(new MovieBody(map.movie._.getLayer("banana_6"))));
	
		// _container.add(new Sprite().setXY(x, y));

		_container
			.add(new Sprite())
			.add(_player = new MoviePlayer(new Library(_pack, _map)).loop("default"));
		// _player.movie._.setAnchor(0,_player.movie._.getLayer("back").get(Sprite).getNaturalHeight());

		// _player.movie._.getLayer("banana_1").add(new MovieBody());
		// _player.movie._.getLayer("banana_2").add(new MovieBody());
		// _player.movie._.getLayer("banana_3").add(new MovieBody());
		// _player.movie._.getLayer("banana_4").add(new MovieBody());
		// _player.movie._.getLayer("banana_5").add(new MovieBody());
		// _player.movie._.getLayer("banana_6").add(new MovieBody());
	}

	private var _container : Entity = new Entity();
	private var _pack      : AssetPack;
	private var _map       : String;
	private var _player    : MoviePlayer;
}