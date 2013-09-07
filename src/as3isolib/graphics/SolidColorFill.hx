//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.graphics;

import flash.display.Graphics;

class SolidColorFill implements IFill
{
	static var _IDCount : Int = 0;

	public var id(get_id, set_id) : String;
	public var UID : Int;
	public var color : Int;
	public var alpha : Float;

	var setID : String;

	public function new(color : Int, alpha : Float)
	{
		UID = _IDCount++;
		this.color = color;
		this.alpha = alpha;
	}

	public function get_id() : String
	{
		return (setID == null || setID == "") ? "SolidColorFill " + Std.string(UID) : setID;
	}

	public function set_id(value : String) : String
	{
		setID = value;
		return value;
	}

	public function begin(target : Graphics) : Void
	{
		target.beginFill(color, alpha);
	}

	public function end(target : Graphics) : Void
	{
		target.endFill();
	}

	public function clone() : IFill
	{
		return new SolidColorFill(color, alpha);
	}
}
