package efc.body;

import flambe.System;
import flambe.Entity;
import flambe.Component;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.animation.Ease;
import flambe.util.Assert;
import flambe.math.FMath;
import flambe.math.Matrix;

import nape.shape.Polygon;
import nape.shape.Shape;
import nape.phys.BodyType.KINEMATIC;
import nape.geom.GeomPoly;
import nape.geom.Vec2;

import efc.body.util.BodyTracer;

class MovieBody extends Component
{
	public var body (default, null): nape.phys.Body;

	public function new(layer :Entity, name :String, isDangerous :Bool = false) : Void
	{
		_layer = layer;
		_isDangerous = isDangerous;
		body = BodyLibrary.get(name);
		body.type = nape.phys.BodyType.KINEMATIC;
	}

	override public function onStart() : Void
	{
		var layerSpr = _layer.get(ImageSprite);

		var vMatrix = layerSpr.getViewMatrix();
		var lMatrix = layerSpr.getLocalMatrix();

		body.rotation = Math.atan2(-lMatrix.m01, lMatrix.m00);
		body.position = Vec2.weak(vMatrix.m02, vMatrix.m12);
		body.setShapeMaterials(nape.phys.Material.ice());

		if(!_isDangerous)
			owner.getFromParents(BodyContainer).addBody(body);
		else
			owner.getFromParents(BodyContainer).addBodyDanger(body);
	}

	private var _layer       : Entity;
	private var _isDangerous : Bool;
}