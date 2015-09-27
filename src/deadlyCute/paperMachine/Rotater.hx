package deadlyCute.paperMachine;

import flambe.Entity;
import flambe.System;
import flambe.Component;

import efc.body.BodyContainer;
import efc.body.BodyMachine;

import nape.shape.Polygon;
import nape.shape.Circle;
import nape.constraint.MotorJoint;
import nape.phys.Body;
import nape.geom.Vec2;
import nape.geom.Geom;
import nape.dynamics.InteractionFilter;

class Rotater extends Component {

	public function new() : Void
	{
	}

	override public function onUpdate(dt :Float) : Void
	{
		// _body.rotation += dt * _speed;
		planetaryGravity(dt);
	}

	override public function onStart() : Void
	{
		_body = owner.get(BodyMachine).body;
		// _body.setShapeFilters(new InteractionFilter(1, 4));
		_bodyContainer = owner.getFromParents(BodyContainer);

		_samplePoint.shapes.add(new Circle(0.001));
	}

	function planetaryGravity(dt :Float) : Void
	{
		var closestA = Vec2.get();
		var closestB = Vec2.get();

		for (bodyS in _bodyContainer.space.liveBodies) {
			_samplePoint.position.set(bodyS.position);
			var distance = Geom.distanceBody(_body, _samplePoint, closestA, closestB);

			if (distance > 500)
				continue;

			var force = closestA.sub(bodyS.position, true);

			force.length = bodyS.mass * 50e6 / (distance * distance);

			bodyS.applyImpulse(force.muleq(dt), null, true);
		}	

		closestA.dispose();
		closestB.dispose();
	}

	private var _samplePoint   : Body = new Body();
	private var _bodyContainer : BodyContainer;
	private var _body          : Body;
	private var _speed = 10;
}