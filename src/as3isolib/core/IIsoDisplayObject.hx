//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

import as3isolib.bounds.IBounds;
import as3isolib.data.RenderData;
import flash.display.DisplayObject;
import flash.geom.Rectangle;

interface IIsoDisplayObject extends IIsoContainer
{
	var usePreciseValues : Bool;
	var renderAsOrphan(get_renderAsOrphan, set_renderAsOrphan) : Bool;
	var isoBounds(get_isoBounds, never) : IBounds;
	var screenBounds(get_screenBounds, never) : Rectangle;
	var inverseOriginX(get_inverseOriginX, never) : Float;
	var inverseOriginY(get_inverseOriginY, never) : Float;
	var isAnimated(get_isAnimated, set_isAnimated) : Bool;
	var x(get_x, set_x) : Float;
	var y(get_y, set_y) : Float;
	var z(get_z, set_z) : Float;
	var screenX(get_screenX, never) : Float;
	var screenY(get_screenY, never) : Float;
	var distance(get_distance, set_distance) : Float;
	var width(get_width, set_width) : Float;
	var length(get_length, set_length) : Float;
	var height(get_height, set_height) : Float;
	function get_renderData() : RenderData;
	function get_renderAsOrphan() : Bool;
	function set_renderAsOrphan(value : Bool) : Bool;
	function get_isoBounds() : IBounds;
	function get_screenBounds() : Rectangle;
	function get_bounds(targetCoordinateSpace : DisplayObject) : Rectangle;
	function get_inverseOriginX() : Float;
	function get_inverseOriginY() : Float;
	function moveTo(x : Float, y : Float, z : Float) : Void;
	function moveBy(x : Float, y : Float, z : Float) : Void;
	function get_isAnimated() : Bool;
	function set_isAnimated(value : Bool) : Bool;
	function get_x() : Float;
	function set_x(value : Float) : Float;
	function get_y() : Float;
	function set_y(value : Float) : Float;
	function get_z() : Float;
	function set_z(value : Float) : Float;
	function get_screenX() : Float;
	function get_screenY() : Float;
	function get_distance() : Float;
	function set_distance(value : Float) : Float;
	function set_size(width : Float, length : Float, height : Float) : Void;
	function get_width() : Float;
	function set_width(value : Float) : Float;
	function get_length() : Float;
	function set_length(value : Float) : Float;
	function get_height() : Float;
	function set_height(value : Float) : Float;
	function invalidatePosition() : Void;
	function invalidateSize() : Void;
	function clone() : Dynamic;
}
