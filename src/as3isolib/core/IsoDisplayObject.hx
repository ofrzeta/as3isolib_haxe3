//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

import as3isolib.bounds.IBounds;
import as3isolib.bounds.PrimitiveBounds;
import as3isolib.data.RenderData;
import as3isolib.events.IsoEvent;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class IsoDisplayObject extends IsoContainer implements IIsoDisplayObject
{
	public var isAnimated(get_isAnimated, set_isAnimated) : Bool;
	public var isoBounds(get_isoBounds, never) : IBounds;
	public var screenBounds(get_screenBounds, never) : Rectangle;
	public var inverseOriginX(get_inverseOriginX, never) : Float;
	public var inverseOriginY(get_inverseOriginY, never) : Float;
	public var x(get_x, set_x) : Float;
	public var screenX(get_screenX, never) : Float;
	public var y(get_y, set_y) : Float;
	public var screenY(get_screenY, never) : Float;
	public var z(get_z, set_z) : Float;
	public var distance(get_distance, set_distance) : Float;
	public var width(get_width, set_width) : Float;
	public var length(get_length, set_length) : Float;
	public var height(get_height, set_height) : Float;
	public var renderAsOrphan(get_renderAsOrphan, set_renderAsOrphan) : Bool;
	var cachedRenderData : RenderData;

	//////////////////////////////////////////////////////////////////
	//	GET RENDER DATA
	//////////////////////////////////////////////////////////////////
	/**
	 * @TODO Serious hack for NME
	 */
	public function get_renderData() : RenderData
	{
		var r : Rectangle = mainContainer.getBounds(mainContainer);
		if(isInvalidated || cachedRenderData==null) 
		{
			var flag : Bool = bRenderAsOrphan; //set to allow for rendering regardless of hierarchy
			bRenderAsOrphan = true;

			render(true);
/*
#if neko
			var fillColor = {a : 0, rgb : 0};
#else
			var fillColor = 0;
#end
*/
			var fillColor = 0;
			var bd : BitmapData = new BitmapData(Std.int(r.width) + 1, Std.int(r.height) + 1, true, fillColor);
			bd.draw(mainContainer, new Matrix(1, 0, 0, 1, -r.left, -r.top));

			var renderData : RenderData = new RenderData();
			renderData.x = mainContainer.x + r.left;
			renderData.y = mainContainer.y + r.top;
			renderData.bitmapData = bd;

			cachedRenderData = renderData;
			bRenderAsOrphan = flag; //set back to original
		}
		else 
		{
			cachedRenderData.x = mainContainer.x + r.left;
			cachedRenderData.y = mainContainer.y + r.top;
		}

		return cachedRenderData;
	}

	////////////////////////////////////////////////////////////////////////
	//	IS ANIMATED
	////////////////////////////////////////////////////////////////////////

	var _isAnimated : Bool;

	public function get_isAnimated() : Bool
	{
		return _isAnimated;
	}

	public function set_isAnimated(value : Bool) : Bool
	{
		_isAnimated = value;
		//mainContainer.cacheAsBitmap = value;
		return value;
	}

	////////////////////////////////////////////////////////////////////////
	//	BOUNDS
	////////////////////////////////////////////////////////////////////////

	var isoBoundsObject : IBounds;

	public function get_isoBounds() : IBounds
	{
		if(isoBoundsObject == null || isInvalidated)
			isoBoundsObject = new PrimitiveBounds(this);

		return isoBoundsObject;
	}

	/**
	 * @TODO Serious hack for NME
	 */
	public function get_screenBounds() : Rectangle
	{
		var screenBounds : Rectangle = mainContainer.getBounds(mainContainer);
		screenBounds.x += mainContainer.x;
		screenBounds.y += mainContainer.y;

		return screenBounds;
	}

	public function get_bounds(targetCoordinateSpace : DisplayObject) : Rectangle
	{
		var rect : Rectangle = screenBounds;

		var pt : Point = new Point(rect.x, rect.y);
		pt = (cast(parent,IIsoContainer)).container.localToGlobal(pt);
		pt = targetCoordinateSpace.globalToLocal(pt);

		rect.x = pt.x;
		rect.y = pt.y;

		return rect;
	}

	public function get_inverseOriginX() : Float
	{
		return IsoMath.isoToScreen(new Pt(x + width, y + length, z)).x;
	}

	public function get_inverseOriginY() : Float
	{
		return IsoMath.isoToScreen(new Pt(x + width, y + length, z)).y;
	}

	/////////////////////////////////////////////////////////
	//	POSITION
	/////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////
	//	X, Y, Z
	////////////////////////////////////////////////////////////////////////

	public function moveTo(x : Float, y : Float, z : Float) : Void
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function moveBy(x : Float, y : Float, z : Float) : Void
	{
		this.x += x;
		this.y += y;
		this.z += z;
	}

	////////////////////////////////////////////////////////////////////////
	//	USE PRECISE VALUES
	////////////////////////////////////////////////////////////////////////

	/**
	 * Flag indicating if positional and dimensional values are rounded to the nearest whole number or not.
	 */
	public var usePreciseValues : Bool;

	////////////////////////////////////////////////////////////////////////
	//	X
	////////////////////////////////////////////////////////////////////////

	/**
	 * @private
	 *
	 * The positional value based on the isometric x-axis.
	 */
	var isoX : Float;
	var oldX : Float;

	// xxx TODO was marked as [Bindable("move")] in original
	public function get_x() : Float
	{
		return isoX;
	}

	public function set_x(value : Float) : Float
	{
		if(!usePreciseValues) 
			value = Math.round(value);

		if(isoX != value) 
		{
			oldX = isoX;

			isoX = value;
			invalidatePosition();

			if(autoUpdate)
				render();
		}
		return value;
	}

	public function get_screenX() : Float
	{
		return IsoMath.isoToScreen(new Pt(x, y, z)).x;
	}

	////////////////////////////////////////////////////////////////////////
	//	Y
	////////////////////////////////////////////////////////////////////////

	var isoY : Float;
	var oldY : Float;

	public function get_y() : Float
	{
		return isoY;
	}

	// xxx TODO marked [Bindable("move")] in original
	public function set_y(value : Float) : Float
	{
		if(!usePreciseValues)
			value = Math.round(value);

		if(isoY != value) 
		{
			oldY = isoY;

			isoY = value;
			invalidatePosition();

			if(autoUpdate)
				render();
		}
		return value;
	}

	public function get_screenY() : Float
	{
		return IsoMath.isoToScreen(new Pt(x, y, z)).y;
	}

	////////////////////////////////////////////////////////////////////////
	//	Z
	////////////////////////////////////////////////////////////////////////

	var isoZ : Float;
	var oldZ : Float;

	public function get_z() : Float
	{
		return isoZ;
	}

	public function set_z(value : Float) : Float
	{
		if(!usePreciseValues)
			value = Math.round(value);

		if(isoZ != value) 
		{
			oldZ = isoZ;

			isoZ = value;
			invalidatePosition();

			if(autoUpdate)
				render();
		}
		return value;
	}

	////////////////////////////////////////////////////////////////////////
	//	DISTANCE
	////////////////////////////////////////////////////////////////////////
		
	var dist : Float;

	public function get_distance() : Float
	{
		return dist;
	}

	public function set_distance(value : Float) : Float
	{
		dist = value;
		return value;
	}

	/////////////////////////////////////////////////////////
	//	GEOMETRY
	/////////////////////////////////////////////////////////

	public function set_size(width : Float, length : Float, height : Float) : Void
	{
		this.width = width;
		this.length = length;
		this.height = height;
	}


	////////////////////////////////////////////////////////////////////////
	//	WIDTH
	////////////////////////////////////////////////////////////////////////

	var isoWidth : Float;
	var oldWidth : Float;

	public function get_width() : Float
	{
		return isoWidth;
	}

	public function set_width(value : Float) : Float
	{
		if(!usePreciseValues)
			value = Math.round(value);

		value = Math.abs(value);

		if(isoWidth != value) 
		{
			oldWidth = isoWidth;

			isoWidth = value;
			invalidateSize();

			if(autoUpdate)
				render();
		}
		return value;
	}

	////////////////////////////////////////////////////////////////////////
	//	LENGTH
	////////////////////////////////////////////////////////////////////////

	var isoLength : Float;
	var oldLength : Float;

	public function get_length() : Float
	{
		return isoLength;
	}

	public function set_length(value : Float) : Float
	{
		if(!usePreciseValues)
			value = Math.round(value);

		value = Math.abs(value);

		if(isoLength != value) 
		{
			oldLength = isoLength;

			isoLength = value;
			invalidateSize();

			if(autoUpdate)
				render();
		}
		return value;
	}

	////////////////////////////////////////////////////////////////////////
	//	HEIGHT
	////////////////////////////////////////////////////////////////////////

	var isoHeight : Float;
	var oldHeight : Float;

	public function get_height() : Float
	{
		return isoHeight;
	}

	public function set_height(value : Float) : Float
	{
		if(!usePreciseValues)
			value = Math.round(value);

		value = Math.abs(value);
		if(isoHeight != value) 
		{
			oldHeight = isoHeight;

			isoHeight = value;
			invalidateSize();

			if(autoUpdate)
				render();
		}
		return value;
	}

	/////////////////////////////////////////////////////////
	//	RENDER AS ORPHAN
	/////////////////////////////////////////////////////////

	var bRenderAsOrphan : Bool;

	public function get_renderAsOrphan() : Bool
	{
		return bRenderAsOrphan;
	}

	public function set_renderAsOrphan(value : Bool) : Bool
	{
		bRenderAsOrphan = value;
		return value;
	}

	/////////////////////////////////////////////////////////
	//	RENDERING
	/////////////////////////////////////////////////////////

	/**
	 * Flag indicating whether a property change will automatically trigger a render phase.
	 */
	public var autoUpdate : Bool;

	override function renderLogic(recursive : Bool = true) : Void
	{
		if(!hasParent && !renderAsOrphan)
			return;

		if(bPositionInvalidated) 
		{
			validatePosition();
			bPositionInvalidated = false;
		}

		if(bSizeInvalidated) 
		{
			validateSize();
			bSizeInvalidated = false;
		}

		//set the flag back for the next time we invalidate the object
		bInvalidateEventDispatched = false;

		super.renderLogic(recursive);
	}

	////////////////////////////////////////////////////////////////////////
	//	INCLUDE LAYOUT
	////////////////////////////////////////////////////////////////////////
	
	/**
	 * @inheritDoc
	 */
	/* override public function set includeInLayout (value:Boolean):void
	   {
	   super.includeInLayout = value;
	   if (includeInLayoutChanged)
	   {
	   if (!bInvalidateEventDispatched)
	   {
	   dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
	   bInvalidateEventDispatched = true;
	   }
	   }
	 } */

	/////////////////////////////////////////////////////////
	//	VALIDATION
	/////////////////////////////////////////////////////////

	/**
	 * Takes the given 3D isometric coordinates and positions them in cartesian coordinates relative to the parent container.
	 */
	function validatePosition() : Void
	{
		var pt : Pt = new Pt(x, y, z);
		IsoMath.isoToScreen(pt);

		mainContainer.x = pt.x;
		mainContainer.y = pt.y;

		var evt : IsoEvent = new IsoEvent(IsoEvent.MOVE, true);
		evt.propName = "position";
		evt.oldValue = { x : oldX, y : oldY, z : oldZ };
		evt.newValue = { x : isoX, y : isoY, z : isoZ };

		dispatchEvent(evt);
	}

	/**
	 * Takes the given 3D isometric sizes and performs the necessary rendering logic.
	 */
	function validateSize() : Void
	{
		var evt : IsoEvent = new IsoEvent(IsoEvent.RESIZE, true);
		evt.propName = "size";
		evt.oldValue = {
			width : oldWidth,
			length : oldLength,
			height : oldHeight,
		};
		evt.newValue = {
			width : isoWidth,
			length : isoLength,
			height : isoHeight,
		};
		dispatchEvent(evt);
	}

	/////////////////////////////////////////////////////////
	//	INVALIDATION
	/////////////////////////////////////////////////////////

	/**
	 * @private
	 *
	 * Flag indicated that an IsoEvent.INVALIDATE has already been dispatched, negating the need to dispatch another.
	 */
	var bInvalidateEventDispatched : Bool;

	var bPositionInvalidated : Bool;

	var bSizeInvalidated : Bool;

	public function invalidatePosition() : Void
	{
		bPositionInvalidated = true;
		if(!bInvalidateEventDispatched) 
		{
			dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
			bInvalidateEventDispatched = true;
		}
	}

	public function invalidateSize() : Void
	{
		bSizeInvalidated = true;
		if(!bInvalidateEventDispatched) 
		{
			dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
			bInvalidateEventDispatched = true;
		}
	}

	override public function get_isInvalidated() : Bool
	{
		return (bPositionInvalidated || bSizeInvalidated);
	}

	/////////////////////////////////////////////////////////
	//	CREATE CHILDREN
	/////////////////////////////////////////////////////////

	override function createChildren() : Void
	{
		super.createChildren();
		mainContainer.cacheAsBitmap = _isAnimated;
	}

	/////////////////////////////////////////////////////////
	//	CLONE
	/////////////////////////////////////////////////////////

	public function clone() : Dynamic
	{
		//var CloneClass : Class<Dynamic> = getDefinitionByName(getQualifiedClassName(this)) as Class;
		//var cloneInstance : IIsoDisplayObject = new CloneClass();
		var CloneClass : Class<IsoDisplayObject> = Type.getClass(this);
		var cloneInstance : IIsoDisplayObject = Type.createInstance(CloneClass,[]);
		cloneInstance.set_size(isoWidth, isoLength, isoHeight);

		return cloneInstance;
	}

	function createObjectFromDescriptor(descriptor : Dynamic) : Void
	{
		var prop : String;
		for(prop in Reflect.fields(descriptor))
		{
			if(Reflect.hasField(this, prop)) 
				Reflect.setField(this, prop, Reflect.field(descriptor,prop));
		}
	}

	public function new(descriptor : Dynamic = null)
	{
		_isAnimated = false;
		usePreciseValues = false;
		isoX = 0;
		isoY = 0;
		isoZ = 0;
		isoWidth = 0;
		isoLength = 0;
		isoHeight = 0;
		bRenderAsOrphan = false;
		autoUpdate = false;
		bInvalidateEventDispatched = false;
		bPositionInvalidated = false;
		bSizeInvalidated = false;

		super();

		if(descriptor) 
			createObjectFromDescriptor(descriptor);
	}
}
