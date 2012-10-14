package ents 
{
	import flash.display.Shape;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Derek brown
	 */
	public class Distraction extends FlxSprite 
	{
		
		public var radius:Number;
		public var spawnMark:Number;
		private var _shape:Shape;
		private var _alphaRegenRate:Number;
		
		public function Distraction( x_:Number = 0, y_:Number = 0 )
		{
			super( x_, y_ );
			loadGraphic( Assets.IMG_CLASS_DISTRACTIONS, true, false, 32, 32 );
			frame = Math.floor( Math.random() * 8 );
			
			_alphaRegenRate = 4.0;
			spawnMark = 0;
			
			radius = 15.0;
			
			_shape = new Shape();
		}
		
		public function get centerX():Number { return x + width * 0.5; }
		public function get centerY():Number { return y + height * 0.5; }
		public function get screenX():Number { return centerX - FlxG.camera.scroll.x * scrollFactor.x; }
		public function get screenY():Number { return centerY - FlxG.camera.scroll.y * scrollFactor.y; }
		
		public function spawn():void
		{
			reset( x, y );
			alpha = 0;
			spawnMark = FlxU.getTicks();
		}
		
		override public function update():void 
		{
			if ( alive )
			{
				if ( alpha < 1 )
					alpha += _alphaRegenRate * FlxG.elapsed;
			}
			super.update();
		}
		
		override public function draw():void 
		{
			if ( alive )
			{
				var drawWidth:Number = 20.0;
				var drawHeight:Number = 6.0;
				
				_shape.graphics.clear();
				_shape.graphics.beginFill( 0x000044, alpha * 0.4 );
				_shape.graphics.drawEllipse( -drawWidth * 0.5, -drawHeight * 0.5, drawWidth, drawHeight );
				_shape.graphics.endFill();
				_matrix.identity();
				_matrix.translate( screenX, screenY + 20.0 );
				FlxG.camera.buffer.draw( _shape, _matrix );
				super.draw();
			}
		}
		
		override public function drawDebug(Camera:FlxCamera = null):void 
		{
			//super.drawDebug(Camera);
			_shape.graphics.clear();
			_shape.graphics.lineStyle( 1, 0xFF0000 );
			_shape.graphics.drawCircle( 0, 0, radius );
			_matrix.identity();
			_matrix.translate( screenX, screenY );
			FlxG.camera.buffer.draw( _shape, _matrix );
		}
		
	}

}