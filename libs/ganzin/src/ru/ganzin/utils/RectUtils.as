/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 20.02.12
 * Time: 15:39
 */
package ru.ganzin.utils
{
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class RectUtils
    {
        public static function localToGlobal(rect:Rectangle, target:DisplayObject):Rectangle
        {
            var retRect:Rectangle = new Rectangle();
            retRect.topLeft = target.localToGlobal(rect.topLeft);
            retRect.bottomRight = target.localToGlobal(rect.bottomRight);
            return retRect;
        }

        public static function globalToLocal(rect:Rectangle, target:DisplayObject):Rectangle
        {
            var retRect:Rectangle = new Rectangle();
            retRect.topLeft = target.globalToLocal(rect.topLeft);
            retRect.bottomRight = target.globalToLocal(rect.bottomRight);
            return retRect;
        }

        public static function getCenter(rect:Rectangle):Point
        {
            return rect.topLeft.add(new Point(rect.width / 2, rect.height / 2));
        }

        public static function subtract(r1:Rectangle, r2:Rectangle):Vector.<Rectangle>
        {
            // discover the edges of r1 that are covered by r2
            var left:Boolean = r2.x <= r1.x && r2.x + r2.width > r1.x;
            var right:Boolean = r2.x < r1.x + r1.width && r2.x + r2.width >= r1.x + r1.width;
            var top:Boolean = r2.y <= r1.y && r2.y + r2.height > r1.y;
            var bottom:Boolean = r2.y < r1.y + r1.height && r2.y + r2.height >= r1.y + r1.height;

            var resultList:Vector.<Rectangle> = new <Rectangle>[];

            if (left && right && top && bottom)
            {
                // r2 fully obscures r1; no results
            } else if (left && right && top)
            {
                // r2 across top edge
                var y:int = r2.y + r2.height;
                var height:int = r1.y + r1.height - y;
                resultList.push(new Rectangle(r1.x, y, r1.width, height));
            } else if (left && right && bottom)
            {
                // r2 across bottom edge
                resultList.push(new Rectangle(r1.x, r1.y, r1.width, r2.y - r1.y));
            } else if (top && bottom && left)
            {
                // r2 across left edge
                var x:int = r2.x + r2.width;
                var width:int = r1.x + r1.width - x;
                resultList.push(new Rectangle(x, r1.y, width, r1.height));
            } else if (top && bottom && right)
            {
                // r2 across right edge
                resultList.push(new Rectangle(r1.x, r1.y, r2.x - r1.x, r1.height));
            } else if (left && top)
            {
                // r2 covers top-left corner
                var x:int = r2.x + r2.width;
                var y:int = r2.y + r2.height;
                resultList.push(new Rectangle(x, r1.y, r1.x + r1.width - x, y - r1.y));
                resultList.push(new Rectangle(r1.x, y, r1.width, r1.y + r1.height - y));
            } else if (left && bottom)
            {
                // r2 covers bottom-left corner
                resultList.push(new Rectangle(r1.x, r1.y, r1.width, r2.y - r1.y));
                var x:int = r2.x + r2.width;
                resultList.push(new Rectangle(x, r2.y, r1.x + r1.width - x, r1.y + r1.height - r2.y));
            } else if (right && top)
            {
                // r2 covers top-right corner
                var y:int = r2.y + r2.height;
                resultList.push(new Rectangle(r1.x, r1.y, r2.x - r1.x, y - r1.y));
                resultList.push(new Rectangle(r1.x, y, r1.width, r1.y + r1.height - y));
            } else if (right && bottom)
            {
                // r2 covers bottom-right corner
                resultList.push(new Rectangle(r1.x, r1.y, r1.width, r2.y - r1.y));
                resultList.push(new Rectangle(r1.x, r2.y, r2.x - r1.x, r1.y + r1.height - r2.y));
            } else if (left && right)
            {
                // r2 divides r1 into 2 horizontal rectangles
                resultList.push(new Rectangle(r1.x, r1.y, r1.width, r2.y - r1.y));
                var y:int = r2.y + r2.height;
                resultList.push(new Rectangle(r1.x, y, r1.width, r1.y + r1.height - y));
            } else if (top && bottom)
            {
                // r2 divides r1 into 2 vertical rectangles
                resultList.push(new Rectangle(r1.x, r1.y, r2.x - r1.x, r1.height));
                var x:int = r2.x + r2.width;
                resultList.push(new Rectangle(x, r1.y, r1.x + r1.width - x, r1.height));
            } else if (left)
            {
                // r2 crosses left edge only, dividing r1 into 3 rectangles
                resultList.push(new Rectangle(r1.x, r1.y, r1.width, r2.y - r1.y));
                var y:int = r2.y + r2.height;
                resultList.push(new Rectangle(r1.x, y, r1.width, r1.y + r1.height - y));
                var x:int = r2.x + r2.width;
                resultList.push(new Rectangle(x, r2.y, r1.x + r1.width - x, r2.height));
            } else if (right)
            {
                // r2 crosses right edge only, dividing r1 into 3 rectangles
                resultList.push(new Rectangle(r1.x, r1.y, r1.width, r2.y - r1.y));
                var y:int = r2.y + r2.height;
                resultList.push(new Rectangle(r1.x, y, r1.width, r1.y + r1.height - y));
                resultList.push(new Rectangle(r1.x, r2.y, r2.x - r1.x, r2.height));
            } else if (top)
            {
                // r2 crosses top edge only, dividing r1 into 3 rectangles
                resultList.push(new Rectangle(r1.x, r1.y, r2.x - r1.x, r1.height));
                var x:int = r2.x + r2.width;
                resultList.push(new Rectangle(x, r1.y, r1.x + r1.width - x, r1.height));
                var y:int = r2.y + r2.height;
                resultList.push(new Rectangle(r2.x, y, r2.width, r1.y + r1.height - y));
            } else if (bottom)
            {
                // r2 crosses bottom edge only, dividing r1 into 3 rectangles
                resultList.push(new Rectangle(r1.x, r1.y, r1.width, r2.y - r1.y));
                var height:int = r1.y + r1.height - r2.y;
                resultList.push(new Rectangle(r1.x, r2.y, r2.x - r1.x, height));
                var x:int = r2.x + r2.width;
                resultList.push(new Rectangle(x, r2.y, r1.x + r1.width - x, height));
            } else
            {
                // r2 is completely contained within r1, dividing r1 into 4 rectangles
                resultList.push(new Rectangle(r1.x, r1.y, r1.width, r2.y - r1.y));
                var y:int = r2.y + r2.height;
                resultList.push(new Rectangle(r1.x, y, r1.width, r1.y + r1.height - y));
                resultList.push(new Rectangle(r1.x, r2.y, r2.x - r1.x, r2.height));
                var x:int = r2.x + r2.width;
                resultList.push(new Rectangle(x, r2.y, r1.x + r1.width - x, r2.height));
            }

            return resultList;
        }

        public static function subtractRects(rects1:Vector.<Rectangle>, rects2:Vector.<Rectangle>):Vector.<Rectangle>
        {
            var rectangleList:Vector.<Rectangle> = rects1.concat();
            var newRectangleList:Vector.<Rectangle> = new <Rectangle>[];

            for each (var r2:Rectangle in rects2)
            {
                for each (var r1:Rectangle in rectangleList)
                {
                    if (r1.intersects(r2)) newRectangleList = newRectangleList.concat(subtract(r1, r2));
                    else newRectangleList.push(r1.clone());
                }

                if (newRectangleList.length == 0) break;
                rectangleList = newRectangleList.concat();
                newRectangleList = new <Rectangle>[];
            }

            return rectangleList;
        }

        public static function getPolygonPoints(rect:Rectangle):Array
        {
            return [new Point(rect.left, rect.top), new Point(rect.right, rect.top),
                new Point(rect.right, rect.bottom), new Point(0, rect.bottom)];
        }
    }
}

