package ents 
{
	import flash.display.BlendMode;
	import flash.display.Shape;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Derek brown
	 */
	public class Dream extends FlxSprite 
	{
		
		public var size:Number;
		public var creator:FlxSprite;
		private var _shape:Shape;
		private var _repulseRadius:Number;
		private var _repulseDecayRate:Number;
		
		public function Dream( x_:Number = 0, y_:Number = 0, size_:Number = 30.0 )
		{
			super( x_, y_ );
			size = size_;
			_shape = new Shape();
			
			_repulseRadius = size_ * 1.333;
			_repulseDecayRate = 30.0 * 0.1; // default sized dream should stop repulsing in 10 seconds of contact
			drag.make( _repulseRadius * 2.0, _repulseRadius * 2.0 );
		}
		
		override public function update():void 
		{
			if ( creator )
			{
				var dX:Number = x - creator.x;
				var dY:Number = y - creator.y;
				var dD:Number = Math.sqrt( dX * dX + dY * dY );
				
				if ( dD < size + _repulseRadius + creator.width )
				{
					var a:Number = Math.atan2( dY, dX );
					velocity.x = dD * Math.cos( a );
					velocity.y = dD * Math.sin( a );
				}
				
				_repulseRadius -= _repulseDecayRate * FlxG.elapsed;
			}
			super.update();
		}
		
		override public function draw():void 
		{
			// prepare dimensions
			var drawWidth:Number = size + Math.sin( FlxU.getTicks() * 0.005 ) * (size*0.05);
			var drawHeight:Number = size + Math.cos( FlxU.getTicks() * 0.0025 ) * (size*0.05);
			var screenX:Number = x - FlxG.camera.scroll.x * scrollFactor.x;
			var screenY:Number = y - FlxG.camera.scroll.y * scrollFactor.y;
			
			// first pass
			_shape.graphics.clear();
			_shape.graphics.beginFill( 0x6CC0FF );
			_shape.graphics.drawEllipse( -drawWidth * 0.5, -drawHeight * 0.5, drawWidth, drawHeight );
			_shape.graphics.endFill();
			_matrix.identity();
			_matrix.translate( screenX, screenY );
			FlxG.camera.buffer.draw( _shape, _matrix, null, null, null, true );
			// second pass
			_shape.graphics.clear();
			_shape.graphics.beginFill( 0x6CC0FF, 0.666 );
			_shape.graphics.drawEllipse( -drawHeight, -drawWidth, drawHeight * 2.0, drawWidth * 2.0 );
			_shape.graphics.endFill();
			_matrix.identity();
			_matrix.rotate( Math.PI * Math.sin( FlxU.getTicks() * 0.001 ) );
			_matrix.translate( screenX, screenY );
			FlxG.camera.buffer.draw( _shape, _matrix, null, null, null, true );
		}
		
	}

}