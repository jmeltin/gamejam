package efc.body.util;

import flambe.Component;
import flambe.display.Texture;
import flambe.util.Assert;
import haxe.io.Bytes;
import haxe.ds.Vector;
import nape.geom.Vec2;
import flambe.math.Point;

class BodyTracer extends Component
{
	public static function traceTexture(data :Bytes, width :Int, height :Int, tolerance :Int) :Array<Point> 
	{
		var startPoint = getStartingPixel(data, tolerance, width, height);
		return marchingSquares(data, startPoint, tolerance, width);
	}

	private static function getStartingPixel(data :Bytes, tolerance :Int, width: Int, height :Int) :Point 
	{
		for (x in 0...width) {
			for (y in 0...height) {
				if(dataValue(data, x, y, width) > tolerance)
					return new Point(x, y);
			}
		}

		Assert.fail("no starting pixel");
		return null;
	}

	private static function getSquareValue(data :Bytes, v :Point, tolerance :Int, width :Int) :Int
	{
		Assert.that(tolerance > -1, "Tolerance must be positive. :BodyTracer.hx getSquareValue()");
		var squareValue :Int = 0;
		var x = cast v.x;
		var y = cast v.y;

		if((x!=0 && y!=0) && dataValue(data, x-1, y-1, width) > tolerance)
			squareValue |=1;
		if(y!=0 && dataValue(data, x, y-1, width) > tolerance)
			squareValue |=2;
		if(x!=0 && dataValue(data, x-1, y, width) > tolerance)
			squareValue |=4;
		if(dataValue(data, x, y, width) > tolerance)
			squareValue |=8;

		return squareValue;
	}

	private static function marchingSquares(data :Bytes, startV :Point, tolerance :Int, width :Int) :Array<Point> 
	{
		var contourVector :Array<Point> = new Array<Point>();
		var walkerV = new Point(startV.x, startV.y);
		var prevDirection : Direction = null; 

		var closedLoop :Bool = false;

		while (!closedLoop) {
			var squareValue :Int = getSquareValue(data, walkerV, tolerance, width);
			switch (squareValue) {
				case 1: prevDirection = stepUp(walkerV);
				case 2: prevDirection = stepRight(walkerV);
				case 3: prevDirection = stepRight(walkerV);
				case 4: prevDirection = stepLeft(walkerV);
				case 5: prevDirection = stepUp(walkerV);
				case 6: prevDirection = handleCase6(prevDirection, walkerV);
				case 7: prevDirection = stepRight(walkerV);
				case 8: prevDirection = stepDown(walkerV);
				case 9: prevDirection = handleCase9(prevDirection, walkerV);
				case 10: prevDirection = stepDown(walkerV);
				case 11: prevDirection = stepDown(walkerV);
				case 12: prevDirection = stepLeft(walkerV);
				case 13: prevDirection = stepUp(walkerV);
				case 14: prevDirection = stepLeft(walkerV);
			}
			contourVector.push(new Point(walkerV.x, walkerV.y));
			if (walkerV.x == startV.x && walkerV.y == startV.y)
				closedLoop=true;
		}

		return contourVector;
	}

	private static function stepLeft(v :Point) :Direction
	{
		v.x -= 1;
		return LEFT;
	}

	private static function stepUp(v :Point) :Direction
	{
		v.y -= 1;
		return UP;
	}

	private static function stepRight(v :Point) :Direction
	{
		v.x += 1;
		return RIGHT;
	}

	private static function stepDown(v :Point) :Direction
	{
		v.y += 1;
		return DOWN;
	}

	private static function handleCase6(prevDir :Direction, v :Point) :Direction
	{
		if(prevDir == UP) {
			return stepLeft(v);
		}
		return stepRight(v);
	}

	private static function handleCase9(prevDir :Direction, v :Point) :Direction
	{
		if(prevDir == RIGHT) {
			return stepUp(v);
		}
		return stepDown(v);
	}

	private static function dataValue(data :Bytes, x :Int, y :Int, width :Int) :Int
	{
		return data.get((width * y + x + 3)*4);
	}
}

enum Direction {
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

