//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

interface IInvalidation
{
	var isInvalidated(get_isInvalidated, never) : Bool;
	function get_isInvalidated() : Bool;
}
