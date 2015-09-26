package efc.body;

import efc.body.util.BodyTracer;

import flambe.System;
import flambe.Component;
import flambe.display.ImageSprite;
import flambe.util.Assert;
import flambe.math.FMath;

import nape.shape.Polygon;
import nape.shape.Shape;
import nape.geom.Vec2;
import nape.geom.AABB;
import nape.geom.GeomPoly;

class BodyKinematic extends Component
{
	public var body (default, null) = new nape.phys.Body(nape.phys.BodyType.KINEMATIC);
	public function new() {}

	/* -------------------------------------------------------------
	/*  SET SPRITE'S X,Y,ROTATION TO BODY'S X,Y,ROTATION
	------------------------------------------------------------- */
	override public function onUpdate(dt :Float) : Void
	{
		body.position.x = _sprite.x._;
		body.position.y = _sprite.y._;
	}

	/* -------------------------------------------------------------
	/*  
	------------------------------------------------------------- */
	override public function onStart() : Void
	{
		_bodyContainer = owner.getFromParents(BodyContainer);

		_sprite = owner.get(ImageSprite);
		var width =  _sprite.texture.width;
		var height =  _sprite.texture.height;
		var data = _sprite.texture.readPixels(0, 0, width, height);
		
		var poly :GeomPoly = new GeomPoly(BodyTracer.traceTexture(_sprite.texture, 2)).simplify(3);
		var convexList = poly.convexDecomposition();
		for(geomPoly in convexList)
			body.shapes.add(new Polygon(geomPoly));

		body.setShapeMaterials(nape.phys.Material.wood());
		body.align();
		var x = body.worldCOM.x;
		var y = body.worldCOM.y;
		_sprite.setAnchor(x, y);
		_sprite.setXY(x + _sprite.x._, y + _sprite.y._);

		_bodyContainer.addBody(body);
	}

	/* -------------------------------------------------------------
	/*  
	------------------------------------------------------------- */
	public function inOnBody() :Bool
	{
		_bounds.width = body.bounds.width;
		_bounds.x = body.bounds.x;
		_bounds.y = body.bounds.y + body.bounds.height + 1;

		if(_bodyContainer.space.bodiesInAABB(_bounds).length > 0)
			return true;
		return false;
	}

	private var _bodyContainer : BodyContainer;
	private var _sprite        : ImageSprite;
	private var _bounds        : AABB = new AABB(1, 1, 1, 2);
}




