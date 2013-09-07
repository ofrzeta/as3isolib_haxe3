//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package eDpLib.events;

import flash.events.IEventDispatcher;

interface IEventDispatcherProxy extends IEventDispatcher
{
	var proxy(get_proxy, set_proxy) : IEventDispatcher;
	var proxyTarget(get_proxyTarget, set_proxyTarget) : IEventDispatcher;
	function get_proxy() : IEventDispatcher;
	function set_proxy(value : IEventDispatcher) : IEventDispatcher;
	function get_proxyTarget() : IEventDispatcher;
	function set_proxyTarget(value : IEventDispatcher) : IEventDispatcher;
}
