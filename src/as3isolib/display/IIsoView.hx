//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display;

import as3isolib.core.IInvalidation;
import as3isolib.core.IIsoDisplayObject;
import as3isolib.geom.Pt;
import flash.display.Sprite;
import flash.events.IEventDispatcher;
import flash.geom.Point;

import as3isolib.display.scene.IIsoScene;

interface IIsoView extends IEventDispatcher extends IInvalidation
{
	var scenes(get_scenes, never) : Array<IIsoScene>;
	var numScenes(get_numScenes, never) : Int;
	var currentPt(get_currentPt, never) : Pt;
	var currentX(get_currentX, set_currentX) : Float;
	var currentY(get_currentY, set_currentY) : Float;
	var currentZoom(get_currentZoom, set_currentZoom) : Float;
	//var width(none, none) : Float;
	//var height(none, none) : Float;
	var mainContainer(get_mainContainer, never) : Sprite;

	function get_scenes() : Array<IIsoScene>;
	function get_numScenes() : Int;
	function get_currentPt() : Pt;
	function get_currentX() : Float;
	function set_currentX(value : Float) : Float;
	function get_currentY() : Float;
	function set_currentY(value : Float) : Float;
	function localToIso(localPt : Point) : Pt;
	function isoToLocal(isoPt : Pt) : Point;
	function centerOnPt(pt : Pt, isIsometric : Bool = true) : Void;
	function centerOnIso(iso : IIsoDisplayObject) : Void;
	function pan(px : Float, py : Float) : Void;
	function panBy(xBy : Float, yBy : Float) : Void;
	function panTo(xTo : Float, yTo : Float) : Void;
	function get_currentZoom() : Float;
	function zoom(zFactor : Float) : Void;
	function reset() : Void;
	function render(recursive : Bool = false) : Void;
	function get_width() : Float;
	function get_height() : Float;
	function get_mainContainer() : Sprite;
}
