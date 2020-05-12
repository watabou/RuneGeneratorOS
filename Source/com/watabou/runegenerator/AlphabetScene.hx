package com.watabou.runegenerator;

import openfl.display.Sprite;
import openfl.ui.Keyboard;

import com.watabou.coogee.Game;
import com.watabou.coogee.Scene;

class AlphabetScene extends Scene {

	private static inline var N		= 24;
	private static inline var COLS	= 8;
	private static inline var GAP	= 8;

	private var table	: Sprite;
	private var buttons	: Buttons;

	private var alphabet	: Array<Rune>;

	public function new() {
		super();

		table = new Sprite();
		addChild( table );

		alphabet = [];

		for (i in 0...N) {
			var rune:Rune;
			do 
				rune = new Rune() 
			while (!addRune( rune, i ));
			addRuneButton( rune, i );
		}

		buttons = new Buttons();
		addChild( buttons );

		keyEvent.add( onKey );
	}

	override private function layout() {
		var h = table.height + 10 + buttons.height;

		table.x = Std.int( (rWidth - table.width) / 2 );
		table.y = Std.int( (rHeight - h) / 2 );

		buttons.x = Std.int( (rWidth - buttons.width) / 2 );
		buttons.y = table.y + table.height + 10;
	}

	private function onKey( key:Int, down:Bool )
		if (key == Keyboard.ENTER && down)
			Game.switchScene( AlphabetScene );

	private function addRune(rune:Rune, pos:Int ):Bool {
		if (!rune.isSymmetric() && Math.random() < 0.9)
			return false;

		var mirrX = rune.mirrorX();
		var mirrY = rune.mirrorY();

		for (r in alphabet) {
			if (rune.diff( r ) < 5)
				return false;

			if (!rune.hSym && r.diff( mirrX ) < 3)
				return false;
			
			if (!rune.vSym && r.diff( mirrY ) < 3)
				return false;
			
			if (!rune.vSym && !rune.hSym && r.diff( rune.rotate180() ) < 1)
				return false;
		}

		alphabet.insert( pos, rune );
		
		return true;
	}

	private function addRuneButton( rune:Rune, index:Int ) {

		var bmp = new BmpButton( rune.getBitmap( 0x222222 ), ()->replaceRune( index ) );
		bmp.x = (index % COLS) * (Rune.WIDTH + GAP);
		bmp.y = Std.int( index / COLS ) * (Rune.HEIGHT + GAP);
		table.addChildAt( bmp, index );
	}

	private function replaceRune( index:Int ) {
		alphabet.splice( index, 1 );
		table.removeChildAt( index );

		var rune:Rune;
		do 
			rune = new Rune()
		while (!addRune( rune, index ));

		addRuneButton( rune, index );
	}
}
