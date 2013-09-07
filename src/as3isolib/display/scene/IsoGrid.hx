//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.scene;

import as3isolib.display.primitive.IsoPrimitive;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;
import as3isolib.graphics.IStroke;
import as3isolib.graphics.Stroke;
import flash.display.Graphics;
import flash.errors.Error;

/**
 * IsoGrid provides a display grid in the X-Y plane.
 */
class IsoGrid extends IsoPrimitive
{
	public var gridSize(get_gridSize, never) : Array<Int>;
	public var cellSize(get_cellSize, set_cellSize) : Float;
	public var origin(get_origin, never) : IsoOrigin;
	public var showOrigin(get_showOrigin, set_showOrigin) : Bool;
	public var gridlines(get_gridlines, set_gridlines) : IStroke;
	var gSize : Array<Int>;

	public function get_gridSize() : Array<Int>
	{
		return gSize;
	}

	public function set_gridSize(width : Int, length : Int, height : Int = 0) : Void
	{
		if(gSize[0] != width || gSize[1] != length || gSize[2] != height) 
		{
			gSize = [width, length, height];
			invalidateSize();
		}
	}

	var cSize : Float;
	public function get_cellSize() : Float
	{
		return cSize;
	}

	public function set_cellSize(value : Float) : Float
	{
		if(value < 2) 
			throw new Error("cellSize must be a positive value greater than 2");

		if(cSize != value) 
		{
			cSize = value;
			invalidateSize();
		}
		return value;
	}

	var bShowOrigin : Bool;
	var showOriginChanged : Bool;
	public function get_origin() : IsoOrigin
	{
		if(_origin == null) 
			_origin = new IsoOrigin();

		return _origin;
	}

	public function get_showOrigin() : Bool
	{
		return bShowOrigin;
	}

	/**
	 * Flag determining if the origin is visible.
	 */
	public function set_showOrigin(value : Bool) : Bool
	{
		if(bShowOrigin != value) 
		{
			bShowOrigin = value;
			showOriginChanged = true;
			invalidateSize();
		}
		return value;
	}

	public function get_gridlines() : IStroke
	{
		return strokes[0];
	}

	public function set_gridlines(value : IStroke) : IStroke
	{
		strokes = [value];
		return value;
	}

	public function new(descriptor : Dynamic = null)
	{
		gSize = [0, 0];
		bShowOrigin = false;
		showOriginChanged = false;
		super(descriptor);
		if(descriptor == null) 
		{
			showOrigin = true;
			gridlines = new Stroke(0, 0xCCCCCC, 0.5);
			cellSize = 25;
			set_gridSize(5, 5);
		}
	}

	var _origin : IsoOrigin;
	override function renderLogic(recursive : Bool = true) : Void
	{
		if(showOriginChanged) 
		{
			if(showOrigin) 
			{
				if(!contains(origin))
					addChildAt(origin, 0);
			}
			else 
			{
				if(contains(origin))
					removeChild(origin);
			}
			showOriginChanged = false;
		}

		super.renderLogic(recursive);
	}

	override function drawGeometry() : Void
	{
		var g : Graphics = mainContainer.graphics;
		g.clear();

		var stroke : IStroke = strokes[0];
		if(stroke != null)
			stroke.apply(g);

		var pt : Pt = new Pt();
		var i : Int = 0;
		var m : Int = Std.int(gridSize[0]);
		while(i <= m)
		{
			pt = IsoMath.isoToScreen(new Pt(cSize * i));
			g.moveTo(pt.x, pt.y);

			pt = IsoMath.isoToScreen(new Pt(cSize * i, cSize * gridSize[1]));
			g.lineTo(pt.x, pt.y);

			i++;
		}

		i = 0;
		m = Std.int(gridSize[1]);
		while(i <= m)
		{
			pt = IsoMath.isoToScreen(new Pt(0, cSize * i));
			g.moveTo(pt.x, pt.y);

			pt = IsoMath.isoToScreen(new Pt(cSize * gridSize[0], cSize * i));
			g.lineTo(pt.x, pt.y);

			i++;
		}

		//now add the invisible layer to receive mouse events
		pt = IsoMath.isoToScreen(new Pt(0, 0));
		g.moveTo(pt.x, pt.y);
		g.lineStyle(0, 0, 0);
		g.beginFill(0xFF0000, 0.0);

		pt = IsoMath.isoToScreen(new Pt(cSize * gridSize[0], 0));
		g.lineTo(pt.x, pt.y);

		pt = IsoMath.isoToScreen(new Pt(cSize * gridSize[0], cSize * gridSize[1]));
		g.lineTo(pt.x, pt.y);

		pt = IsoMath.isoToScreen(new Pt(0, cSize * gridSize[1]));
		g.lineTo(pt.x, pt.y);

		pt = IsoMath.isoToScreen(new Pt(0, 0));
		g.lineTo(pt.x, pt.y);
		g.endFill();
	}
}
