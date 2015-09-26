package efc.controller;

import flambe.Entity;
import flambe.System;
import flambe.Component;
import flambe.input.KeyboardEvent;
import flambe.Disposer;

class Controller extends Component
{
	//////////////////////////////////////////////////////////
	public var fn_KeyLeft  (null, set): Float -> Bool -> Void;
	public var fn_KeyRight (null, set): Float -> Bool -> Void;
	public var fn_KeyDown  (null, set): Float -> Bool -> Void;
	//////////////////////////////////////////////////////////

	public function new(){}	

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	override public function onUpdate(dt :Float) : Void
	{
		for(key in _activeKeys) {
			var fnCtrl = _mappedKeys.get(key);
			fnCtrl.fn(dt, fnCtrl.fresh);
			fnCtrl.fresh = false;
		}
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	override public function onStart() : Void
	{
		var disposer = owner.get(Disposer);
		if(disposer == null)
			owner.add(disposer = new Disposer());

		disposer.connect1(System.keyboard.down, onKeyDown);
		disposer.connect1(System.keyboard.up, onKeyUp);
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	private inline function onKeyDown(e :KeyboardEvent) : Void
	{
		switch (e.key) {
			case Left:  if(fn_KeyLeft != null)  freshKey(Left);
			case Right: if(fn_KeyRight != null) freshKey(Right);
			case Space: if(fn_KeyDown != null)    freshKey(Space);

			default: trace("keyup: " + e.key + " ignored.");
		}
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	private inline function onKeyUp(e :KeyboardEvent) : Void
	{
		switch (e.key) {
			case Left:  if(fn_KeyLeft != null)  _activeKeys.remove(Left);
			case Right: if(fn_KeyRight != null) _activeKeys.remove(Right);
			case Space: if(fn_KeyDown != null)    _activeKeys.remove(Space);
			
			default: trace("keydown: " + e.key + " ignored.");
		}
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	private function freshKey(key :Key) : Void
	{
		_activeKeys.push(key);
		_mappedKeys.get(key).fresh = true;
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	private function set_fn_KeyLeft(fn :Float -> Bool -> Void) : Float -> Bool -> Void
	{
		fn_KeyLeft = fn;
		_mappedKeys.set(Left, {fn: fn_KeyLeft, fresh: true});
		return fn_KeyLeft;
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	private function set_fn_KeyRight(fn :Float -> Bool -> Void) : Float -> Bool -> Void
	{
		fn_KeyRight = fn;
		_mappedKeys.set(Right, {fn: fn_KeyRight, fresh: true});
		return fn_KeyRight;
	}

	/* -------------------------------------------------------------
	/* 
	------------------------------------------------------------- */
	private function set_fn_KeyDown(fn :Float -> Bool -> Void) : Float -> Bool -> Void
	{
		fn_KeyDown = fn;
		_mappedKeys.set(Space, {fn: fn_KeyDown, fresh: true});
		return fn_KeyDown;
	}

	private var _activeKeys = new Array<Key>();
	private var _mappedKeys = new Map<Key, Fn_Ctrl>();
}

enum Key {
	Left;
	Right;
	Space;
}

typedef Fn_Ctrl =
{
	var fn    :Float -> Bool -> Void;
	var fresh :Bool;
}