//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package ru.ganzin.robotlegs.services.debugservice.impl
{
    import com.junkbyte.console.Cc;

    import robotlegs.bender.extensions.enhancedLogging.impl.*;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.ILogTarget;
    import robotlegs.bender.framework.api.LogLevel;

    /**
     * A simple trace logger
     * @private
     */
    public class FlashConsoleLogTarget implements ILogTarget
    {

        /*============================================================================*/
        /* Private Properties                                                         */
        /*============================================================================*/

        private const _messageParser:LogMessageParser = new LogMessageParser();

        private var _context:IContext;

        /*============================================================================*/
        /* Constructor                                                                */
        /*============================================================================*/

        /**
         * Creates a Trace Log Target
         * @param context Context
         */
        public function FlashConsoleLogTarget(context:IContext)
        {
            _context = context;
        }

        /*============================================================================*/
        /* Public Functions                                                           */
        /*============================================================================*/

        /**
         * @inheritDoc
         */
        public function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void
        {
            if (level == LogLevel.DEBUG) Cc.debugch(source, _messageParser.parseMessage(message, params));
            else if (level == LogLevel.ERROR) Cc.errorch(source, _messageParser.parseMessage(message, params));
            else if (level == LogLevel.FATAL) Cc.fatalch(source, _messageParser.parseMessage(message, params));
            else if (level == LogLevel.INFO) Cc.infoch(source, _messageParser.parseMessage(message, params));
            else if (level == LogLevel.WARN) Cc.warnch(source, _messageParser.parseMessage(message, params));
        }
    }
}
