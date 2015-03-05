/**
 * User: Dmitriy Ganzin
 * Date: 08.07.11
 * Time: 15:05
 */
package ru.ganzin.utils.html
{
    import ru.ganzin.apron2.utils.StringUtil;

    public function bold(text:*, ...args):String
	{
		var str:String = "<b>"+text+"</b>";
		return (args.length == 0) ? str : StringUtil.substitute(str, args);
	}
}
