package deadlyCute;

import flambe.Entity;
import flambe.System;
import flambe.Component;
import flambe.asset.AssetPack;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.swf.Library;
import flambe.swf.MoviePlayer;
import flambe.math.Point;

import efc.body.MovieBody;
import efc.body.BodyMachine;
import deadlyCute.paperMachine.Rotater;

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
		_container
			.add(new Sprite())
			.add(_mapMovie = new MoviePlayer(new Library(_pack, _map)).loop("default"));

		_mapMovie.movie._.paused = true;
		
		var matrix = _mapMovie.movie._.getLayer("burger").get(Sprite).getViewMatrix();
		_container.get(Sprite).setAnchor(matrix.m02, matrix.m12);
		_container.get(Sprite).setXY(_position.x, _position.y);

		for(layer in _mapMovie.movie._.symbol.layers) {
			addLayerBody(layer.name);
		}
	}

	private function addLayerBody(name :String) :Void
	{
			if(StringTools.startsWith(name, "curve1"))
				_container.addChild(new Entity().add(new MovieBody(_mapMovie.movie._.getLayer(name), "curve1")));
			else if(StringTools.startsWith(name, "curve2"))
				_container.addChild(new Entity().add(new MovieBody(_mapMovie.movie._.getLayer(name), "curve2")));
			else if(StringTools.startsWith(name, "curve3"))
				_container.addChild(new Entity().add(new MovieBody(_mapMovie.movie._.getLayer(name), "curve3")));
			else if(StringTools.startsWith(name, "curve4"))
				_container.addChild(new Entity().add(new MovieBody(_mapMovie.movie._.getLayer(name), "curve4")));
			else if(StringTools.startsWith(name, "curve5"))
				_container.addChild(new Entity().add(new MovieBody(_mapMovie.movie._.getLayer(name), "curve5")));
			else if(StringTools.startsWith(name, "curve6"))
				_container.addChild(new Entity().add(new MovieBody(_mapMovie.movie._.getLayer(name), "curve6")));
			else if(StringTools.startsWith(name, "cat"))
				_container.addChild(new Entity().add(new MovieBody(_mapMovie.movie._.getLayer(name), "cat")));
			else if(StringTools.startsWith(name, "iceCastle")) {
				_container.addChild(new Entity().add(new MovieBody(_mapMovie.movie._.getLayer(name), "iceCastle", true)));
			}
	}

	private function addMachine(layer :String, id :String) : Void
	{
		_mapMovie.movie._.getLayer(layer)
			.addChild(new Entity()
				.add(new ImageSprite(_pack.getTexture(id)))
				.add(new BodyMachine(id))
				.add(new Rotater()));
	}

	public function playerPosition() :Point
	{
		return _position;
	}

	private var _container : Entity = new Entity();
	private var _pack      : AssetPack;
	private var _map       : String;
	private var _mapMovie  : MoviePlayer;
	private var _position  : Point = new Point(300, 300);
}