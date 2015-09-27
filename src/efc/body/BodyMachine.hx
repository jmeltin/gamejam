package efc.body;

import efc.body.util.BodyTracer;

import flambe.System;
import flambe.Entity;
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
import nape.phys.BodyType.KINEMATIC;

class BodyMachine extends Component
{
	public var body : nape.phys.Body;
	public function new(id :String) : Void
	{
		_id = id;
	}

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
	}

	/* -------------------------------------------------------------
	/*  
	------------------------------------------------------------- */
	override public function onStart() : Void
	{
		_bodyContainer = owner.getFromParents(BodyContainer);

		_sprite = owner.get(ImageSprite);
		_sprite.disablePixelSnapping();

		body = BodyLibrary.get(_id);
		body.align();
		body.type = KINEMATIC;

		var x = body.worldCOM.x;
		var y = body.worldCOM.y;
		_sprite.setAnchor(x, y);

		var matrix = _sprite.getViewMatrix();
		var bX = matrix.m02 + _sprite.texture.width/2;
		var bY = matrix.m12 + _sprite.texture.height/2;

		owner.remove(_sprite);
		owner.parent.parent.parent.parent.addChild(new Entity().add(_sprite));

		_sprite.setXY(bX, bY);
		
		body.position = Vec2.weak(bX, bY);
		body.rotation = _sprite.rotation._;

		_bodyContainer.addBody(body);

	}

	private var _id            : String;
	private var _bodyContainer : BodyContainer;
	private var _sprite        : ImageSprite;
}




