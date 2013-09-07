//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.scene;

import as3isolib.bounds.IBounds;
import as3isolib.bounds.SceneBounds;
import as3isolib.core.ClassFactory;
import as3isolib.core.IFactory;
import as3isolib.core.IIsoContainer;
import as3isolib.core.IIsoDisplayObject;
import as3isolib.core.IsoContainer;
import as3isolib.data.INode;
import as3isolib.display.renderers.DefaultSceneLayoutRenderer;
import as3isolib.display.renderers.ISceneLayoutRenderer;
import as3isolib.display.renderers.ISceneRenderer;
import as3isolib.events.IsoEvent;
import flash.display.DisplayObjectContainer;

import flash.errors.Error;

using as3isolib.ArrayUtil;

class IsoScene extends IsoContainer implements IIsoScene
{
	public var isoBounds(get_isoBounds, never) : IBounds;
	public var hostContainer(get_hostContainer, set_hostContainer) : DisplayObjectContainer;
	public var invalidatedChildren(get_invalidatedChildren, never) : Array<IIsoContainer>;
	public var layoutRenderer(get_layoutRenderer, set_layoutRenderer) : Dynamic;
	public var styleRenderers(get_styleRenderers, set_styleRenderers) : Iterable <ISceneLayoutRenderer>;

	var _isoBounds : IBounds;
	public function get_isoBounds() : IBounds
	{
		return new SceneBounds(this);
	}

	var host : DisplayObjectContainer;
	public function get_hostContainer() : DisplayObjectContainer
	{
		return host;
	}

	public function set_hostContainer(value : DisplayObjectContainer) : DisplayObjectContainer
	{
		if(value != null && host != value) 
		{
			if(host != null && host.contains(container)) 
			{
				host.removeChild(container);
				ownerObject = null;
			}
			else if(hasParent) parent.removeChild(this);
			host = value;
			if(host != null) 
			{
				host.addChild(container);
				ownerObject = host;
				parentNode = null;
			}
		}
		return value;
	}

	var invalidatedChildrenArray : Array<IIsoContainer>;
	public function get_invalidatedChildren() : Array<IIsoContainer>
	{
		return invalidatedChildrenArray;
	}

	override public function addChildAt(child : INode, index : Int) : Void
	{
		if(Std.is(child, IIsoDisplayObject)) 
		{
			super.addChildAt(child, index);
			child.addEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
			bIsInvalidated = true;
		}
		else throw new Error("parameter child is not of type IIsoDisplayObject");
	}

	override public function set_childIndex(child : INode, index : Int) : Void
	{
		super.set_childIndex(child, index);
		bIsInvalidated = true;
	}

	override public function removeChildByID(id : String) : INode
	{
		var child : INode = super.removeChildByID(id);
		if(child != null) 
		{
			child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
			bIsInvalidated = true;
		}
		return child;
	}

	override public function removeAllChildren() : Void
	{
		var child : INode;
		for(child in children)
			child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
		super.removeAllChildren();
		bIsInvalidated = true;
	}

	function child_invalidateHandler(evt : IsoEvent) : Void
	{
		var child = evt.target;
		if(invalidatedChildrenArray.indexOf(child) == -1)
			invalidatedChildrenArray.push(child);
		bIsInvalidated = true;
	}

	public var layoutEnabled : Bool;
	var bLayoutIsFactory : Bool;
	var layoutObject : Dynamic;

	public function get_layoutRenderer() : Dynamic
	{
		return layoutObject;
	}

	public function set_layoutRenderer(value : Dynamic): Dynamic
	{
		if(!value) 
		{
			layoutObject = new ClassFactory(DefaultSceneLayoutRenderer);
			bLayoutIsFactory = true;
			bIsInvalidated = true;
		}
		if(value && layoutObject != value) 
		{
			if(Std.is(value, IFactory)) bLayoutIsFactory = true;
			else if(Std.is(value,ISceneLayoutRenderer)) bLayoutIsFactory = false;
			else throw new Error("value for layoutRenderer is not of type IFactory or ISceneLayoutRenderer");
			layoutObject = value;
			bIsInvalidated = true;
		}
                return 0;
	}

	public var stylingEnabled : Bool;
	var styleRendererFactories : Iterable <ISceneLayoutRenderer>;

	public function get_styleRenderers() : Iterable <ISceneLayoutRenderer>
	{
		return styleRendererFactories;
	}

	public function set_styleRenderers(value : Iterable <ISceneLayoutRenderer>) : Iterable <ISceneLayoutRenderer>
	{
		if(value != null) styleRendererFactories = value;
		else styleRendererFactories = null;
		bIsInvalidated = true;
		return value;
	}

	public function invalidateScene() : Void
	{
		bIsInvalidated = true;
	}

	override function renderLogic(recursive : Bool = true) : Void
	{
		super.renderLogic(recursive);
		if(bIsInvalidated) 
		{
			if(layoutEnabled) 
			{
				var sceneLayoutRenderer : ISceneLayoutRenderer;
				if(bLayoutIsFactory) 
					sceneLayoutRenderer = (cast(layoutObject,IFactory)).newInstance();
				else 
					sceneLayoutRenderer = cast layoutObject;
				if(sceneLayoutRenderer != null)
					sceneLayoutRenderer.renderScene(this);
			}
			if(stylingEnabled && !Lambda.empty (styleRendererFactories))
			{
				mainContainer.graphics.clear();
				for(sceneRenderer in styleRendererFactories)
				{
					if(sceneRenderer != null)
						sceneRenderer.renderScene(this);
				}
			}
			bIsInvalidated = false;
		}
	}

	override function postRenderLogic() : Void
	{
		invalidatedChildrenArray = [];
		super.postRenderLogic();
		sceneRendered();
	}

	function sceneRendered() : Void
	{
	}

	public function new()
	{
		invalidatedChildrenArray = [];
		layoutEnabled = true;
		bLayoutIsFactory = true;
		stylingEnabled = true;
		styleRendererFactories = new Array<ISceneLayoutRenderer>();
		super();
		layoutObject = new ClassFactory(DefaultSceneLayoutRenderer);
	}
}
