//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.graphics;

import flash.geom.Matrix;

interface IBitmapFill extends IFill
{
	var matrix(get_matrix, set_matrix) : Matrix;
	var repeat(get_repeat, set_repeat) : Bool;
	function get_matrix() : Matrix;
	function set_matrix(value : Matrix) : Matrix;
	function get_repeat() : Bool;
	function set_repeat(value : Bool) : Bool;
}
