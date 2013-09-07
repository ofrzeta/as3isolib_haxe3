//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.scene;

import as3isolib.bounds.IBounds;
import as3isolib.core.IIsoContainer;
import flash.display.DisplayObjectContainer;

interface IIsoScene extends IIsoContainer
{
	var isoBounds(get_isoBounds, never) : IBounds;
	var invalidatedChildren(get_invalidatedChildren, never) : Array<IIsoContainer>;
	var hostContainer(get_hostContainer, set_hostContainer) : DisplayObjectContainer;
	function get_isoBounds() : IBounds;
	function get_invalidatedChildren() : Array<IIsoContainer>;
	function get_hostContainer() : DisplayObjectContainer;
	function set_hostContainer(value : DisplayObjectContainer) : DisplayObjectContainer;
}
