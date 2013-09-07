//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.primitive;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.graphics.IFill;
import as3isolib.graphics.IStroke;

interface IIsoPrimitive extends IIsoDisplayObject
{
	var styleType(get_styleType, set_styleType) : String;
	var fill(get_fill, set_fill) : IFill;
	var fills(get_fills, set_fills) : Array<IFill>;
	var stroke(get_stroke, set_stroke) : IStroke;
	var strokes(get_strokes, set_strokes) : Array<IStroke>;
	function get_styleType() : String;
	function set_styleType(value : String) : String;
	function get_fill() : IFill;
	function set_fill(value : IFill) : IFill;
	function get_fills() : Array<IFill>;
	function set_fills(value : Array<IFill>) : Array<IFill>;
	function get_stroke() : IStroke;
	function set_stroke(value : IStroke) : IStroke;
	function get_strokes() : Array<IStroke>;
	function set_strokes(value : Array<IStroke>) : Array<IStroke>;
	function invalidateStyles() : Void;
}
