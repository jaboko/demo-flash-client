/**
 * Created by IntelliJ IDEA.
 * User: Dmitriy Ganzin
 * Date: 07.06.12
 * Time: 17:03
 */
package ru.ganzin.utils {

    import flash.geom.Point;

    public class RamerDuolasPeuckerSimplify {

		public static function build(points:Vector.<Point>, tolerance:Number) : Vector.<Point> {
			var rdp:RamerDuolasPeuckerSimplify = new RamerDuolasPeuckerSimplify(points);
			return rdp.simplify(tolerance);
		}

		public static function buildByArray(points:Array, tolerance:Number) : Vector.<Point> {
			var list:Vector.<Point> = new Vector.<Point>;
			for each (var pnt : Point in points) list.push(pnt);
			return build(list, tolerance);
		}

		public function RamerDuolasPeuckerSimplify(points:Vector.<Point>) {
			this.points = points;
		}

		/**
		 * Ramer-Doulas-Peucker method
		 * A well known algorythm
		 * Not very simple, a little slow ()
		 * O(nm) worst case time, and O(n log m) expected time
		 * where m is the size of the simplified polyline.
		 * but works fine with complex shapes
		 */

		private var points : Vector.<Point>;

		public function simplify(tolerance : Number) : Vector.<Point> {
			if (points == null || points.length < 3 || tolerance == 0)
				return points;
			var firstPoint : int = 0;
			var lastPoint : int = points.length - 1;
			var pointIndexsToKeep : Vector.<int> = new Vector.<int>;
			pointIndexsToKeep[0] = firstPoint
			pointIndexsToKeep[1] = lastPoint
			//p1.x==p2.x && p1.y==p2.y is 4x faster than p1.equals(p2)
			while (points[firstPoint].x == points[lastPoint].x && points[firstPoint].y == points[lastPoint].y) {
				lastPoint--;
			}
			RamerDouglasPeuckerReduction(points, firstPoint, lastPoint, tolerance, pointIndexsToKeep);
			var newPoints : Vector.<Point> = new Vector.<Point>();
			pointIndexsToKeep.sort(Array.NUMERIC)
			var len : int = pointIndexsToKeep.length - 1;
			for (var i : int = 0; i < len; i++) {
				newPoints[i] = points[pointIndexsToKeep[i]];
			}
			return newPoints;
		}

		private function RamerDouglasPeuckerReduction(points : Vector.<Point>, firstPoint : int, lastPoint : int, tolerance : Number,
													  pointIndexsToKeep : Vector.<int>) : void {
			var maxDistance : Number = 0;
			var indexFarthest : int = 0;
			for (var index : int = firstPoint; index < lastPoint; index++) {
				var distance : Number = PerpendicularDistance(points[firstPoint], points[lastPoint], points[index]);
				if (distance > maxDistance) {
					maxDistance = distance;
					indexFarthest = index;
				}
			}
			if (maxDistance > tolerance && indexFarthest != 0) {
				pointIndexsToKeep.push(indexFarthest);
				RamerDouglasPeuckerReduction(points, firstPoint, indexFarthest, tolerance, pointIndexsToKeep);
				RamerDouglasPeuckerReduction(points, indexFarthest, lastPoint, tolerance, pointIndexsToKeep);
			}
		}

		public function PerpendicularDistance(point1 : Point, point2 : Point, point : Point) : Number {
			var area : Number = abs((point1.x * point2.y + point2.x * point.y + point.x * point1.y - point2.x * point1.y - point.x * point2.y - point1.x * point.y) >> 1);
			var bottom : Number = Math.sqrt(((point1.x - point2.x) * (point1.x - point2.x)) + ((point1.y - point2.y) * (point1.y - point2.y)));
			return (area / bottom) << 1;
		}

		//Very fast abs comparing to Math.abs using bitwise operators
		private function abs(value : Number) : Number {
			return ((value ^ (value >> 31)) - (value >> 31));
		}
	}
}
