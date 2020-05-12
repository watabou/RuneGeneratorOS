package com.watabou.runegenerator;

import openfl.display.BitmapData;

class Rune {

	private static inline var SOLID	= 0xFF000000;
	private static inline var TIP	= 0x99000000;

	public static inline var WIDTH	= 5;
	public static inline var HEIGHT	= 7;

	private static inline var MIN_WEIGHT	= 11;
	private static inline var MAX_WEIGHT	= 21;

	private var bitmap	: Array<Array<Bool>>;

	private var dotx	: Int;
	private var doty	: Int;

	public var hSym	: Bool;
	public var vSym	: Bool;

	public function new() {
		var w;
		do {
			bitmap = [for (i in 0...HEIGHT) [for (j in 0...WIDTH) false]];

			if (coin( 5/7 ))
				random1()
			else
				random2();

			w = getWeight();

		} while (w < MIN_WEIGHT || w > MAX_WEIGHT || !isConnected( w ));
	}

	private function random1() {
		bitmap[0][0] = coin( 4/5 );
		bitmap[0][2] = coin( 4/5 );
		bitmap[0][4] = coin( 4/5 ); // 5/5

		bitmap[3][0] = coin( 4/5 );
		bitmap[3][2] = coin( 4/5 ); // 5/5
		bitmap[3][4] = coin( 4/5 ); // 5/5

		bitmap[6][0] = coin( 4/5 );
		bitmap[6][2] = coin( 4/5 );
		bitmap[6][4] = coin( 2/5 );

		bitmap[0][1] = (bitmap[0][0] && bitmap[0][2] && coin( 3/4 )); // 4/4
		bitmap[0][3] = (bitmap[0][2] && bitmap[0][4] && coin( 3/4 )); // 4/4

		bitmap[1][0] = bitmap[2][0] = (bitmap[0][0] && bitmap[3][0] && coin( 2/3 ));
		bitmap[1][2] = bitmap[2][2] = (bitmap[0][2] && bitmap[3][2] && coin( 1/4 ));
		bitmap[1][4] = bitmap[2][4] = (bitmap[0][4] && bitmap[3][4] && coin( 4/5 )); // 5/5

		bitmap[3][1] = (bitmap[3][0] && bitmap[3][2] && coin( 3/4 ));
		bitmap[3][3] = (bitmap[3][2] && bitmap[3][4] && coin( 2/5 ));

		bitmap[4][0] = bitmap[5][0] = (bitmap[3][0] && bitmap[6][0] && coin( 3/4 )); // 2/2
		bitmap[4][2] = bitmap[5][2] = (bitmap[3][2] && bitmap[6][2] && coin( 2/4 ));
		bitmap[4][4] = bitmap[5][4] = (bitmap[3][4] && bitmap[6][4] && coin( 3/4 )); // 2/2

		bitmap[6][1] = (bitmap[6][0] && bitmap[6][2] && coin( 4/5 )); // 2/2
		bitmap[6][3] = (bitmap[6][2] && bitmap[6][4] && coin( 4/5 )); // 2/2

		if (bitmap[4][2] && (bitmap[3][1] != bitmap[3][3]))
			bitmap[5][2] = false;
	}

	private function random2() {
		bitmap[0][0] = coin( 1/2 );
		bitmap[0][2] = coin( 1/2 );
		bitmap[0][4] = coin( 1/2 );

		bitmap[2][0] = coin( 3/4 ); // 2/2
		bitmap[2][2] = coin( 3/4 ); // 2/2
		bitmap[2][4] = coin( 3/4 ); // 2/2

		bitmap[4][0] = coin( 1/2 );
		bitmap[4][2] = coin( 1/2 );
		bitmap[4][4] = coin( 1/2 );

		bitmap[6][0] = coin( 1/2 );
		bitmap[6][2] = coin( 1/2 );
		bitmap[6][4] = coin( 1/2 );

		bitmap[0][1] = (bitmap[0][0] && bitmap[0][2] && coin( 1/4 )); // 0/2
		bitmap[0][3] = (bitmap[0][2] && bitmap[0][4] && coin( 1/4 )); // 0/2

		bitmap[1][0] = (bitmap[0][0] && bitmap[2][0] && coin( 3/4 )); // 1/1
		bitmap[1][2] = (bitmap[0][2] && bitmap[2][2] && coin( 3/4 )); // 1/1
		bitmap[1][4] = (bitmap[0][4] && bitmap[2][4] && coin( 3/4 )); // 1/1

		bitmap[2][1] = (bitmap[2][0] && bitmap[2][2] && coin( 3/4 )); // 2/2
		bitmap[2][3] = (bitmap[2][2] && bitmap[2][4] && coin( 3/4 )); // 2/2

		bitmap[3][0] = (bitmap[2][0] && bitmap[4][0] && coin( 3/4 )); // 1/1
		bitmap[3][2] = (bitmap[2][2] && bitmap[4][2] && coin( 1/2 ));
		bitmap[3][4] = (bitmap[2][4] && bitmap[4][4] && coin( 3/4 )); // 1/1

		bitmap[4][1] = bitmap[4][2];
		bitmap[4][3] = bitmap[4][2];

		bitmap[5][0] = (bitmap[4][0] && bitmap[6][0] && coin( 3/4 )); // 1/1
		bitmap[5][2] = (bitmap[4][2] && bitmap[6][2] && coin( 1/2 )); // 0/1
		bitmap[5][4] = (bitmap[4][4] && bitmap[6][4] && coin( 3/4 )); // 1/1

		bitmap[6][1] = (bitmap[6][0] && bitmap[6][2] && coin( 1/4 )); // 0/0
		bitmap[6][3] = (bitmap[6][2] && bitmap[6][4] && coin( 1/4 )); // 0/0
	}

	private function random3() {
		bitmap = [for (i in 0...HEIGHT) [for (j in 0...WIDTH) coin( 1/2 )]];
	}

	public function getBitmap( color:UInt ):BitmapData {
		var bmp = new BitmapData( WIDTH, HEIGHT, true, 0x000000 );

		for (i in 0...HEIGHT)
			for (j in 0...WIDTH)
				if (bitmap[i][j])
					bmp.setPixel32( j, i, (countNeighbours( j, i ) == 1 ? TIP : SOLID) | color );

		return bmp;
	}

	private function getWeight():Int {
		var w = 0;
		for (i in 0...HEIGHT) for (j in 0...WIDTH)
			if (bitmap[i][j])
				w++;
		return w;
	}

	private function isConnected( weight:Int ):Bool {

		// Checking horizontal bounds
		var left = false;
		var right = false;
		for (i in 0...HEIGHT) {
			left = left || bitmap[i][0];
			right = right || bitmap[i][4];
		}
		if (!left || !right)
			return false;

		// Checking vertical bounds
		var top = false;
		var bottom = false;
		for (i in 0...WIDTH) {
			top = top || bitmap[0][i];
			bottom = bottom || bitmap[6][i];
		}
		if (!top || !bottom)
			return false;

		// Searching for dots
		dotx = -1;
		doty = -1;
		for (i in 0...HEIGHT)
			for (j in 0...WIDTH)
				if (bitmap[i][j] && countNeighbours( j, i ) == 0) {
					// It's a dot
					if (dotx == -1) {
						if (countNeighbours( j, i, 2 ) == 0)
							// The dot is too far from other strokes
							return false;
						// It's the first dot
						dotx = j;
						doty = i;
					} else
						// There is more than 1 dot
						return false;
				}

		var x, y;
		// Searching for a starting point to fill
		// which is not a dot
		for (i in 0...HEIGHT)
			for (j in 0...WIDTH)
				if (bitmap[i][j] && (i != doty || j != dotx)) {
					x = j;
					y = i;
					break;
				}

		var checked:Array<Int> = [];
		function fill( x:Int, y:Int ):Int {
			var index = x + y * WIDTH;
			if (!bitmap[y][x] || checked.indexOf( index ) != -1)
				return 0;

			checked.push( index );

			var a = 1;
			if (x > 0)
				a += fill( x - 1, y );
			if (x < WIDTH-1)
				a += fill( x + 1, y );
			if (y > 0)
				a += fill( x, y - 1 );
			if (y < HEIGHT-1)
				a += fill( x, y + 1 );

			return a;
		}

		var a = fill( x, y );

		return (a == weight || a == weight - 1);
	}

	public function diff( another:Rune ):Int {
		var r = 0;

		for (i in 0...HEIGHT) {
			var row1 = bitmap[i];
			var row2 = another.bitmap[i];
			for (j in 0...WIDTH)
				if (row1[j] != row2[j])
					r++;
		}

		return r;
	}

	private function countNeighbours( x:Int, y:Int, r:Int=1 ):Int {
		var n = 0;

		if (x > r-1 && bitmap[y][x-r])		n++;
		if (x < WIDTH-r && bitmap[y][x+r])	n++;
		if (y > r-1 && bitmap[y-r][x])		n++;
		if (y < HEIGHT-r && bitmap[y+r][x])	n++;

		return n;
	}

	public function mirrorX():Rune {
		var rune = new Rune();
		
		rune.bitmap = [for (i in 0...HEIGHT)
			[for (j in 0...WIDTH)
				bitmap[i][WIDTH - j - 1]
			]
		];

		return rune;
	}

	public function mirrorY():Rune {
		var rune = new Rune();
		
		rune.bitmap = [for (i in 0...HEIGHT)
			[for (j in 0...WIDTH)
				bitmap[HEIGHT - i - 1][j]
			]
		];

		return rune;
	}

	public function rotate180():Rune {
		var rune = new Rune();
		
		rune.bitmap = [for (i in 0...HEIGHT)
			[for (j in 0...WIDTH)
				bitmap[HEIGHT - i - 1][WIDTH - j - 1]
			]
		];

		return rune;
	}

	public function isSymmetric():Bool {
		hSym = true;
		for (row in bitmap)
			if (row[0] != row[4] || row[1] != row[3]) {
				hSym = false;
				break;
			}

		vSym = true;
		for (j in 0...WIDTH)
			if (bitmap[0][j] != bitmap[6][j] || bitmap[1][j] != bitmap[5][j] || bitmap[2][j] != bitmap[4][j]) {
				vSym = false;
				break;
			}

		return hSym || vSym;
	}

	private static inline function coin( chance=0.5 ):Bool
		return (Math.random() < chance);
}
