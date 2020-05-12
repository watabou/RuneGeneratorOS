package com.watabou.runegenerator;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

class BmpButton extends Sprite {

	public function new( bmp:BitmapData, handler:Void->Void ) {
		super();

		addChild( new Bitmap( bmp ) );

		buttonMode = true;
		addEventListener( MouseEvent.MOUSE_DOWN, (e)->handler() );
	}

	public static function fromAsset( bmpID:String, handler:()->Void ):BmpButton {
		return new BmpButton( Assets.getBitmapData( bmpID ), handler );
	}
}
