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
import nape.constraint.WeldJoint;
import nape.constraint.PivotJoint;
import nape.geom.Ray;

class BodyBurger extends Component
{
	public var body (default, null) = new nape.phys.Body();
	public function new() {}

	/* -------------------------------------------------------------
	/*  SET SPRITE'S X,Y,ROTATION TO BODY'S X,Y,ROTATION
	------------------------------------------------------------- */
	override public function onUpdate(dt :Float) : Void
	{
		if(body.isSleeping)
			return;

		_sprite.x.update(dt);
		_sprite.y.update(dt);
		_sprite.rotation.update(dt);
		
		_sprite.rotation._ = FMath.toDegrees(body.rotation);
		_sprite.x._ = body.position.x;
		_sprite.y._ = body.position.y;

		_bodyAnchor.position = body.position;
	}

	/* -------------------------------------------------------------
	/*  
	------------------------------------------------------------- */
	override public function onStart() : Void
	{
		_bodyContainer = owner.getFromParents(BodyContainer);

		_sprite = owner.get(ImageSprite);
		_sprite.disablePixelSnapping();

		var width =  _sprite.texture.width;
		var height =  _sprite.texture.height;
		var data = _sprite.texture.readPixels(0, 0, width, height);
		
		var poly :GeomPoly = new GeomPoly(BodyTracer.traceTexture(_sprite.texture, 2)).simplify(8);
		var convexList = poly.convexDecomposition();
		for(geomPoly in convexList)
			body.shapes.add(new Polygon(geomPoly));

		_bodyAnchor.shapes.add(new Polygon(Polygon.box(1,1)));

		body.align();

		var x = body.worldCOM.x;
		var y = body.worldCOM.y;
		_sprite.setAnchor(x, y);
		
		_bodyAnchor.align();
		_bodyAnchor.allowRotation = false;
		body.position = Vec2.weak(_sprite.x._, _sprite.y._);
		body.rotation = _sprite.rotation._;

		body.setShapeMaterials(nape.phys.Material.ice());

		_bodyContainer.addBody(body);
		_bodyContainer.addBody(_bodyAnchor);

		var joint :WeldJoint;
		_bodyContainer.addConstraint(joint = new WeldJoint(body, _bodyAnchor, body.position, body.position));
		joint.damping = 1;
		joint.frequency = 1;
		joint.stiff = false;
	}

	/* -------------------------------------------------------------
	/*  
	------------------------------------------------------------- */
	public function distanceFromBody() :Float
	{
		_ray.origin.set(body.localPointToWorld(Vec2.weak(0, body.bounds.height/2),true));
        _ray.direction.set(Vec2.weak(0,1));
        _ray.maxDistance = 1000;

        var data = _bodyContainer.rayCast(_ray);

        if(data == null)
        	return -1;

        return data.distance;
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

	private var _tolerance     : Float = 10;
	private var _bodyContainer : BodyContainer;
	private var _sprite        : ImageSprite;
	private var _bounds        : AABB = new AABB(1, 1, 1, 2);
	private var _ray           : Ray = new Ray(Vec2.weak(), Vec2.weak());

	private var _bodyAnchor = new nape.phys.Body();
}




