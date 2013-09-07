//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.bounds;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.geom.Pt;

class PrimitiveBounds implements IBounds
{
	public var volume(get_volume, never) : Float;
	public var width(get_width, never) : Float;
	public var length(get_length, never) : Float;
	public var height(get_height, never) : Float;
	public var left(get_left, never) : Float;
	public var right(get_right, never) : Float;
	public var back(get_back, never) : Float;
	public var front(get_front, never) : Float;
	public var bottom(get_bottom, never) : Float;
	public var top(get_top, never) : Float;
	public var centerPt(get_centerPt, never) : Pt;
	public function get_volume() : Float
	{
		return _target.width * _target.length * _target.height;
	}
	public function get_width() : Float
	{
		return _target.width;
	}
	public function get_length() : Float
	{
		return _target.length;
	}
	public function get_height() : Float
	{
		return _target.height;
	}
	public function get_left() : Float
	{
		return _target.x;
	}
	public function get_right() : Float
	{
		return _target.x + _target.width;
	}
	public function get_back() : Float
	{
		return _target.y;
	}
	public function get_front() : Float
	{
		return _target.y + _target.length;
	}
	public function get_bottom() : Float
	{
		return _target.z;
	}
	public function get_top() : Float
	{
		return _target.z + _target.height;
	}
	public function get_centerPt() : Pt
	{
		var pt : Pt = new Pt();
		pt.x = _target.x + _target.width / 2;
		pt.y = _target.y + _target.length / 2;
		pt.z = _target.z + _target.height / 2;
		return pt;
	}
	public function get_pts() : Array<Pt>
	{
		var a : Array<Pt> = [];
		a.push(new Pt(left, back, bottom));
		a.push(new Pt(right, back, bottom));
		a.push(new Pt(right, front, bottom));
		a.push(new Pt(left, front, bottom));
		a.push(new Pt(left, back, top));
		a.push(new Pt(right, back, top));
		a.push(new Pt(right, front, top));
		a.push(new Pt(left, front, top));
		return a;
	}
	public function intersects(bounds : IBounds) : Bool
	{
		if(Math.abs(centerPt.x - bounds.centerPt.x) <= _target.width / 2 + bounds.width / 2 && Math.abs(centerPt.y - bounds.centerPt.y) <= _target.length / 2 + bounds.length / 2 && Math.abs(centerPt.z - bounds.centerPt.z) <= _target.height / 2 + bounds.height / 2) return true		else return false;
	}
	public function containsPt(target : Pt) : Bool
	{
		if((left <= target.x && target.x <= right) && (back <= target.y && target.y <= front) && (bottom <= target.z && target.z <= top)) 
		{
			return true;
		}
		else return false;
	}
	var _target : IIsoDisplayObject;
	public function new(target : IIsoDisplayObject)
	{
		this._target = target;
	}
}
