//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.renderers;

import as3isolib.core.IsoDisplayObject;

/**
 * ISceneLayoutRenderer is a marker interface to denote that an implementor is intended to handle layout logic.
 */
interface ISceneLayoutRenderer implements ISceneRenderer
{
	/**
	 * Allows the developer to leverage an ISceneLayoutRenderer's looping mechanism to detect and handle collisions between a scene's objects.
	 * The required function signature is <code>collisionDetectionFunction (objA:Object, objB:Object):int</code> where the returned value
	 * is indicates if objA should be in front or behind objB.  See the expected function signature for Array.sort for more information.
	 * By default this value is <code>null</code> as it is intended to be flexible with 3rd party collision/solver functions.
	 * 
	 * @default null
	 */
	var collisionDetection(getCollisionDetection, setCollisionDetection) : IsoDisplayObject->IsoDisplayObject->Int;

	function getCollisionDetection() : IsoDisplayObject->IsoDisplayObject->Int;
	function setCollisionDetection(value : IsoDisplayObject->IsoDisplayObject->Int) : IsoDisplayObject->IsoDisplayObject->Int;
}
