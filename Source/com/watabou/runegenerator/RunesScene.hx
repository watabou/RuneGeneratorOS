package com.watabou.runegenerator;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.ui.Keyboard;

import com.watabou.coogee.Game;
import com.watabou.coogee.Scene;

class RunesScene extends Scene {

	private static inline var GAP = 6;

	private var table	: Sprite;
	private var buttons	: Buttons;

	public function new() {
		super();

		table = new Sprite();
		addChild( table );

		for (i in 0...10) for (j in 0...10) {
			var rune = new Rune();

			var bmp = new Bitmap( rune.getBitmap( 0x222222 ) );
			bmp.x = j * (Rune.WIDTH + GAP);
			bmp.y = i * (Rune.HEIGHT + GAP);
			table.addChild( bmp );
		}

		buttons = new Buttons();
		addChild( buttons );

		keyEvent.add( onKey );
	}

	override private function layout():Void {
		var h = table.height + 5 + buttons.height;

		table.x = Std.int( (rWidth - table.width) / 2 );
		table.y = Std.int( (rHeight - h) / 2 );

		buttons.x = Std.int( (rWidth - buttons.width) / 2 );
		buttons.y = table.y + table.height + 5;
	}

	private function onKey( key:Int, down:Bool )
		if (key == Keyboard.ENTER && down)
			Game.switchScene( RunesScene );
}
