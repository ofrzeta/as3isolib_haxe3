//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.bounds;

import as3isolib.geom.Pt;

interface IBounds
{
	var width(get_width, never) : Float;
	var length(get_length, never) : Float;
	var height(get_height, never) : Float;
	var left(get_left, never) : Float;
	var right(get_right, never) : Float;
	var back(get_back, never) : Float;
	var front(get_front, never) : Float;
	var bottom(get_bottom, never) : Float;
	var top(get_top, never) : Float;
	var centerPt(get_centerPt, never) : Pt;
	function get_width() : Float;
	function get_length() : Float;
	function get_height() : Float;
	function get_left() : Float;
	function get_right() : Float;
	function get_back() : Float;
	function get_front() : Float;
	function get_bottom() : Float;
	function get_top() : Float;
	function get_centerPt() : Pt;
	function get_pts() : Array<Pt>;
	function intersects(bounds : IBounds) : Bool;
	function containsPt(target : Pt) : Bool;
}
