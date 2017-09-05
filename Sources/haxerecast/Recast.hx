// Recast Navigation for Haxe
// https://github.com/recastnavigation/recastnavigation
// https://github.com/vincent/recast.js

package haxerecast;

#if cpp
@:headerCode('
#include <haxerecast.h>
')
#end
class Recast {

	#if js
	var hrecast:HaxeRecast;
	#end

	public function new() {
		#if js
		hrecast = untyped __js__("(1, eval)('this').recast");
		#end
	}

	public function OBJDataLoader(data:String, done:Void->Void):Void {
		#if js
		hrecast.OBJDataLoader(data, done);
		#else
		HaxeRecast.OBJDataLoader(data);
		done();
		#end
	}

	public function buildSolo():Void {
		#if js
		hrecast.buildSolo();
		#else
		HaxeRecast.buildSolo();
		#end
	}

	public function getRandomPoint(callback:Float->Float->Float->Void):Void {
		#if js
		hrecast.getRandomPoint(untyped recast.cb(callback));
		#else
		// HaxeRecast.getRandomPoint(callback);
		#end
	}

	public function findPath(from_x:Float, from_y:Float, from_z:Float, to_x:Float, to_y:Float, to_z:Float, max:Int, callback:Array<RecastWaypoint>->Void):Void {
		#if js
		hrecast.findPath(from_x, from_y, from_z, to_x, to_y, to_z, max, untyped recast.cb(callback));
		#else
		var ar:Array<RecastWaypoint> = [];
		HaxeRecast.findPath(from_x, from_y, from_z, to_x, to_y, to_z, max);
		var pathLen:Int = untyped __cpp__('HaxeRecast::pathLen');
		for (pathI in 0...Std.int(pathLen / 3)) {
			var x:Float = untyped __cpp__('HaxeRecast::pathData[pathI * 3]');
			var y:Float = untyped __cpp__('HaxeRecast::pathData[pathI * 3 + 1]');
			var z:Float = untyped __cpp__('HaxeRecast::pathData[pathI * 3 + 2]');
			var p:RecastWaypoint = { x: x, y: y, z: z }
			ar.push(p);
		}
		callback(ar);
		#end
	}
}

#if js
@:native('recast')
extern class HaxeRecast {
	// untyped recast.cb()
	public function OBJDataLoader(data:String, done:Void->Void):Void;
	public function buildSolo():Void;
	// public function buildTiled():Void;
	public function getRandomPoint(callback:Dynamic):Void;
	// callback:Float->Float->Float
	public function findPath(from_x:Float, from_y:Float, from_z:Float, to_x:Float, to_y:Float, to_z:Float, max:Int, callback:Dynamic):Void;
	// callback:Array<{x, y, z}>
	// public function addAgent(options:Dynamic):Void;
}
#end

#if cpp
@:include("haxerecast.h")
@:native("HaxeRecast")
@:unreflective
@:structAccess
extern class HaxeRecast {
	@:native("HaxeRecast::OBJDataLoader")
	public static function OBJDataLoader(data:String):Void; // initWithFileContent
	@:native("HaxeRecast::buildSolo")
	public static function buildSolo():Void;
	// @:native("HaxeRecast::getRandomPoint")
	// public static function getRandomPoint(callback:Dynamic):Void;
	@:native("HaxeRecast::findPath")
	public static function findPath(from_x:Float, from_y:Float, from_z:Float, to_x:Float, to_y:Float, to_z:Float, max:Int):Void;
}
#end

typedef RecastWaypoint = {
	public var x:Float;
	public var y:Float;
	public var z:Float;
}
