package com.watabou.runegenerator;

import com.watabou.coogee.Game;

class Main extends Game {

	public function new () {
		super( AlphabetScene );
	}

	override private function getScale( w:Float, h:Float ):Float {
		return Std.int( Math.min( w / 104, h / 143 ) / 2 ) << 1;
	}
}