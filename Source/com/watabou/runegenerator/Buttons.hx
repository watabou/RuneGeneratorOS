package com.watabou.runegenerator;

import openfl.display.Sprite;

import com.watabou.coogee.Game;

class Buttons extends Sprite {

	public function new() {
		super();

		var btnTable = BmpButton.fromAsset( "table", ()->Game.switchScene( RunesScene ) );
		addChild( btnTable );

		var btnAlphabet = BmpButton.fromAsset( "alphabet", ()->Game.switchScene( AlphabetScene ) );
		addChild( btnAlphabet );

		for (btn in [btnTable, btnAlphabet])
			btn.scaleX = btn.scaleY = 0.5;

		btnAlphabet.x = btnTable.width + 4;
	}
}
