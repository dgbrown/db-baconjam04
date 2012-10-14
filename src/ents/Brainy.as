package ents 
{
	import flash.display.Shape;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Derek brown
	 */
	public class Brainy extends FlxSprite 
	{
		public var dying:Boolean;
		public var fulfilled:Boolean;
		public var fulfillment:Number;
		public var radius:Number;
		private var _shape:Shape;
		private var _halfWidth:Number;
		private var _halfHeight:Number;
		private var _fulfillmentDrainRate:Number;
		private var _idealFulfillment:Number;
		private var _shadowSize:Number;
		
		public static const GROWTH_LIFE_DREAM:Number = 50.0;
		public static const GROWTH_BABY_DREAM:Number = 15.0;
		public static const GROWTH_DISTRACTION:Number = 14;
		
		public function Brainy( x_:Number = 0, y_:Number = 0 ) 
		{
			super( x_, y_ );
			loadGraphic( Assets.IMG_CLASS_BRAINY, true, false, 64, 64 );
			
			maxVelocity.make( 100, 100 );
			drag.make( 225, 225 );
			
			dying = false;
			fulfilled = false;
			radius = 22.5;
			_idealFulfillment = 100.0;
			fulfillment = _idealFulfillment * 0.33;
			_fulfillmentDrainRate = 1.7;
			_shadowSize = 8.0;
			
			_shape = new Shape();
			
			_halfWidth = width * 0.5;
			_halfHeight = height * 0.5;
		}
		
		public function get centerX():Number { return x + _halfWidth; }
		public function get centerY():Number { return y + _halfHeight; }
		public function get screenX():Number { return centerX - FlxG.camera.scroll.x * scrollFactor.x; }
		public function get screenY():Number { return centerY - FlxG.camera.scroll.y * scrollFactor.y; }
		
		public function grow( amount_:Number ):void
		{
			fulfillment += amount_;
			if ( amount_ == GROWTH_LIFE_DREAM )
			{
				fulfillment = 1000.0;
				fulfilled = true;
			}
			else if ( amount_ == GROWTH_DISTRACTION )
			{
				if ( fulfillment > _idealFulfillment )
					fulfillment = _idealFulfillment;
			}
		}
		
		override public function update():void 
		{
			if ( !dying )
			{
				var animFrame:uint;
				if ( fulfilled )
					animFrame = 6;
				else
				{
					animFrame = Math.floor( fulfillment / ( _idealFulfillment / 6.0 ) );
					if ( animFrame > 5 )
					animFrame = 5;
				}
				frame = animFrame;
				
				_shadowSize =  5 + frame;
				
				if ( !fulfilled )
				{
					fulfillment -= _fulfillmentDrainRate * FlxG.elapsed;
					if ( fulfillment < 0 )
						dying = true;
				}
				
				super.update();
			}
			else
			{
				
			}
		}
		
		override public function draw():void 
		{
			_shape.graphics.clear();
			_shape.graphics.beginFill( 0x000044, 0.4 );
			_shape.graphics.drawEllipse( -2.25 * _shadowSize, -_shadowSize * 0.5, _shadowSize * 4.5, _shadowSize );
			_shape.graphics.endFill();
			_matrix.identity();
			_matrix.translate( screenX, screenY + 25.0 );
			FlxG.camera.buffer.draw( _shape, _matrix );
			super.draw();
		}
		
		override public function drawDebug(Camera:FlxCamera = null):void 
		{
			_shape.graphics.clear();
			_shape.graphics.lineStyle( 1, 0xFF0000 );
			_shape.graphics.drawCircle( 0, 0, radius );
			_matrix.identity();
			_matrix.translate( screenX, screenY );
			FlxG.camera.buffer.draw( _shape, _matrix );
		}
		
	}

}