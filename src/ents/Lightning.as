package ents 
{
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Derek brown
	 */
	public class Lightning extends FlxSprite 
	{
		
		public var creator:Brainy;
		private var _shape:Shape;
		private var _colTransform:ColorTransform;
		private var _points:Array;
		
		public function Lightning() 
		{
			super();
			_shape = new Shape();
			_points = new Array();
			_colTransform = new ColorTransform();
		}
		
		public function spawn( toPoint_:Point ):void
		{
			if ( !creator )
				return;
			reset( x, y );
			_points.length = 0;
			_points.push( new Point( 0, 0 ) );
			// awesome generation algo here
			var toPoint:Point = toPoint_.clone();
			toPoint.x -= creator.centerX;
			toPoint.y -= creator.centerY;
			_points.push( toPoint );
			cacheShape();
			alpha = 1;
		}
		
		override public function update():void 
		{
			if ( alpha > 0 )
				alpha -= FlxG.elapsed * 4.0;
			else
				kill();
			super.update();
			
			if ( creator )
			{
				x = creator.x;
				y = creator.y;
			}
		}
		
		public function cacheShape():void
		{
			_shape.graphics.clear();
			// first pass
			_shape.graphics.lineStyle( 4, 0xFAFF1C );
			_shape.graphics.moveTo( 0, 0 );
			for ( var i:int = 1; i < _points.length; ++i )
				_shape.graphics.lineTo( _points[i].x, _points[i].y );
			// second pass
			_shape.graphics.lineStyle( 3, 0xFFFFFF );
			_shape.graphics.moveTo( 0, 0 );
			for ( var j:int = 1; j < _points.length; ++j )
				_shape.graphics.lineTo( _points[j].x, _points[j].y );
		}
		
		override public function draw():void
		{
			_matrix.identity();
			_matrix.translate( creator.screenX, creator.screenY );
			_colTransform.alphaMultiplier = alpha;
			FlxG.camera.buffer.draw( _shape, _matrix, _colTransform );
		}
		
	}

}