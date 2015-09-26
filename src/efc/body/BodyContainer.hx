package efc.body;

import flambe.System;
import flambe.Component;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.animation.Ease;
import flambe.util.Assert;
import flambe.math.FMath;

import nape.space.Space;
import nape.geom.Vec2;

import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionType;
import nape.callbacks.CbType;
import nape.callbacks.CbEvent;

import efc.body.util.Debug;

class BodyContainer extends Component
{
	public var space (default, null) = new Space(new Vec2(0, 1500));

	/* -------------------------------------------------------------
	/* CREATE SPACE AND ADD CALLBACK LISTENER
	------------------------------------------------------------- */
	public function new() : Void
	{
		space.listeners.add(new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION, _NORMAL, _NORMAL, normal_normal));
	}

	override public function onStart() : Void
	{
#if flash
		owner.add(_flashDebug = new Debug(space));
#end
	}

	/* -------------------------------------------------------------
	/* UPDATE SPACE STEP WITH DELTA TIME
	------------------------------------------------------------- */
	override public function onUpdate (dt :Float) : Void
	{
		space.step(dt);
	}

	/* -------------------------------------------------------------
	/*  ADD BODY TO SPACE AND ADD NORMAL CALLBACK
	------------------------------------------------------------- */
	public function addBody(body :nape.phys.Body) : Void
	{
		body.space = space;
		body.cbTypes.add(_NORMAL);
	}

	/* -------------------------------------------------------------
	/*  
	------------------------------------------------------------- */
	public function addConstraint(constraint :nape.constraint.Constraint) : Void
	{
		constraint.space = space;
	}

	/* -------------------------------------------------------------
	/*  
	------------------------------------------------------------- */
	public function rayCast(ray :nape.geom.Ray) : nape.geom.RayResult
	{
		return space.rayCast(ray);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	public function setX(amount :Float) : Void
	{
		_flashDebug.setX(amount);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	public function setY(amount :Float) : Void
	{
		_flashDebug.setY(amount);
	}

	/* -------------------------------------------------------------
	/* HANDLE COLLISIONS BETWEEN BODIES
	------------------------------------------------------------- */
	private function normal_normal(collision:InteractionCallback) :Void
	{
		var body1 = collision.int1.castBody;
		var body2 = collision.int2.castBody;

		if(body1.userData.component != null)
			body1.userData.component.handleBodyCallback();

		if(body2.userData.component != null)
			body2.userData.component.handleBodyCallback();
	}

	private var _NORMAL = new CbType();
	private var _flashDebug :Debug;
}