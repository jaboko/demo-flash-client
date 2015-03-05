/**
 * Created by jaboko on 23.09.14.
 */
package ru.ganzin.utils
{
    public function arrayIntersect(a1:*, a2:*, result:*):void
    {
        for each (var o:* in a1)
            if (a2.indexOf(o) != -1)  result.push(o);
    }
}
