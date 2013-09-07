//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.geom;

import as3isolib.geom.transformations.DefaultIsometricTransformation;
import as3isolib.geom.transformations.IAxonometricTransformation;

class IsoMath
{
	static public var transformationObject(get_transformationObject, set_transformationObject) : IAxonometricTransformation;
	static var transformationObj : IAxonometricTransformation = new DefaultIsometricTransformation();

	static public function get_transformationObject() : IAxonometricTransformation
	{
		return transformationObj;
	}

	static public function set_transformationObject(value : IAxonometricTransformation) : IAxonometricTransformation
	{
		if(value != null) 
			transformationObj = value
		else
			transformationObj = new DefaultIsometricTransformation();
		return transformationObj;
	}

	static public function screenToIso(screenPt : Pt, createNew : Bool = false) : Pt
	{
		var isoPt : Pt = transformationObject.screenToSpace(screenPt);
		if(createNew)
			return isoPt
		else 
		{
			screenPt.x = isoPt.x;
			screenPt.y = isoPt.y;
			screenPt.z = isoPt.z;
			return screenPt;
		}
	}

	static public function isoToScreen(isoPt : Pt, createNew : Bool = false) : Pt
	{
		var screenPt : Pt = transformationObject.spaceToScreen(isoPt);
		if(createNew)
			return screenPt;
		else {
			isoPt.x = screenPt.x;
			isoPt.y = screenPt.y;
			isoPt.z = screenPt.z;
			return isoPt;
		}
	}
}
