package deadlyCute;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;

import flambe.swf.Library;

import flambe.swf.MoviePlayer;

class Main
{
	private static function main ()
	{
		System.init();

		var manifest = Manifest.fromAssets("bootstrap");
		var loader = System.loadAssetPack(manifest);

		loader.progressChanged.connect(function () {
			trace("Download progress: " + (loader.progress/loader.total));
		});

		loader.get(onSuccess);
	}

	private static function onSuccess (pack :AssetPack)
	{
		System.root.add(new Game(pack));
	}
}