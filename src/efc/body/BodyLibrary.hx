package efc.body;

import flambe.math.Point;

import haxe.Unserializer;

import nape.shape.Polygon;
import nape.geom.GeomPoly;
import nape.geom.Vec2;
import nape.phys.Body;

import efc.body.util.BodyTracer;

class BodyLibrary
{
	/* -------------------------------------------------
	/*
	------------------------------------------------- */
	public static function get(id :String): Body
	{
		if (_lib == null)
			_lib = new BodyLibrary();
		
		return _lib._data.get(id).copy();
	}

	/* -------------------------------------------------
	/*
	------------------------------------------------- */
	public static function initialize(): Void
	{
		if (_lib == null)
			_lib = new BodyLibrary();
	}

	/* -------------------------------------------------
	/*
	------------------------------------------------- */
	private function new() : Void
	{
		trace("initialize BodyLibrary");
		var unserializer = new Unserializer(getBodyMap());
		var map :Map<String, Array<Point>> = cast unserializer.unserialize();
		createBodies(map);
	}

	/* -------------------------------------------------
	/*
	------------------------------------------------- */
	macro private static function getBodyMap()
	{
		var serializer = new haxe.Serializer();
		var map = new Map<String, Array<Point>>();

		try {
			var fin = sys.io.File.read(bodyFile, false);
			return haxe.macro.Context.makeExpr(fin.readLine(), haxe.macro.Context.currentPos());
		}
		catch(msg : String) {
			for(name in textures) {
				var file = sys.io.File.read(name, true);
				var data = new format.png.Reader(file).read();
				var header = format.png.Tools.getHeader(data);
				var pngBytes = format.png.Tools.extract32(data);

				var mapName = name.substring(name.lastIndexOf("/") + 1, name.length-4);
				var mapData = BodyTracer.traceTexture(pngBytes, header.width, header.height, 10);

				data.clear();
				file.close();
				map.set(mapName, mapData);
			}

			serializer.serialize(map);
			var fout = sys.io.File.write(bodyFile, false);
			fout.writeString(serializer.toString());
			fout.close();
			return haxe.macro.Context.makeExpr(serializer.toString(), haxe.macro.Context.currentPos());
		}
	}

	/* -------------------------------------------------
	/*
	------------------------------------------------- */
	private function createBodies(map :Map<String, Array<Point>>) : Void
	{
		var keys = map.keys();
		for (key in keys) {
			var curVecArra = pointToVec2(map.get(key));
			var poly = new GeomPoly(curVecArra).simplify(6);
			var body = new Body();

			var convexList = poly.convexDecomposition();
			for(geomPoly in convexList)
				body.shapes.add(new Polygon(geomPoly));
			_data.set(key, body);
		}
	}

	/* -------------------------------------------------
	/*
	------------------------------------------------- */
	private function pointToVec2(arraIn :Array<Point>) : Array<Vec2>
	{
		var arraOut = new Array<Vec2>();
		for(p in arraIn)
			arraOut.push(new Vec2(p.x, p.y));
		return arraOut;
	}

	private static var _lib :BodyLibrary;
	private var _data = new Map<String, Body>();

	private static var textures = [
		"./assets/bootstrap/burger.png",
		"./assets/traceTextures/curve1.png",
		"./assets/traceTextures/curve2.png",
		"./assets/traceTextures/curve3.png",
		"./assets/traceTextures/curve4.png",
		"./assets/traceTextures/curve5.png",
		"./assets/traceTextures/curve6.png",
		"./assets/traceTextures/iceCastle.png",
		"./assets/traceTextures/cat.png"
	];

	private static var bodyFile = "./bodies.cutie";
}


 






