//
//  XGScriptClassFunctionsInfo.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

//MARK: - Class Names
var ScriptClassNames : [Int : String] = [
	// .xds script format requires classes to be named with first character capitalised
	0: "Standard",
	4: "Vector",
	5: "Matrix",
	6: "Object",
	7: "Array",
	
	// 33 is first object class, 60 is last
	33: "Camera",
	35: "Character",
	37: "Pokemon",
	38: "Map",
	39: "Tasks",
	40: "Menu",
	41: "Transition",
	42: "Battle",
	43: "Player",
	44: "Light",
	45: "Model",
	46: "Collision",
	47: "Sound",
	48: "Controller",
	49: "PDA",
	50: "Direction",
	51: "TV",
	52: "Daycare",
	54: "Thread",
	58: "Move",
	59: "ShadowPokemon",
	60: "Pokespot"
]

//MARK: - Operators
let ScriptOperators : [(name: String, index: Int, parameterCount: Int, hint: String)] = [
	//#------------------------------------------------------------------
	//Category(name = "Unary operators", start = 16, nb = 10),
	
	("!", 16, 1, ""), // not
	("-", 17, 1, ""), // negative
	
	// type cast
	("hex", 18, 1, ""),
	("string", 19, 1, ""),
	("integer", 20, 1, ""),
	("float", 21, 1, ""),
	
	// parameters
	("getvx", 22, 1, ""),
	("getvy", 23, 1, ""),
	("getvz", 24, 1, ""),
	("zerofloat", 25, 1, ""), //# always returns 0.0 ...
	//#------------------------------------------------------------------
	//Category(name = "Binary non-comparison operators", start = 32, nb = 8),
	
	("^", 32, 2, ""), // xor
	("or", 33, 2, ""), // or |
	("and", 34, 2, ""), // and &
	("+", 35, 2, ""), // add # str + str is defined as concatenation
	("-", 36, 2, ""), // subtract
	("*", 37, 2, ""), // multiply # int * str or str * int is defined. For vectors = <a,b,c>*<c,d,e> = <a*c, b*d, c*e>
	("/", 38, 2, ""), //# you cannot /0 for ints and floats but for vectors you can ...
	("%", 39, 2, ""), //# operands are implicitly converted to int, if possible.
	//#------------------------------------------------------------------
	//Category(name = "Comparison operators", start = 48, nb = 6),
	
	("=", 48, 2, ""), //# For string equality comparison: '?' every character goes, '*' everything goes after here
	(">", 49, 2, ""), //# ordering of strings is done comparing their respective lengths
	(">=", 50, 2, ""),
	("<", 51, 2, ""),
	("<=", 52, 2, ""),
	("!=", 53, 2, "")
	//#------------------------------------------------------------------
]

// MARK: - Class functions
// parameter count is the minimum needed for the function to work
// having too many is okay and some functions can have varying numbers of parameters
// depending on usage.
// parameter or return types of nil means they are unknown, none is used if it is known to have no type (void)
var ScriptClassFunctions : [Int : [(name: String, index: Int, parameterCount: Int, parameterTypes: [XDSMacroTypes?]?, returnType: XDSMacroTypes?, hint: String)]] = [
// Keep the hints short as they are used in the sublime text autocompletions
//MARK: - Standard
	0 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Timer-related functions", start = 17, nb = 6),
		("pause", 17, 1, [.float], .null, ""),
		("yield", 18, 1, [.integer], .null, ""),
		("setTimer", 19, 1, nil, .null, ""),
		("getTimer", 20, 1, nil, nil, ""),
		("waitUntil", 21, 2, nil, .null, ""),
		("printString", 22, 1, [.string], .null, ""),
		
		("convertShortToInt", 28, 1, [.integer], .integer, ""),
		("getTypeName", 29, 1, [.anyType], .string, ""),
		("getCharacterAtIndex", 30, 2, [.string, .integerIndex], .integer, ""), //# (str, index)
		("copyString", 31, 1, [.string], .string, ""),
		("findSubstring", 32, 2, [.string, .string], .invalid, "always returns -1"),
		("setBit", 33, 2, [.integer, .integerIndex], .integer, ""),
		("clearBit", 34, 2, [.integer, .integerIndex], .integer, ""),
		("orBits", 35, 2, [.integer, .integer], .integer, ""),
		("nandBits", 36, 2, [.integer, .integer], .integer, ""),
		//#------------------------------------------------------------------------------------
		//Category(name = "Math functions", start = 48, nb = 6),
		("sin", 48, 1, [.integerAngleDegrees], .float, ""), //# trigo. function below work with degrees
		("cos", 49, 1, [.integerAngleDegrees], .float, ""),
		("tan", 50, 1, [.integerAngleDegrees], .float, ""),
		("atan2", 51, 1, [.float], .integer, ""),
		("acos", 52, 1, [.float], .integerAngleDegrees, ""),
		("sqrt", 53, 1, [.float], .float, ""),
		//#------------------------------------------------------------------------------------
		//Category(name = "Functions manipulating a single flag", start = 129, nb = 5),
		
		("setFlagToTrue", 129, 1, [.flag], .null, ""),
		("setFlagToFalse", 130, 1, [.flag], .null, ""),
		("setFlag", 131, 2, [.flag, .integer], .null, ""),
		("isFlagSet", 132, 2, [.flag, .integer], .bool, ""),
		("getFlag", 133, 1, [.flag], .integer, ""),
		
		//#------------------------------------------------------------------------------------
		//Category(name = "Misc. 1", start = 136, nb = 5),
		
		("printf", 136, 1, [.string, .optional(.list(.anyType))], .null, "debug only"), // params also include pattern matches like %d
		("genRandomNumberMod", 137, 1, [.integer], .integer, "from 0 to n - 1"), // generates a random number between 0 and the parameter - 1
		("setShadowPokemonStatus", 138, 2, [.shadowID, .shadowStatus], .null, ""),
		("checkAllFlagsAreTrue", 139, 1, [.array(.flag)], .bool, ""),
		("checkAtLeastOneFlagIsTrue", 140, 1, [.array(.flag)], .bool, ""),
		//#------------------------------------------------------------------------------------
		//Category(name = "Debugging functions", start = 142, nb = 2),
		
		("syncTaskFromCommonScript", 142, 3, [.scriptFunction, .integer, .list(.anyType)], .null, ""), //#nbArgs, function ID, ... (args, nil)
		("setScriptDebugVisibility", 143, 1, [.bool], .null, "doesn't work on release builds but can be shown via modding"),
		
		("mapSetCharacterCollision", 145, 1, [.bool], .null, ""), //# the game uses the term "floor"
		("mapGetCharacterCollision", 146, 0, [], .bool, ""),
		("setTreasureInteractionRange", 147, 2, [.integer, .float], nil, ""), //# (int, float)
		("getStringWithID", 148, 1, [.msg], .string, ""),
		("getTreasureBoxCharacter", 149, 1, [.treasureID], .objectName("Character"), "gets the character object"), //# (int treasureID) returns a character object for the treasure
		("pokemonSpeciesGetNameID", 150, 1, [.pokemon], .msg, ""),
		("getArrayElement", 151, 1, [.array(.anyType), .arrayIndex], .anyType, ""), //# (array, index)
		("isHMMove", 152, 1, [.move], .bool, ""),
		("distanceBetween", 153, 2, [.vector, .vector], .float, "between 2 points given by vectors"),  //# between the two points whose coordinates are the vector args
		("getCharacterID", 154, 1, [.objectName("Character")], .integer, ""), //# (character), returns 0 by default
		("startGlow", 155, 6, [.float, .integer, .bool, .bool, .bool, .integer], .null, ""),
		("stopGlow", 156, 0, [], .null, ""), //# return type: (int) -> character
		("setLensFlare", 157, 5, [.integer, .float, .float, .float, .float], .null, ""),
		("getCharacterObjectWithIndex", 158, 1, [.integer], .objectName("Character"), ""),
		("getFrameRate", 159, 0, [], .integer, ""),
		("getRegion", 160, 0, [], .region, ""),
		("getLanguage", 161, 0, [], .language, "")
	],
	
//MARK: - Vector
	4 : [
		
		("toString", 3, 1, [.vector], .string, ""),
		
		("clear", 16, 1, [.vector], .vector, ""),
		("normalize", 17, 1, [.vector], .vector, ""),
		("set", 18, 3, [.vector, .float, .float, .float], .null, "vec, x, y, z"),
		("set2", 19, 4, [.vector, .float, .float, .float, nil], .null, "vec, x, y, z"),
		("fill", 20, 2, [.vector, .float], .null, "set x,y & z to the same value"),
		("abs", 21, 1, [.vector], .null, "set each dimension to its magnitude"), //#in place
		("negate", 22, 1, [.vector], .null, ""), //#in place
		("isZero", 23, 1, [.vector], .bool, ""),
		("crossProduct", 24, 2, [.vector, .vector], .vector, ""),
		("dotProduct", 25, 2, [.vector, .vector], .float, ""),
		("magnitude", 26, 1, [.vector], .float, ""),
		("squaredMagnitude", 27, 1, [.vector], .float, ""),
		("angle", 28, 2, [.vector], .float, "")
	],
	
//MARK: - Array
	7 : [
		("toString", 3, 1, [.array(.anyType)], .string, ""),
		
		("get", 16, 2, [.array(.anyType), .arrayIndex], .anyType, ""), // array get
		("set", 17, 3, [.array(.anyType), .arrayIndex, .anyType], .null, ""), // array set
		("length", 18, 1, [.array(.anyType)], .integer, ""),
		("resize", 19, 2, [.array(.anyType), .integer], .null, ""),
		("extend", 20, 2, [.array(.anyType), .integer], .null, ""),
		
		("resetIterator", 22, 1, [.array(.anyType)], .null, ""),
		("derefIterator", 23, 2, [.array(.anyType), nil], .null, ""),
		("getIteratorPos", 24, 2, [.array(.anyType), nil], .integer, ""),
		("append", 25, 2, [.array(.anyType), .anyType], .null, "") 
	],
	
//MARK: - Camera
	33 : [
		("setDefaultForMap", 16, 4, [.objectName("Camera"), .number, .number, .number], .null, ""),
		("setCameraType", 17, 3, [.objectName("Camera"), .cameraType], .null, ""),
		("followCharacter", 18, 2, [.objectName("Camera"), .objectName("Character")], .null, ""), // # (Character target)
		("setTargetPosition", 19, 4, [.objectName("Camera"), .number, .number, .number], .null, "(x, y, z)"), // x, y , z
		("setTargetPositionVector", 20, 2, [.objectName("Camera"), .vector], .null, "<x, y, z>"), // x, y , z
		("setTargetPositionOffset", 21, 4, [.objectName("Camera"), .number, .number, .number], .null, "(x, y, z)"), // x, y , z
		("setTargetPositionOffsetVector", 22, 2, [.objectName("Camera"), .vector], .null, "<x, y, z>"), // x, y , z
		("setPosition", 23, 4, [.objectName("Camera"), .number, .number, .number], .null, "(x, y, z)"), // x, y , z
		("setPositionVector", 24, 2, [.objectName("Camera"), .vector], .null, "<x, y, z>"), // x, y , z
		("setRotationRadians", 25, 4, [.objectName("Camera"), .number, .number, .number], .null, "rotation about each of the axes (x, y, z) in radians"), // x, y , z
		("setRotationRadiansVector", 26, 2, [.objectName("Camera"), .vector], .null, "rotation about each of the axes <x, y, z> in radians"), // x, y , z
		("playAnimationFromFile", 27, 5, [.objectName("Camera"), .integer, .camIdentifier, .integer, .integer], .null, "from .cam file in fsys with gid"), // performs a series of transformations and translations from a .cam file in fsys with specified group id
		("stopAnimation", 28, 1, [.objectName("Camera")], .null, ""),
		("pauseAnimation", 29, 1, [.objectName("Camera")], .null, ""),
		("resumeAnimation", 30, 1, [.objectName("Camera")], .null, ""),
		("awaitAnimation", 31, 2, [.objectName("Camera"), .bool], .null, "wait until the animation finishes?"),
		("setAnimationSpeed", 32, 2, [.objectName("Camera"), .number], .null, ""),
		("moveTargetCharacter", 33, 5, [.objectName("Camera"), .objectName("Character"), .cameraType, .number, .number], .null, ""),
		("moveToTarget", 34, 6, [.objectName("Camera"), .cameraType, .number, .number, .number, .number], .null, ""),
		("moveToTargetVector", 35, 6, [.objectName("Camera"), .vector, .cameraType, .number, .number], .null, ""),
		("moveToPosition", 36, 7, [.objectName("Camera"), .cameraType, .number, .number, .number, .number, .number], .null, ""),
		("moveToPositionVector", 37, 5, [.objectName("Camera"), .vector, .cameraType, .number, .number], .null, ""),
		("moveToRotation", 38, 7, [.objectName("Camera"), .cameraType, .number, .number, .number, .number, .number], .null, ""),
		("moveToRotationVector", 39, 5, [.objectName("Camera"), .vector, .cameraType, .number, .number], .null, ""),
		("isCameraDoneMoving", 40, 2, [.objectName("Camera"), .number], .bool, ""),
		("setHeight", 41, 2, [.objectName("Camera"), .number], .null, ""),
		("setDistance", 42, 2, [.objectName("Camera"), .number], .null, ""),
		("setYRotation", 43, 2, [.objectName("Camera"), .number], .null, ""),
		("setFieldOfView", 44, 2, [.objectName("Camera"), .number], .null, "angle"),
		("update", 45, 1, [.objectName("Camera")], .null, ""),
		("reset", 46, 1, [.objectName("Camera")], .null, ""),
		("enableDefaultForMap", 47, 1, [.objectName("Camera")], .null, ""),
		("disableDefaultForMap", 48, 1, [.objectName("Camera")], .null, ""),
		("mapCameraBlend", 49, 2, [.objectName("Camera"), .number], .null, ""),
		("getFieldOfView", 50, 1, [.objectName("Camera")], .float, ""),
		("getPosition", 51, 1, [.objectName("Camera")], .vector, ""),
		("getRotation", 52, 1, [.objectName("Camera")], .vector, ""),
		("moveToPositionVectorWithAcceleration", 53, 5, [.objectName("Camera"), .vector, .number, .number, .number], .null, "position, unk, unk, acceleration"),
		("moveToPositionWithAcceleration", 54, 7, [.objectName("Camera"), .number, .number, .number, .number, .number, .number], .null, "unk, unk, unk, unk, unk, acceleration"),
		("moveToRotationVectorWithAcceleration", 55, 5, [.objectName("Camera"), .vector, .number, .number, .number], .null, ""),
		("moveToRotationWithAcceleration", 56, 7, [.objectName("Camera"), .number, .number, .number, .number, .number, .number], .null, ""),
		("moveToTargetVectorWithAcceleration", 57, 5, [.objectName("Camera"), .vector, .number, .number, .number], .null, ""),
		("moveToTargetWithAcceleration", 58, 7, [.objectName("Camera"), .number, .number, .number, .number, .number, .number], .null, ""),
		("moveFieldOfView", 59, 4, [.objectName("Camera"), .number, .number, .number], .null, ""),
		("moveFieldOfViewWithAcceleration", 60, 5, [.objectName("Camera"), .number, .number, .number, .number], .null, ""),
		("followCharacterWithResourceId", 61, 2, [.objectName("Camera"), .number], .null, ""),
		("followCharacterWithResourceIdExt", 62, 2, [.objectName("Camera"), .number, .number], .null, ""),
		("setFollowOffset", 63, 2, [.objectName("Camera"), .vector], .null, "")
		
	],
	
//MARK: - Character
	35 : [
		
		("setVisibility", 16, 2, [.objectName("Character"), .bool], .null, ""), //# (int visible)
		("setAnimation", 17, 4, [.objectName("Character"), .integer, .integer, .bool], .bool, "(animation id, unknown, loop animation)"),
		("overrideAnimation", 18, 4, [.objectName("Character"), .integer, .integer, .bool], .null, "(animation id, unknown, loop animation)"),
		("stopAnimation", 19, 1, [.objectName("Character")], .integer, ""),
		("awaitAnimation", 20, 2, [.objectName("Character")], .bool, "wait until animation finishes?"),
		("beingDialog", 21, 3, [.objectName("Character"), .msg, .bool], .null, "msgID, autoend"),
		("endDialog", 22, 1, [.objectName("Character")], .null, ""),
		("initializeCharacterFromResourceId", 23, 2, [.objectName("Character"), .integer], .bool, "resource id"),
		("deinitializeCharacter", 24, 1, [.objectName("Character")], .null, ""),
		("isWithinBounds", 25, 5, [.objectName("Character"), .float, .float, .float, .float], .bool, "(min x, min z, max x, max z) or v. versa"), // # (Float x1, Float z1, Float x2, Float z2) ordering of ranges is interchangeable i.e. x1 > x2 == x2 > x1
		("isWithinBoundsVector", 26, 3, [.objectName("Character"), .vector, .vector], .bool, ""),
		("didStepOntoLine", 27, 7, [.objectName("Character"), .float, .float, .float, .float, .float, .bool], .bool, "(min x, min z, max x, max z) or v. versa"), //# x1 z1 x2 z2 unk unk
		("didStepOntoLineVector", 28, 4, [.objectName("Character"), .vector, .vector, .bool], .bool, ""), //# x1 z1 x2 z2 unk unk
		("setPosition", 29, 4, [.objectName("Character"), .float, .float, .float], .null, "(x, y, z)"), //# (int/float x, int/float y, int/float z) accepts either int or float for any of the values and can mix and match as desired
		("setPositionVector", 30, 2, [.objectName("Character"), .vector], .null, ""),
		("setRotation", 31, 4, [.objectName("Character"), .floatAngleDegrees, .floatAngleDegrees, .floatAngleDegrees], .null, "about each axis"), // int angle around x axis, int angle around y axis, int angle around z axis
		("setRotationVector", 32, 2, [.objectName("Character"), .vector], .null, ""),
		("getPositionIntoValues", 33, 4, [.objectName("Character"), .float, .float, .float], .null, "creates a vector from the args and replaces vector with character's position"),
		("getPositionIntoVector", 34, 2, [.objectName("Character"), .vector], .null, "replaces the vector with the character's position"),
		("walkToPosition", 36, 5, [.objectName("Character"), .integer, .float, .float, .float], .null, "(speed, x, y, z)"), //# (int speed, int x, int y, int z)
		("walkToPositionVector", 37, 3, [.objectName("Character"), .integer, .vector], .null, "(speed, vector<x, y, z>)"),
		("walkToCharacter", 38, 4, [.objectName("Character"), .objectName("Character"), .float, .integer], .null, ""),
		("awaitAnimation", 39, 2, [.objectName("Character"), .bool], .null, "(wait for completion?)"), // bool wait for completion
		("setCharacterFlags", 40, 2, [.objectName("Character"), .integerBitMask], .null, ""), //# (int flags)
		("unsetCharacterFlags", 41, 2, [.objectName("Character"), .integerBitMask], .null, ""), //# (int flags)
		("setHeadTiltTowardsPlayer", 42, 1, [.objectName("Character")], .null, ""),
		("setHeadTiltTowardsCharacter", 43, 2, [.objectName("Character"), .objectName("Character")], .null, ""),
		("setHeadTiltTowardsPosition", 44, 4, [.objectName("Character"), .integer, .integer, .integer], .null, ""),
		("resetHeadTilt", 45, 2, [.objectName("Character"), .integer], .null, ""),
		("awaitHeadTilt", 46, 2, [.objectName("Character"), .bool], .null, "wait for completion?"),
		("turnToAngleRadians", 47, 2, [.objectName("Character"), .floatAngleRadians], .null, ""),
		("turnToRotation", 48, 4, [.objectName("Character"), .float, .float, .float, .float], .null, "x, y, z, speed"),
		("turnToCharacter", 49, 3, [.objectName("Character"), .objectName("Character"), .float], .null, "(speed)"),
		("setMovementSpeed", 50, 2, [.objectName("Character"), .float], .null, "speed"),
		("attachToCharacter", 51, 3, [.objectName("Character"), .objectName("Character"), .integer], .null, "mode"),
		("detachFromCharacter", 52, 2, [.objectName("Character"), .integer], .null, ""),
		("yield", 53, 1, [.objectName("Character")], .null, ""),
		("initializeNewWalkingRoute", 54, 2, [.objectName("Character"), .integer], .null, "number of waypoints"),
		("addToWalkingRoute", 55, 4, [.objectName("Character"), .float, .float, .float], .null, "(x, y, z)"), // (float x, float y, float z)
		("beginWalkingRoute", 56, 2, [.objectName("Character"), .bool], .null, ""),
		("deinitializeWalkingRoute", 57, 1, [.objectName("Character")], .bool, ""),
		("beginInteraction", 58, 1, [.objectName("Character")], .null, ""),
		("endInteraction", 59, 1, [.objectName("Character")], .null, ""),
		("dropFromCeilingAppearance", 60, 2, [.objectName("Character"), .float], .null, ""),
		("surprisedAnimation", 61, 2, [.objectName("Character"), .bool], .null, "(don't face player?)"), // the little flash above the character's head. Will automatically turn the character to face the player unless the boolean parameter is set to true
		("setCanCollide", 62, 2, [.objectName("Character"), .bool], .null, "(whether the hitbox is enabled or not)"),
		("checkIfCanSeePlayer", 63, 1, [.objectName("Character")], .bool, ""),
		("setAnimationBlend", 64, 4, [.objectName("Character"), .integer, .integer, .integer], .bool, ""),
		("awaitAnimationBlend", 65, 4, [.objectName("Character"), .bool], .bool, "wait for completion?"),
		("pauseWalking", 66, 4, [.objectName("Character"), .bool], .bool, ""),
		("tiltHeadTowardsPositionVector", 67, 2, [.objectName("Character"), .vector], .null, ""),
		("turnToRotationVector", 68, 3, [.objectName("Character"), .vector, .float], .null, "<x, y, z>, speed"),
		("addToWalkingRouteVector", 69, 2, [.objectName("Character"), .vector], .null, ""),
		("setModel", 70, 2, [.objectName("Character"), .model], .null, "fsys identifier"), //# (int id)
		("checkIfRunning", 71, 1, [.objectName("Character")], .bool, ""),
		("getMovementSpeed", 72, 2, [.objectName("Character")], .floatFraction, "between 0.0 and 1.0"), // float between 0.0 and 1.0
		("talk", 73, 3, [.objectName("Character"), .talk, .msg, .optional(.variableType), .optional(.variableType)], .anyType, ""), //# (int type, ...) // set last 2 macros based on talk type
		//# Some type of character dialogs (total: 22):
		//# (Valid values for type : 1-3, 6-21).
		//#	(1, msgID): normal msg
		//#	(2, msgID): the character comes at you, then talks, then goes away (to be verified; anyways he/she moves)
		//#	(8, msgID): yes/no question
		//# (battleID, 9, msgID) talks and then initiates a battle
		//# (quantity,itemID, 14, msgID) talks and then adds item to player's bag silently
		//#	(15, species): plays the species' cry
		//#	(16, msgID): informative dialog with no sound
		("attachToCharacterGIRI", 74, 4, [.objectName("Character"), .integer, .integer, .integer], .null, "gid, rid, mode"),
		("getPosition", 75, 1, [.objectName("Character")], .vector, ""),
		("getRotation", 76, 1, [.objectName("Character")], .float, ""),
		("setIdleAnimation", 77, 1, [.objectName("Character")], .null, ""),
		("unsetIdleAnimation", 78, 1, [.objectName("Character")], .null, ""),
		("turnToAngleDegrees", 79, 2, [.objectName("Character"), .floatAngleDegrees, .float], .null, ""),
		("turnHeadByAngle", 80, 4, [.objectName("Character"), .float, .float, .float], .null, ""),
		("turnHeadTowardsTarget", 81, 3, [.objectName("Character"), .objectName("Character"), .float], .null, ""),
		("turnHeadTowardsPlayer", 82, 2, [.objectName("Character"), .float], .null, ""),
		("turnHeadTowardsWorldAngle", 83, 4, [.objectName("Character"), .float, .float, .float], .null, ""),
		("turnHeadTowardsPosition", 84, 5, [.objectName("Character"), .integer, .integer, .integer, .float], .null, ""),
		("getYRotationDegrees", 85, 1, [.objectName("Character")], .null, "looks like it doesn't return the value so possibly unused"),
		("setToDefaultAnimation", 87, 1, [.objectName("Character")], .null, ""),
		("setAnimationOverride", 88, 1, [.objectName("Character")], .null, "Can then set a custom animation after"),
		("setWalkingRouteArray", 89, 2, [.objectName("Character"), .array(.anyType)], .null, ""),
		("resetWalkingRouteArray", 90, 1, [.objectName("Character")], .null, ""),
		("setSlowdownOn", 91, 1, [.objectName("Character")], .null, ""),
		("setSlowdownOff", 92, 1, [.objectName("Character")], .null, ""),
		("blinkOnce", 93, 1, [.objectName("Character")], .null, ""),
		("startBlinking", 94, 1, [.objectName("Character")], .null, ""),
		("stopBlinking", 95, 1, [.objectName("Character")], .null, ""),
		("startMouthMovements", 96, 1, [.objectName("Character")], .null, ""),
		("stopMouthMovements", 97, 1, [.objectName("Character")], .null, ""),
		("setTalkingDistance", 98, 2, [.objectName("Character"), .float], .null, ""),
		("getTalkingDistance", 99, 1, [.objectName("Character")], .null, "looks like it doesn't return the value so possibly unused"),
		("startWalkingRouteStrict", 100, 2, [.objectName("Character"), .float], .null, ""),
		("useHealingMachine", 101, 3, [.objectName("Character"), .datsIdentifier, .array(.integer), .array(.integer)], .null, ""),
		("pauseWalkTalkMode", 102, 2, [.objectName("Character"), .bool], .null, ""),
		("setAnimationSpeed", 103, 2, [.objectName("Character"), .float], .null, ""),
		("setWalkingSpeed", 104, 3, [.objectName("Character"), .float, .integer], .null, ""),
		("setBoundsCheck", 105, 2, [.objectName("Character"), .integer], .null, ""),
		("setMotionEnded", 106, 3, [.objectName("Character"), .integer, .bool], .null, ""),
		("attachParticleToPart", 107, 3, [.objectName("Character"), .integer, .integer], .null, ""),
		("setScale", 108, 2, [.objectName("Character"), .vector], .null, ""),
		("recalculateBounds", 109, 1, [.objectName("Character")], .null, ""),
		("isWithinBoundsVector2", 110, 4, [.objectName("Character"), .vector, .float, .vector], .bool, ""),
		("loadTransformationForBone", 111, 2, [.objectName("Character"), .integer], .null, ""),
		("applyTextureFilterWithIndex", 112, 2, [.objectName("Character"), .integerIndex], .null, "Applies a preset filter to the textures on the model. The vanilla list of filters are the ones for making pokespot pokemon shiny in the overworld"),
		("clearUnknown", 113, 1, [.objectName("Character")], .null, ""),
		("clearUnknownStopRotation", 114, 1, [.objectName("Character")], .null, ""),
	],
	
//MARK: - Pokemon
	37 : [
		
		("playCryForSpeciesWithId", 16, 2, [.anyType, .pokemon], .null, "species id"),
		("deleteMove", 17, 2, [.objectName("Pokemon"), .integerIndex], .null, "move slot"),
		("copyMoveToIndexFromIndex", 18, 3, [.objectName("Pokemon"), .integerIndex, .integerIndex], .null, "target move slot, original move slot"),
		("playCry", 19, 1, [.objectName("Pokemon")], .null, "species id"),
		("countMoves", 20, 1, [.objectName("Pokemon")], .integer, ""),
		("getPokeballCaughtWith", 21, 1, [.objectName("Pokemon")], .item, ""),
		("getNickname", 22, 1, [.objectName("Pokemon")], .string, ""),
		("isShadowPokemon", 24, 1, [.objectName("Pokemon")], .bool, ""),
		("getMoveAtIndex", 25, 1, [.objectName("Pokemon"), .integerIndex], .move, ""),
		("getCurrentHP", 26, 1, [.objectName("Pokemon")], .integer, ""),
		("getCurrentPurificationCounter", 27, 1, [.objectName("Pokemon")], .integer, ""),
		("getSpecies", 28, 1, [.objectName("Pokemon")], .pokemon, ""),
		("isLegendary", 29, 1, [.objectName("Pokemon")], .bool, ""),
		("getHappiness", 30, 1, [.objectName("Pokemon")], .integerUnsignedByte, ""),
		("getSpeciesNameID", 31, 1, [.objectName("Pokemon")], .msg, ""), //# if it's 0 the species is invalid
		("getHeldItem", 32, 1, [.objectName("Pokemon")], .item, ""),
		("getOriginalSIDTID", 33, 1, [.objectName("Pokemon")], .integerUnsigned, ""),
		("teachMove", 34, 3, [.objectName("Pokemon"), .move, .number], .integer, ""), // (int move id)
		("hasLearnedMove", 35, 2, [.objectName("Pokemon"), .move], .bool, ""), // (int move id)
		("canLearnTutorMove", 36, 2, [.objectName("Pokemon"), .move], .bool, ""), // int move id
		("openTeachNewMoveMenu", 37, 2, [.objectName("Pokemon"), .move], .integerIndex, ""),
		("openMoveSelectionMenu", 38, 1, [.objectName("Pokemon")], .integerIndex, ""),
	],
	
//MARK: - Map
	38 : [
		("getCurrentMapID", 16, 1, [.objectName("Map")], .room, ""),
		("getCurrentGroupID", 17, 1, [.objectName("Map")], .integer, ""),
		("getPreviousMapID", 18, 1, [.objectName("Map")], .room, ""),
		("getNextMapID", 19, 1, [.objectName("Map")], .room, ""),
		("getNextWarpPointIndex", 20, 1, [.objectName("Map")], .integerIndex, ""),
		("setBattleResumeMap", 21, 3, [.objectName("Map"), .number, .number], .integerIndex, ""),
		("warpToMap", 22, 3, [.objectName("Map"), .room, .integerIndex], .null, "room id and entry point index"),
		("warpToMapWithSoundEffect", 23, 4, [.objectName("Map"), .room, .integerIndex, .number], .null, "room id and entry point index"),
		("controlDoor", 24, 4, [.objectName("Map"), .number, .number, .number], .integer, ""),
		("controlElevator", 25, 4, [.objectName("Map"), .number, .number, .number], .integer, ""),
		("setTreasureVisibility", 26, 3, [.objectName("Map"), .treasureID, .bool], .null, "treasure id, visibility"),
		("changeTreasure", 27, 4, [.objectName("Map"), .number, .number, .number], .integer, ""),
		("setCharacterVisibility", 28, 3, [.objectName("Map"), .integerIndex, .bool], .bool, "character index, visibility"),
		("setCharacterPosition", 29, 5, [.objectName("Map"), .number, .number, .number, .integerIndex], .integer, "x, y, z, character index"),
		("setFadeTransitionScript", 30, 3, [.objectName("Map"), .integerIndex, .bool], .bool, "character index, visibility"),
		("setBattleResumeMap2", 31, 3, [.objectName("Map"), .number, .number], .null, ""),
		("setBattleResumeMap3", 32, 3, [.objectName("Map"), .number, .number], .null, ""),
		("clearReturnMap", 33, 1, [.objectName("Map")], .null, ""),
		("playMovieWithIndex", 34, 2, [.objectName("Map"), .integerIndex], .integer, ""),
		("setCharacterPositionBroken", 35, 2, nil, .integer, "Implementation looks buggy so possibly unused"),
		("showWorldMap", 36, 1, [.objectName("Map")], .null, ""),
		("showTitleScreen", 37, 1, [.objectName("Map")], .null, ""),
		("enterMenuMap", 38, 2, [.objectName("Map"), .room], .null, ""),
		("showPurifyChamberHolograms", 39, 1, [.objectName("Map")], .null, ""),
		("showPurifyChamber", 40, 1, [.objectName("Map")], .null, ""),
		("controlElevatorWithCharacter", 41, 5, [.objectName("Map"), .number, .number, .number, .objectName("Character")], .null, ""),
		("changePosition", 42, 6, [.objectName("Map"), .number, .number, .number, .number, .number], .null, ""),
		("showPurifyChamber2", 43, 1, [.objectName("Map")], .null, ""),
		("showBattleBingoMenu", 44, 1, [.objectName("Map")], .null, ""),
		("getBattleBingoResult", 45, 1, [.objectName("Map")], .integer, ""),
		("getBattleBingoCompletedLines", 46, 1, [.objectName("Map")], .integer, ""),
		("getWarpPointsListVector", 47, 1, [.objectName("Map")], .array(.vector), ""),
		("getWarpPointsListFloat", 48, 1, [.objectName("Map")], .array(.float), ""),
		("warpToMapWithTransitions", 49, 4, [.objectName("Map"), .room, .bool, .scriptFunction, .scriptFunction], .null, "room id, unknown, current script function before warp, target room function after warp"), // # (int roomID, int unknown)
		("playMovieOnTV", 50, 7, [.objectName("Map"), .number, .number, .number, .number, .number, .number], .null, ""),
		("showBattleCDMenu", 51, 1, [.objectName("Map")], .null, ""),
		("getSelectedBattleCD", 52, 1, [.objectName("Map")], .integerIndex, ""),
		("getBattleCDResult", 53, 1, [.objectName("Map")], .integer, ""),
		("getBattleBingoLastCardNumber", 54, 1, [.objectName("Map")], .integer, ""),
		("getBattleBingoRemainingEP", 55, 1, [.objectName("Map")], .integer, ""),
		("getBattleBingoRemainingMasterBalls", 56, 1, [.objectName("Map")], .integer, ""),
		("isPurifyChamberReadyForShadowLugiaPurification", 57, 1, [.objectName("Map")], .bool, ""),
		("registerLight", 58, 2, [.objectName("Map"), .number], .null, ""),
		("registerCamera", 59, 2, [.objectName("Map"), .number], .null, ""),
		("beginBattleCD", 60, 1, [.objectName("Map")], .null, ""),
		("releaseOverlay", 61, 1, [.objectName("Map")], .null, ""),
		("getPurifyChamberTutorialCancelled", 62, 1, [.objectName("Map")], .bool, ""),
		("showScooterTransition", 63, 2, [.objectName("Map"), .number], .null, ""),
		("isPurifyChamberReadyForShadowLugiaPurification2", 64, 1, [.objectName("Map")], .bool, ""),
		("getBattleBingoMode", 65, 1, [.objectName("Map")], .integer, ""),
		("countPurifyChamberPokemonReadyToPurify", 66, 1, [.objectName("Map")], .integer, ""),
		("setShadowDistanceLimits", 67, 3, [.objectName("Map"), .number, .number], .integer, ""),
		
	],
	
//MARK: - Tasks
	39 : [
		("executeScriptWithIDSync", 16, 6, [.objectName("Tasks"), .integer, .integer, .integer, .integer, .integer], .null, ""), //# (functionID, then 4 parameters)
		("executeScriptWithNameSync", 17, 6, [.objectName("Tasks"), .scriptFunction, .integer, .integer, .integer, .integer], .null, ""), //# the function is selected by its name in the CURRENT script.
		
		("executeScriptWithIDAsync", 18, 6, [.objectName("Tasks"), .integer, .integer, .integer, .integer, .integer], .null, ""), //# (functionID, then 4 parameters)
		("executeScriptWithNameAsync", 19, 6, [.objectName("Tasks"), .scriptFunction, .integer, .integer, .integer, .integer], .null, ""), //# the function is selected by its name in the CURRENT script.
		//# HEAD sec. must be present
		
		("getLastResult", 20, 1, [.objectName("Tasks")], .anyType, ""),
		("sleep", 21, 2, [.objectName("Tasks"), .number], .null, "(seconds)") //# (int/float) (seconds)
	],
	
//MARK: - Menu
	40 : [
		
		("displayMessageSilently", 16, 4, [.objectName("Menu"), .msg, .bool, .bool], .integer, "(msgId, inForeground?, print immediately?)"), //# (int msgID, bool isInForeground, bool printInstantly)
		("displayMessageWithSoundEffect", 17, 5, [.objectName("Menu"), .msg, .bool, .bool, .integer], .integer, "(msgId, inForeground?, print imm.?, pitch)"), //# (int msgID, bool isInForeground, bool printInstantly, int textSoundPitchLevel) makes the chirping sound as characters are displayed
		("awaitMessageClose", 18, 2, [.objectName("Menu"), .bool], .null, "(wait for completion?)"),
		("displayMessageSilently2", 19, 4, [.objectName("Menu"), .msg, .bool, .bool], .integer, "(msgId, inForeground?, print immediately?)"),
		("awaitMessageClose2", 20, 2, [.objectName("Menu"), .bool], .null, "(wait for completion?)"),
		("displayYesNoMenu", 21, 2, [.objectName("Menu"), .msg], .yesNoIndex, "returns 0 = YES, 1 = NO"), // result is not boolean but rather index of selected option, 0 indexed
		("displayYesNoMenuWithOptions", 22, 5, [.objectName("Menu"), .msg, .number, .number, .number], .yesNoIndex, "msg id, x, y, starting selection,, returns 0 = YES, 1 = NO"),
		("openColosseumEntryMenu", 23, 2, [.objectName("Menu"), .number], .null, ""),
		("openMenuWithId", 24, 3, [.objectName("Menu"), .number, .bool], .integer, ""),
		("awaitMenuClose", 25, 2, [.objectName("Menu"), .bool], .null, "(wait for completion?)"),
		("getCursorPositionForMenu", 26, 2, [.objectName("Menu"), .number], .integer, ""),
		("setCursorPositionForMenu", 27, 3, [.objectName("Menu"), .number, .number], .null, ""),
		("setMessageVariable", 28, 3, [.objectName("Menu"), .msgVar, .variableType], .null, ""), //# (int type, var val) macro type for value is set by compiler based on msgvar value
		("displayCustomMenu", 29, 6, [.objectName("Menu"), .array(.msg), .integer, .integer, .integer, .integerIndex], .integerIndex, "(msgIDs, no. elems, x, y, selection)"), // array of msgids, int number of elements, int x, int y, int index to start cursor on
		
		("displayPartyPokemonMenu", 32, 1, [.objectName("Menu")], .integerIndex, ""), //# these functions are **exactly** the same
		("displayPartyPokemonMenu2", 33, 1, [.objectName("Menu")], .integerIndex, ""),
		("displayPokemonSummary", 34, 2, [.objectName("Menu"), .integerIndex], .null, ""), //# int partyIndex
		("displayMoveMenuForPokemon", 35, 2, [.objectName("Menu"), .integerIndex], .integerIndex, ""), //# int partyIndex
		("displayNameEntryMenu", 36, 3, [.objectName("Menu"), .integer, .integer], .null, "(forWhom, mode)"), //# (int forWhom, var target, int mode)
		//# forWhom: 0 for Player, 1 for Sister, 2 for Poké. mode: 0 = enter Pokemon name, 1 = player name, 2 = sister name (not verified)
		("commonScriptDisplayNameEntryMenu", 37, 3, [.objectName("Menu"), .integer, .integer], .null, "only use in common.rel's script"), //# used by the common script only. Don't use this otherwise
		("displayPokemartMenu", 39, 2, [.objectName("Menu"), .integer], .null, "(mart id)"), //# (int pokemart id)
		("displayPDAMenu", 41, 1, [.objectName("Menu")], .null, ""),
		("openTradingMenu", 42, 1, [.objectName("Menu")], .bool, ""), // result is boolean true or false
		("openItemMenu", 50, 1, [.objectName("Menu")], .null, ""),
		("openNumberInputMenu", 56, 2, [.objectName("Menu"), .number], .integer, ""),
		("openTutorialMenu", 57, 1, [.objectName("Menu")], .null, ""),
		("openEeveeEvolutionsMenu", 58, 1, [.objectName("Menu")], .null, ""),
		("displayMenuWithOptions", 59, 8, [.objectName("Menu"), .number, .array(.msg), .number, .number, .number, .number, .number], .integerIndex, "(msgIDs, no. elems, x, y, selection)"),
		("showWorldMapLocation", 60, 2, [.objectName("Menu"), .integer], .null, ""),
		("showMirorRadarIcon", 61, 1, [.objectName("Menu")], .null, ""),
		("hideMirorRadarIcon", 62, 1, [.objectName("Menu")], .null, ""),
		("showBonslyPhoto", 63, 1, [.objectName("Menu")], .null, ""),
		("openMoveRelearnerMenuForPartyMember", 64, 2, [.objectName("Menu"), .integerIndex], .move, ""), //# (int partyIndex)
		("openTutorMovesMenu", 65, 1, [.objectName("Menu")], .move, ""),
		("setTutorMoveLearnedFlag", 66, 2, [.objectName("Menu"), .move], .null, ""),
		("showMoneyWindow", 67, 3, [.objectName("Menu"), .integer, .integer], .null, "(x, y)"), //# (int x, int y)
		("hideMoneyWindow", 68, 1, [.objectName("Menu")], .null, ""),
		("isMoveTutorAvailable", 69, 1, [.objectName("Menu")], .bool, ""),
		("showCouponsWindow", 70, 3, [.objectName("Menu"), .integer, .integer], .null, "(x, y)"), //# (int x, int y)
		("hideCouponsWindow", 71, 1, [.objectName("Menu")], .null, ""),
		("showOrreColosseumMenu", 72, 2, [.objectName("Menu"), .battleID], .null, ""), //# (int battleid)
		("showBonslyPhoto2",763, 1, [.objectName("Menu")], .null, ""),
		("getOrreColosseumResult", 74, 1, [.objectName("Menu")], .battleResult, "1 = lose, 2 = win, 3 = tie"),
		("addPDAFunctionality", 75, 2, [.objectName("Menu"), .number], .null, ""),
		("bagMenuAddItemScript", 76, 3, [.objectName("Menu"), .number, .number], .null, ""),
		("beginMewMoveTutorQuestions", 77, 1, [.objectName("Menu")], .integer, ""),
		("getGeneratedMewTutorMoveWithIndex", 78, 2, [.objectName("Menu"), .integerIndex], .move, "After the questions have been asked this function is used to retrieve the moveset"),
		("openPartyMenuToLearnMove", 79, 2, [.objectName("Menu"), .move], .integerIndex, "shows which pokemon can learn the move"),
		
	],
	
//MARK: - Transition
	41 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods", start = 16, nb = 2),
		
		("begin", 16, 3, [.objectName("Transition"), .transitionID, .number], .null, "(duration in seconds)"), //#$transition, int transitionID, int/float duration in seconds
		("await", 17, 2, [.objectName("Transition"), .bool], .null, "(wait for completion?)") //#$transition, bool waitForCompletion. waits for transition to have started before running next instruction, will wait for transition complete before next instruction if parameter is set to true

	],
	
//MARK: - Battle
	42 : [
		
		("startScriptedBattle", 16, 4, [.objectName("Battle"), .battleID, .bool, .bool], .null, "(battle id, unknown, don't black out?)"),// # (bool isTrainer, bool don't black out, int battleID) (battleID list in reference folder)
		("startOpenBattle", 17, 2, [.objectName("Battle"), .battleID], .null, "returns battle result rather than automatically handling black out"),
		("getBattleResult", 18, 1, [.objectName("Battle")], .battleResult, "1 = lose, 2 = win, 3 = tie"), // # sets last result to 2 if victory
		("playBGMForCurrentBattle", 19, 2, [.objectName("Battle"), .bool], .null, ""),
		("playEnvironmentSoundsForCurrentBattle", 20, 2, [.objectName("Battle"), .bool], .null, ""),
		("startBattleDependentOnShadowPokemonCaught", 21, 3, [.objectName("Battle"), .shadowID, .battleID, .battleID], .null, ""),
		("getCurrentBattleString", 22, 1, [.objectName("Battle")], .string, ""),
		("setNextBattlefield", 23, 2, [.objectName("Battle"), .battlefield], .null, "overrides next battle"),
		("getNextBattlefield", 24, 1, [.objectName("Battle")], .battlefield, ""),
		("getNextPostBattleText", 25, 3, [.objectName("Battle"), .battleResult], .msg, ""),
		("setNextPostBattleText", 26, 3, [.objectName("Battle"), .battleResult, .msg], .null, "overrides next battle"),
		("getNextAddMode", 27, 1, [.objectName("Battle")], .integer, ""),
		("getNextAddPlace", 28, 1, [.objectName("Battle")], .integer, ""),
		("getNextAddId", 29, 1, [.objectName("Battle")], .integer, ""),
		("setNextAddSettings", 30, 4, [.objectName("Battle"), .number, .number, .number], .null, "mode, place, id"),
		("getNextSwitchMode", 31, 1, [.objectName("Battle")], .integer, ""),
		("getNextSwitchDeckDisabled", 32, 1, [.objectName("Battle")], .integer, ""),
		("setNextSwitchSettings", 33, 3, [.objectName("Battle"), .number, .number], .null, "mode, deck disabled?"),
		("getNextSwitchDeckDisabled2", 34, 1, [.objectName("Battle")], .integer, ""),
		("setNextBattleType", 35, 2, [.objectName("Battle"), .number], .null, ""),
		("getNextBattleEraseFlag", 36, 1, [.objectName("Battle")], .integer, ""),
		("setNextBattleEraseFlag", 37, 2, [.objectName("Battle"), .number], .null, ""),
		("getNextTrainerType", 38, 1, [.objectName("Battle")], .integer, ""),
		("setNextTrainerType", 39, 2, [.objectName("Battle"), .number], .null, ""),
		("recoverAfterTeamWipeOut", 40, 1, [.objectName("Battle")], .null, ""),
		("getNextColosseumRound", 41, 1, [.objectName("Battle")], .integer, ""),
		("setNextColosseumRound", 42, 2, [.objectName("Battle"), .number], .null, ""),
	],
	
//MARK: - Player
	43 : [
		("initializePlayerAndFollower", 16, 1, [.objectName("Player")], .integer, ""),
		("processEvents", 17, 1, [.objectName("Player")], .integer, "only use in hero_main"), //# MUST BE CALLED IN THE IDLE LOOP (usually 'hero_main')
		("lockMovement", 18, 1, [.objectName("Player")], .null, ""),
		("freeMovement", 19, 1, [.objectName("Player")], .null, ""),
		("triggerScript", 20, 6, [.objectName("Player"), .scriptFunction, .anyType, .anyType, .anyType, .anyType], .null, "Used to trigger a script with the given parameters"),
		("setJoviFollowerStatus", 21, 2, [.objectName("Player"), .bool], .null, ""),
		("setFollowerShouldHeadTrackPlayer", 22, 3, [.objectName("Player"), .partyMember, .bool], .integer, "npc party member index, enable/disable"),
		("checkFollower", 23, 1, [.objectName("Player")], .integer, "doesn't seem to return a meaningful value. Possible Colosseum leftover"),
		("controlElevator", 24, 5, [.objectName("Player"), .number, .number, .number, .number], .integer, ""),
		("awaitFollowerMovement", 25, 1, [.objectName("Player")], .integer, ""),
		("receiveItem", 26, 3, [.objectName("Player"), .item, .integerQuantity], .bool, "use negative quantity to take item"), //# (int amount, int ID) gives the player the item and displays the obtained item message (or too bad bag is full). use negative quantity to remove item from bag. returns true if the bag is full
		("receiveItemSilently", 27, 3, [.objectName("Player"), .item, .integerQuantity], .bool, "use negative quantity to take item"), //# (int item id, int quantity) -> bool success. gives the player the item without displaying a message. use negative quantity to remove item. returns true if the bag is full
		("hasItemInBag", 28, 2, [.objectName("Player"), .item], .bool, ""), //# (int ID)
		("receiveMoney", 29, 2, [.objectName("Player"), .integerMoney], .integer, "use negative quantity to take money"), //# (int amount) (can be < 0)
		("getMoneyTotal", 30, 1, [.objectName("Player")], .integerMoney, ""),
		("getPrizeMoneyBuffer", 31, 1, [.objectName("Player")], .integerMoney, "stored from colosseum battles"),
		("setPrizeMoneyBuffer", 32, 2, [.objectName("Player"), .integerMoney], .null, "stored from colosseum battles"),
		("addToPrizeMoneyBuffer", 33, 2, [.objectName("Player"), .integerMoney], .null, "stored from colosseum battles"),
		("countPartyPokemon", 34, 1, [.objectName("Player")], .integer, ""),
		("countShadowPartyPokemon", 35, 1, [.objectName("Player")], .integer, ""),
		("getPartyPokemonName", 36, 2, [.objectName("Player"), .integerIndex], .string, ""), //# (int partyIndex)
		("receiveGiftPokemon", 37, 2, [.objectName("Player"), .giftPokemon], .integer, ""), //# (int ID)
		("countPurifiablePartyPokemon", 38, 1, [.objectName("Player")], .integer, ""),
		("healParty", 39, 1, [.objectName("Player"), .bool], .null, ""),
		("returnToColosseumBattleMenu", 40, 2, [.objectName("Player"), .number], .bool, "the parameter is unused"),
		("countNonFaintedPartyPokemon", 41, 1, [.objectName("Player")], .integer, ""),
		("getFirstEmptyPartyPokemonIndex", 42, 1, [.objectName("Player")], .integerIndex, "returns -1 if full"), //# -1 if no invalid Pokemon
		("countPartyPokemon", 43, 1, [.objectName("Player")], .integer, ""),
		("getPartyPokemonAtIndex", 44, 2, [.objectName("Player"), .integerIndex], .objectName("Pokemon"), ""), //# (int index)
		("checkIfIsOTForPokemon", 45, 2, [.objectName("Player"), .objectName("Pokemon")], .bool, ""), //# (int index)
		("changeFollower", 46, 2, [.objectName("Player"), .partyMember], .null, ""),
		("getFollower", 47, 1, [.objectName("Player")], .partyMember, ""), // # sets last result to character index of character following the player
		("setCharacterAsFollower", 48, 3, [.objectName("Player"), .objectName("Character"), .partyMember], .null, ""),
		("countCaughtShadowPokemon", 49, 1, [.objectName("Player")], .integer, ""),
		("graduallyStopMoving", 50, 1, [.objectName("Player")], .null, ""),
		("hasPokemonReadyForPurification", 51, 1, [.objectName("Player")], .bool, ""),
		("isPCFull", 52, 1, [.objectName("Player")], .bool, ""),
		("countLegendaryPartyPokemon", 53, 1, [.objectName("Player")], .integer, ""),
		("setFollower", 54, 3, [.objectName("Player"), .partyMember, .integer], .null, "set to 0 to remove"), // int party member character index (0 for none), int unknown. set party member to 0 to unset party member
		("storePartyPokemon", 55, 1, [.objectName("Player")], .null, ""),
		("checkStoredPartyPokemon", 56, 1, [.objectName("Player")], .integer, ""),
		("healPartyWithJingle", 57, 1, [.objectName("Player")], .null, ""),
		("healPartyAtPokeCenter", 58, 4, [.objectName("Player"), .number, .array(.objectName("Pokemon")), .array(.objectName("Pokemon"))], .null, ""),
		("countPurfiedPokemon", 59, 1, [.objectName("Player")], .integer, ""),
		("awardMtBattleRibbons", 60, 1, [.objectName("Player")], .null, ""),
		("getCouponTotal", 61, 1, [.objectName("Player")], .integerCoupons, ""),
		("setCouponTotal", 62, 2, [.objectName("Player"), .integerCoupons], .null, ""), //# (int nb)
		("receiveCoupons", 63, 2, [.objectName("Player"), .integerCoupons], .null, "use negative quantity to take coupons"), //# (int amount) (can be < 0)
		("countAllShadowPokemon", 64, 1, [.objectName("Player")], .integer, "total number of shadow pokemon in game"),
		("setStyle", 65, 3, [.objectName("Player"), .integer, .bool], .null, ""),
		("setSmoothWarp", 66, 2, [.objectName("Player"), .bool], .null, ""),
		("obtainItem", 67, 5, [.objectName("Player"), .number, .item, .integerQuantity, .bool], .null, ""), //# (int message type, int itemid, int quantity, bool unknown)
		("hasSpeciesInPC", 68, 2, [.objectName("Player"), .pokemon], .bool, ""), //# (int species)
		("releasePartyPokemon", 69, 2, [.objectName("Player"), .integerIndex], .bool, "returns true if worked"), //# (int index). Returns 1 iff there was a valid Pokémon, 0 otherwise.
		
	],
	
	//MARK: - Light
	44 : [
		
		("setVisibility", 16, 3, [.objectName("Light"), .number, .bool], .null, "id, visibility"),
		("setAnimation", 17, 5, [.objectName("Light"), .number, .number, .number, .number], .null, ""),
		("stopAnimation", 18, 2, [.objectName("Light"), .number], .null, ""),
		("awaitAnimation", 19, 2, [.objectName("Light"), .number, .bool], .integer, "id, wait for completion?"),
		("setType", 20, 3, [.objectName("Light"), .number, .number], .null, ""),
		("setPosition", 21, 3, [.objectName("Light"), .number, .vector], .null, ""),
		("setColor", 22, 6, [.objectName("Light"), .number, .number, .number, .number, .number], .null, "id, r,g,b,a"),
		("getPostion", 23, 2, [.objectName("Light"), .number], .vector, ""),
	],
	
	//MARK: - Model
	45 : [
		("open", 16, 2, [.objectName("Model"), .number], .integer, ""),
		("close", 17, 2, [.objectName("Model"), .null], .integer, ""),
		("setVisibility", 18, 3, [.objectName("Model"), .number, .bool], .null, "id, visibility"),
		("setAnimation", 19, 5, [.objectName("Model"), .datsIdentifier, .number, .number, .number], .null, ""),
		("stopAnimation", 20, 2, [.objectName("Model"), .number], .null, ""),
		("awaitAnimation", 21, 3, [.objectName("Model"), .datsIdentifier, .bool], .null, "(wait for completion?)"), // bool wait for completion
		("attach", 22, 4, [.objectName("Model"), .number, .number, .number], .integer, ""),
		("detach", 23, 2, [.objectName("Model"), .number], .integer, ""),
		("setParticleEffect", 24, 4, [.objectName("Model"), .number, .number, .number], .null, ""),
		("removeParticleEffect", 25, 3, [.objectName("Model"), .number, .number], .null, ""),
		("getTransformationForBone", 26, 3, [.objectName("Model"), .number, .number], .vector, ""),
		("addPosition", 27, 3, [.objectName("Model"), .number, .vector], .null, ""),
		("iterateList", 28, 2, [.objectName("Model"), .number], .null, ""),
		("setAnimationSpeed", 29, 6, [.objectName("Model"), .number, .number, .number, .float, .number], .null, ""),
		("setBoundsCheckingForCharacterRId", 30, 3, [.objectName("Model"), .number, .bool], .null, "resource id, bounds enabled?"),
		("setAnimationEnded", 31, 4, [.objectName("Model"), .number, .number, .number], .integer, ""),
		("attachParticleToPart", 32, 4, [.objectName("Model"), .number, .number, .number], .null, ""),
		("setFractionalFramesFlag", 33, 3, [.objectName("Model"), .number, .bool], .null, ""),
		("characterRIdRecalculateBounds", 34, 2, [.objectName("Model"), .number], .null, "resource id"),
		("characterRIdAnimateFromRootBone", 35, 2, [.objectName("Model"), .number], .null, "resource id"),
		
		
	],
	
	//MARK: - Collision
	46 : [
		("setEnabled", 16, 3, [.objectName("Collision"), .number, .bool], .null, "id, is enabled?"),
		("getEventCollision", 17, 1, [.objectName("Collision")], .null, "Doesn't return a value so possibly unused"),
		("setEventCollision", 18, 2, [.objectName("Collision"), .bool], .null, ""),
		
	],
	
//MARK: - Sound
	47 : [
		
		("playBGM", 16, 4, [.objectName("Sound"), .sfxID, .number, .number], .integer, "(id, unk, volume)"), // int songid, int unk, int volume
		("playEnvironmentSound", 17, 4, [.objectName("Sound"), .sfxID, .number, .number], .integer, "(id, unk, volume)"),
		("stopBGM", 18, 3, [.objectName("Sound"), .sfxID, .number], .integer, "(id, unk)"),
		("stopEnvironmentSound", 19, 2, [.objectName("Sound"), .sfxID], .integer, "(id, unk)"),
		("createEmitter", 20, 5, [.objectName("Sound"), .number, .float, .float, .float], .integer, ""),
		("createListener", 21, 1, [.objectName("Sound")], .integer, ""),
		("setVolume", 22, 3, [.objectName("Sound"), .number, .number], .integer, ""),
		("playEffect", 23, 4, [.objectName("Sound"), .number, .number, .number], .integer, ""),
		("setVolumeId", 24, 4, [.objectName("Sound"), .number, .number, .number], .integer, ""),
		("transitionToBGM", 25, 5, [.objectName("Sound"), .sfxID, .number, .number, .number], .integer, "id, unk, unk, volume"),
		("transitionToEnvironmentSound", 26, 5, [.objectName("Sound"), .sfxID, .number, .number, .number], .integer, "id, unk, unk, volume"),
		("getBGM", 27, 1, [.objectName("Sound")], .sfxID, ""),
		("characterDialogBGMMask", 28, 2, [.objectName("Sound"), .bool], .null, ""),
		("setCharacterDialogBGMFadeSpeed", 29, 3, [.objectName("Sound"), .float, .float], .null, ""),
		("setCharacterDialogBGMVolumeRate", 30, 3, [.objectName("Sound"), .float], .null, ""),
		("await", 31, 2, [.objectName("Sound"), .integer], .null, ""),
		("playEffect2", 32, 4, [.objectName("Sound"), .integer, .integer, .integer], .integer, ""),
		("createSoundEffectThread", 33, 5, [.objectName("Tasks"), .integer, .integer, .integer, .integer], .null, ""),
	
	],

//MARK: - Controller
	48 : [
		("isPressingAnyButtonOrStickInput", 16, 1, [.objectName("Controller")], .bool, ""), // true iff any button is being pressed
		("isPressingAnyStickInput", 17, 1, [.objectName("Controller")], .bool, ""), // true iff any button is being pressed
		("isPressingAnyButton", 18, 1, [.objectName("Controller")], .bool, ""), // true iff any button is being pressed
		("createRumbleThread", 19, 5, [.objectName("Controller"), .integer, .integer, .integer, .integer], .null, ""),
		("getPressedButtons", 20, 1, [.objectName("Controller")], .buttonInput, ""), //# returns 2 byte value which is bit mask of currently pressed controller buttons

	],
	
//MARK: - PDA
	49 : [
		("receiveMailWithID", 16, 1, [.objectName("PDA"), .integer], .null, ""),
		("setMemoFlag", 17, 1, [.objectName("PDA")], .null, ""),
		("openMailMenu", 18, 2, [.objectName("PDA"), .integer], .null, ""),
		("readMailWithID", 19, 2, [.objectName("PDA"), .integer], .null, ""),
		("receiveMailWithIDAndOpen", 20, 2, [.objectName("PDA"), .integer], .null, ""),
		
	],
	
	//MARK: - Direction
	50 : [
		
		("beginEvolution", 16, 1, [.objectName("Direction")], .null, ""),
		("setupPurificationParameters", 17, 4, [.objectName("Direction"), .integer, .integer, .bool], .null, ""),
		("beginPurification", 18, 1, [.objectName("Direction")], .null, ""),
		("showRelicStoneParticleEffect", 19, 1, [.objectName("Direction")], .null, ""),
		("useCologne", 20, 3, [.objectName("Direction"), .integer, .integer], .integer, ""),
		("getMirorBLocation", 21, 1, [.objectName("Direction")], .integer, ""),
		("clearMirorBAppearance", 22, 1, [.objectName("Direction")], .null, ""),
		
	],
	
	//MARK: - TV
	51 : [
		
		("controlTV", 17, 1, [.objectName("TV")], .integer, ""),
		("controlTVEvent", 17, 1, [.objectName("TV"), .integer], .integer, ""),
	],
	
//MARK: - Day Care
	52 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (1) ", start = 16, nb = 4),
		
		("getLevelsGained", 17, 1, [.objectName("Daycare")], .integer, ""),
		("getHundredsOfShadowCounterLost", 18, 1, [.objectName("Daycare")], .integer, "can't deposit shadow pokemon in xd"), //# int((shadowPokemonCounter - initialShadowPokemonCounter)/100)
		("depositPokemon", 19, 2, [.objectName("Daycare"), .integerIndex], .null, ""), // int party index
		("withdrawPokemon", 20, 2, [.objectName("Daycare"), .integerIndex], .null, ""), // int party index to set as withdrawn pokemon
		("calculateFee", 22, 2, [.objectName("Daycare"), .integer], .integerMoney, ""),
		("checkIfHasPokemonDeposited", 23, 1, [.objectName("Daycare")], .bool, ""),
		("getDepositedPokemonData", 24, 1, [.objectName("Daycare")], .objectName("Pokemon"), ""),
	],
	
//MARK: - Thread
	54 : [
		("createThread", 16, 2, [.objectName("TaskManager"), .integer], .integer, "possibly broken"), //# returns taskUID ... allocates a task but seems to do nothing ... BROKEN ?
		("zero", 17, 1, [.objectName("TaskManager")], .integer, "returns 0"),
		("getTaskCounter", 18, 1, [.objectName("TaskManager")], .integer, ""),
		("deleteThread", 19, 2, [.objectName("TaskManager"), .integer], .null, ""), //# unusable
	],
	
//MARK: - Moves
	58 : [
		("initializeSequence", 16, 1, [.anyType], .objectName("Move"), ""),
		("beginAnimation", 17, 5, [.objectName("Move"), .integer, .integer, .integer, .bool], .null, "(id, seconds, unk, unk)"), // int id, int duration, unk, unk
		("setPosition", 18, 2, [.objectName("Move"), .vector], .null, ""),
		("setRotation", 19, 2, [.objectName("Move"), .vector], .null, ""),
		("setScale", 20, 2, [.objectName("Move"), .vector], .null, ""),
		("await", 21, 2, [.objectName("Move"), .bool], .null, "wait for completion?"),
		("deinitializeSequence", 22, 1, [.objectName("Move")], .null, ""),
	],
	
//MARK: - Shadow Pokemon
	59 : [
		//# Shadow Pokemon status:
		//# 0 : not seen
		//# 1 : seen, as spectator (not battled against)
		//# 2 : seen and battled against
		//# 3 : caught
		//# 4 : purified
		("isShadowPokemonPurified", 16, 2, [.objectName("ShadowPokemon"), .shadowID], .bool, ""),
		("isShadowPokemonCaught", 17, 2, [.objectName("ShadowPokemon"), .shadowID], .bool, ""),
		("setShadowPokemonStatus", 18, 3, [.objectName("ShadowPokemon"), .shadowID, .shadowStatus], .null, ""),
		("getShadowPokemonSpecies", 19, 2, [.objectName("ShadowPokemon"), .shadowID], .pokemon, ""),
		("getShadowPokemonStatus", 20, 2, [.objectName("ShadowPokemon"), .shadowID], .shadowStatus, ""),
		("setShadowPokemonEncountered", 21, 1, [.objectName("ShadowPokemon")], .null, ""),
		("setShadowPokemonPCLocation", 22, 4, [.objectName("ShadowPokemon"), .shadowID, .PCBox, .integerIndex], .null, "(box number, position)"), //# (int index, int subIndex)
	],
	
//MARK: - Pokespot
	60 : [
		("openPokesnackInputMenu", 16, 2, [.objectName("Pokespot"), .pokespot], .integer, "(pokespot id)"),
		("getCurrentWildPokemon", 17, 2, [.objectName("Pokespot"), .pokespot], .pokemon, "(pokespot id)"), //# (int pokespotId)
		("setSnacksTotal", 18, 3, [.objectName("Pokespot"), .pokespot, .integerQuantity], .null, "(pokespot id, total)"),
		("getSnacksTotal", 19, 3, [.objectName("Pokespot"), .pokespot], .integerQuantity, "(pokespot id, total)"),
		("isEncounterShiny", 20, 2, [.objectName("Pokespot"), .pokespot], .bool, "(pokespot id)")
	]
	
]



struct CustomScriptClassFunction: Codable {
	let name: String
	let index: Int
	let parameters: Int
	let hint: String

	var asTuple: (name: String, index: Int, parameterCount: Int, parameterTypes: [XDSMacroTypes?]?, returnType: XDSMacroTypes?, hint: String) {
		return (name, index, parameters, nil, nil, hint)
	}
}

struct CustomScriptClass: Codable {
	let name: String
	let index: Int
	let functions: [CustomScriptClassFunction]

	static var dummy: CustomScriptClass {
		return .init(name: "dummy", index: -1, functions: [.init(name: "dummy", index: -1, parameters: 0, hint: "dummy")])
	}
}






























