package com.watabou.coogee;

import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.ui.Keyboard;

import msignal.Signal;

class Scene extends Sprite {

	public var keyEvent	: Signal2<Int, Bool> = new Signal2();
	public var update	: Signal1<Float> = new Signal1();

	private var rWidth	= 0.0;
	private var rHeight	= 0.0;

	public var keyShift	= false;

	public function activate():Void {
		stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
	}

	public function deactivate():Void {
		stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		stage.removeEventListener( KeyboardEvent.KEY_UP, onKeyUp );
	}

	private function onEsc():Void {
		Game.quit();
	}

	private function onKeyDown( e:KeyboardEvent ):Void {
		switch (e.keyCode) {
			case Keyboard.ESCAPE:
				onEsc();
			case Keyboard.SHIFT:
				keyShift = true;
		}
		keyEvent.dispatch( e.keyCode, true );

		if (stage != null && !Std.is( stage.focus, TextField ))
			e.preventDefault();
	}

	private function onKeyUp( e:KeyboardEvent ):Void {
		switch (e.keyCode) {
			case Keyboard.SHIFT:
				keyShift = false;
		}
		keyEvent.dispatch( e.keyCode, false );

		if (!Std.is( stage.focus, TextField ))
			e.preventDefault();
	}

	public function setSize( w:Float, h:Float ):Void {
		rWidth = w;
		rHeight = h;
		layout();
	}

	public inline function getWidth() return rWidth;
	public inline function getHeight() return rHeight;

	private function layout():Void {}
}