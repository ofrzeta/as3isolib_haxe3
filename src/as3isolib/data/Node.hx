//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.data;

import as3isolib.events.IsoEvent;
import eDpLib.events.EventDispatcherProxy;
import flash.errors.Error;

/**
 * A base hierachical data structure class.
 */
class Node extends EventDispatcherProxy implements INode
{
	static var _IDCount : Int = 0;
	public var id(get_id, set_id) : String;
	public var name(get_name, set_name) : String;
	public var data(get_data, set_data) : Dynamic;
	public var owner(get_owner, never) : INode;
	public var hasParent(get_hasParent, never) : Bool;
	public var parent(get_parent, never) : INode;
	public var children(get_children, never) : Array<INode>;
	public var numChildren(get_numChildren, never) : Int;
	public var UID : Int;
	var setID : String;

	public function new()
	{
		UID = _IDCount++;
		childrenArray = new Array<INode>();
		super();
	}

	public function get_id() : String
	{
		return (setID == null || setID == "") ? 
			"node" + Std.string(UID) :
			setID;
	}

	public function set_id(value : String) : String
	{
		setID = value;
		return value;
	}

	////////////////////////////////////////////////
	//	NAME
	////////////////////////////////////////////////
	var _name : String;

	public function get_name() : String
	{
		return _name;
	}

	public function set_name(value : String) : String
	{
		_name = value;
		return value;
	}

	////////////////////////////////////////////////////////////////////////
	//	DATA
	////////////////////////////////////////////////////////////////////////
	var _data : Dynamic;
	public function get_data() : Dynamic
	{
		return _data;
	}

	public function set_data(value : Dynamic): Dynamic
	{
		_data = value;
                return true;
	}

	//////////////////////////////////////////////////////////////////
	//	OWNER
	//////////////////////////////////////////////////////////////////
	var ownerObject : Dynamic;

	public function get_owner() : INode
	{
		return (ownerObject != null) ? cast (ownerObject, INode) : parentNode;
	}


	////////////////////////////////////////////////////////////////////////
	//	PARENT
	////////////////////////////////////////////////////////////////////////
	var parentNode : INode;

	public function get_hasParent() : Bool
	{
		return (parentNode != null) ? true : false;
	}

	public function get_parent() : INode
	{
		return parentNode;
	}

	////////////////////////////////////////////////////////////////////////
	//	ROOT NODE
	////////////////////////////////////////////////////////////////////////

	public function get_rootNode() : INode
	{
		var p : INode = this;

		while(p.hasParent)
			p = p.parent;

		return p;
	}

	public function get_descendantNodes(includeBranches : Bool = false) : Array<INode>
	{
		var descendants : Array<INode> = [];
		for(child in childrenArray)
		{
			if(child.children.length > 0) 
			{
				descendants = descendants.concat(child.get_descendantNodes(includeBranches));

				if(includeBranches)
					descendants.push(child);
			}

			else 
				descendants.push(child);
		}

		return descendants;
	}

	////////////////////////////////////////////////////////////////////////
	//	CHILD METHODS
	////////////////////////////////////////////////////////////////////////
	public function contains(value : INode) : Bool
	{
		if(value.hasParent)
			return value.parent == this;

		for(child in childrenArray)
			if(child == value)
				return true;

		return false;
	}

	var childrenArray : Array<INode>;

	public function get_children() : Array<INode>
	{
		return childrenArray;
	}

	public function get_numChildren() : Int
	{
		return childrenArray.length;
	}

	public function addChild(child : INode) : Void
	{
		addChildAt(child, numChildren);
	}

	public function addChildAt(child : INode, index : Int) : Void
	{
		//if it already exists here, do nothing
		if(get_childByID(child.id) != null)
			return;

		//if it has another parent, then remove it there
		if(child.hasParent) 
		{
			var parent : INode = child.parent;
			parent.removeChildByID(child.id);
		}

		(cast(child,Node)).parentNode = this;
		childrenArray.insert(index, child);

		var evt : IsoEvent = new IsoEvent(IsoEvent.CHILD_ADDED);
		evt.newValue = child;

		dispatchEvent(evt);
	}

	public function get_childAt(index : Int) : INode
	{
		if(index >= numChildren) 
			throw new Error("");
		return childrenArray[index];
	}

	public function get_childIndex(child : INode) : Int
	{
		var i : Int = 0;

		while(i < numChildren)
		{
			if(child == childrenArray[i])
				return i;
			i++;
		}

		return -1;
	}

	public function set_childIndex(child : INode, index : Int) : Void
	{
		var i : Int = get_childIndex(child);

		// Don't bother if it's already at this index
		if(i == index) 
			return;

		if(i > -1) 
		{
			childrenArray.splice(i, 1); //remove it form the array

			#if debug
			//now let's check to see if it really did remove the correct choice - this may not be necessary but I get OCD about crap like this
			var notRemoved : Bool = false;
			for(c in childrenArray)
			{
				if(c == child) notRemoved = true;
			}
			if(notRemoved) 
			{
				throw new Error("");
				return;
			}
			#end

			if(index >= numChildren)
				childrenArray.push(child)
			else 
				childrenArray.insert(index, child);
		}
		else 
			throw new Error("");
	}

	public function removeChild(child : INode) : INode
	{
		return removeChildByID(child.id);
	}

	public function removeChildAt(index : Int) : INode
	{
		if(index >= numChildren) 
			return null;

		var child : INode = childrenArray[index];

		return removeChildByID(child.id);
	}

	public function removeChildByID(id : String) : INode
	{
		var child : INode = get_childByID(id);

		if(child != null) 
		{
			//remove parent ref
			cast(child,Node).parentNode = null;

			//remove from children array
			var i : Int = 0;
			while(i < childrenArray.length)
			{
				if(child == childrenArray[i]) 
				{
					childrenArray.splice(i, 1);
					break;
				}
				i++;
			}

			var evt : IsoEvent = new IsoEvent(IsoEvent.CHILD_REMOVED);
			evt.newValue = child;

			dispatchEvent(evt);
		}

		return child;
	}

	public function removeAllChildren() : Void
	{
		for(child in childrenArray)
			cast(child, Node).parentNode = null;

		childrenArray = new Array<INode>();
	}

	public function get_childByID(id : String) : INode
	{
		var childID : String;

		for(child in childrenArray)
		{
			childID = child.id;
			if(childID == id)
				return child;
		}

		return null;
	}
}
