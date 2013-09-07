//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.data;

import eDpLib.events.IEventDispatcherProxy;

interface INode extends IEventDispatcherProxy
{
	var id(get_id, set_id) : String;
	var name(get_name, set_name) : String;
	var data(get_data, set_data) : Dynamic;
	var owner(get_owner, never) : INode;
	var hasParent(get_hasParent, never) : Bool;
	var parent(get_parent, never) : INode;
	var children(get_children, never) : Array<INode>;
	var numChildren(get_numChildren, never) : Int;


	function get_id() : String;
	function set_id(value : String) : String;
	function get_name() : String;
	function set_name(value : String) : String;
	function get_data() : Dynamic;
	function set_data(value : Dynamic) : Dynamic;
	function get_owner() : INode;
	function get_parent() : INode;
	function get_hasParent() : Bool;
	function get_rootNode() : INode;
	function get_descendantNodes(includeBranches : Bool = false) : Array<INode>;
	function contains(value : INode) : Bool;
	function get_children() : Array<INode>;
	function get_numChildren() : Int;
	function addChild(child : INode) : Void;
	function addChildAt(child : INode, index : Int) : Void;
	function get_childIndex(child : INode) : Int;
	function get_childAt(index : Int) : INode;
	function get_childByID(id : String) : INode;
	function set_childIndex(child : INode, index : Int) : Void;
	function removeChild(child : INode) : INode;
	function removeChildAt(index : Int) : INode;
	function removeChildByID(id : String) : INode;
	function removeAllChildren() : Void;
}
