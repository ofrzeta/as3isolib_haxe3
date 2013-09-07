//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

import as3isolib.data.INode;
import flash.display.Sprite;

interface IIsoContainer extends INode extends IInvalidation
{
	var includeInLayout(get_includeInLayout, set_includeInLayout) : Bool;
	var displayListChildren(get_displayListChildren, never) : Array<IIsoContainer>;
	var depth(get_depth, never) : Int;
	var container(get_container, never) : Sprite;
	function get_includeInLayout() : Bool;
	function set_includeInLayout(value : Bool) : Bool;
	function get_displayListChildren() : Array<IIsoContainer>;
	function get_depth() : Int;
	function get_container() : Sprite;
	function render(recursive : Bool = true) : Void;
}
