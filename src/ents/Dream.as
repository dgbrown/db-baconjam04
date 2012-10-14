package ents 
{
	import flash.display.BlendMode;
	import flash.display.Shape;
	import org.flixel.*;
	import states.*;
	
	/**
	 * ...
	 * @author Derek brown
	 */
	public class Dream extends FlxSprite 
	{
		
		public static const SIZE_NORMAL:Number = 30.0;
		public static const SIZE_BABY:Number = 5.0;
		
		public var radius:Number;
		public var size:Number; // drawing version of radius
		public var creator:Brainy;
		public var world:Play;
		public var parentDream:Dream;
		private var _shape:Shape;
		private var _fieldRadius:Number;
		private var _fieldRadiusRatio:Number;
		private var _repulseRadius:Number;
		private var _repulseRadiusRatio:Number;
		private var _repulseDecayRate:Number;
		private var _passiveRepulseRadius:Number;
		private var _fieldPenetratedDuration:Number;
		private var _releaseChildDelay:Number;
		private var _targetRadius:Number;
		
		public function Dream( x_:Number = 0, y_:Number = 0, radius_:Number = 30.0 )
		{
			super( x_, y_ );
			radius = _targetRadius = size = radius_;
			_shape = new Shape();
			
			_fieldPenetratedDuration = 0.0;
			
			_repulseRadiusRatio = radius * 0.2;
			_fieldRadiusRatio = radius * 0.225;
			_releaseChildDelay = 4.0; // release a child every 4 seconds of contact
			_passiveRepulseRadius = radius * radius * 0.1 + 200.0;
			_repulseRadius = radius * radius * 0.1;
			_fieldRadius = radius * radius * 0.1 + 10.0;
			_repulseDecayRate = 30.0 * 0.1; // default sized dream should stop repulsing in 10 seconds of contact
			drag.make( _repulseRadius * 2.0, _repulseRadius * 2.0 );
		}
		
		public function releaseChild():void
		{
			if ( world )
			{
				world.add( world.createDream( x, y, Dream.SIZE_BABY, this ) );
			}
		}
		
		public function shrink():void
		{
			_targetRadius = radius - 5.0;
			if ( _targetRadius < SIZE_BABY )
				_targetRadius = SIZE_BABY;
		}
		
		override public function update():void 
		{
			if ( creator )
			{
				var dX:Number = x - creator.centerX;
				var dY:Number = y - creator.centerY;
				var dD:Number = Math.sqrt( dX * dX + dY * dY );
				var a:Number = Math.atan2( dY, dX );
				
				if ( dD < size + creator.radius ) // collision with "creator" aka brainy aka player
				{
					FlxG.play( Assets.SND_CLASS_BIGPICKUP );
					if ( parentDream )
					{
						parentDream.shrink();
						creator.grow( Brainy.GROWTH_BABY_DREAM );
					}
					else // this is a parent
					{
						creator.grow( Brainy.GROWTH_LIFE_DREAM );
					}
					kill();
					return;
				}
				
				if ( creator.fulfilled )
				{
					velocity.x = Math.cos( a ) * -80;
					velocity.y = Math.sin( a ) * -80;
				}
				else
				{
					// energy field collisions
					if ( dD < radius + _fieldRadius + creator.radius )
					{
						if ( radius > SIZE_BABY && _fieldPenetratedDuration >= _releaseChildDelay )
						{
							_fieldPenetratedDuration = 0.0;
							releaseChild();
						}
						else
						{
							_fieldPenetratedDuration += FlxG.elapsed;
						}
					}
					else
					{
						_fieldPenetratedDuration = 0.0;
					}
					
					// repulsion field collisions
					var repulsionMinDist:Number = radius + _repulseRadius + creator.radius;
					if ( dD <= repulsionMinDist )
					{
						velocity.x = (repulsionMinDist - dD) * Math.cos( a ) * 8.0;
						velocity.y = (repulsionMinDist - dD) * Math.sin( a ) * 8.0;
					}
					else if ( dD <= radius + _passiveRepulseRadius + creator.radius )
					{
						velocity.x = 20.0 * Math.cos( a );
						velocity.y = 20.0 * Math.sin( a );
					}
					
					if ( radius > _targetRadius )
					{
						radius *= 0.999;
						_repulseRadius = radius * radius * 0.1;
						_fieldRadius = radius * radius * 0.1 + 10.0;
						_passiveRepulseRadius = radius * radius * 0.1 + 200.0;
					}
				}
			}
			super.update();
		}
		
		override public function draw():void 
		{
			// prepare dimensions
			var drawWidth:Number = size + Math.sin( FlxU.getTicks() * 0.005 + Math.PI * 0.54321 ) * (size*0.08);
			var drawHeight:Number = size + Math.cos( FlxU.getTicks() * 0.0025 + Math.PI * 0.333 ) * (size*0.08);
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
			_matrix.rotate( Math.PI * ( Math.sin( FlxU.getTicks() * 0.001 ) + Math.cos( FlxU.getTicks() * 0.0001 + Math.sin( FlxU.getTicks() * 0.000666 ) * Math.PI ) ) * 0.5 );
			_matrix.translate( screenX, screenY );
			FlxG.camera.buffer.draw( _shape, _matrix, null, null, null, true );
			
			if( FlxG.visualDebug )
				drawDebug();
		}
		
		override public function drawDebug(Camera:FlxCamera = null):void 
		{	
			var screenX:Number = x - FlxG.camera.scroll.x * scrollFactor.x;
			var screenY:Number = y - FlxG.camera.scroll.y * scrollFactor.y;
			// size
			_shape.graphics.clear();
			_shape.graphics.lineStyle( 1, 0xFF0000 );
			_shape.graphics.drawCircle( 0, 0, radius );
			_matrix.identity();
			_matrix.translate( screenX, screenY );
			FlxG.camera.buffer.draw( _shape, _matrix, null, null, null, true );
			// repulsion
			_shape.graphics.clear();
			_shape.graphics.lineStyle( 1, 0xFF0000 );
			_shape.graphics.drawCircle( 0, 0, radius + _repulseRadius );
			_matrix.identity();
			_matrix.translate( screenX, screenY );
			FlxG.camera.buffer.draw( _shape, _matrix, null, null, null, true );
			// field
			_shape.graphics.clear();
			_shape.graphics.lineStyle( 1, 0xFF0000 );
			_shape.graphics.drawCircle( 0, 0, radius + _fieldRadius );
			_matrix.identity();
			_matrix.translate( screenX, screenY );
			FlxG.camera.buffer.draw( _shape, _matrix, null, null, null, true );
			// passive repulsion
			// field
			_shape.graphics.clear();
			_shape.graphics.lineStyle( 1, 0x00FFFF );
			_shape.graphics.drawCircle( 0, 0, radius + _passiveRepulseRadius );
			_matrix.identity();
			_matrix.translate( screenX, screenY );
			FlxG.camera.buffer.draw( _shape, _matrix, null, null, null, true );
		}
		
	}

}