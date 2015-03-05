package ru.ganzin.utils
{
    import ru.ganzin.apron2.interfaces.IDisposable;
    import ru.ganzin.apron2.managers.process.Process;
    import ru.ganzin.apron2.managers.process.ProcessManager;
    import ru.ganzin.apron2.managers.process.ProcessState;
    import ru.ganzin.apron2.utils.Delegate;
    import ru.ganzin.apron2.utils.UIDUtil;

    public class CallLaterManager implements IDisposable
    {
        public static const HIGH_PRIORITY_CALL:uint = 0x20;
        public static const NORMAL_PRIORITY_CALL:uint = 0x10;
        public static const LOW_PRIORITY_CALL:uint = 0x0;

        public static const CLEAR_ALL_PREV_ACTION:uint = 0x100;

        private var methodQueue:Array = [];
        private var processManager:ProcessManager = null;
        private var callLaterProcess:Process;

        private var disposed:Boolean = false;

        public function CallLaterManager()
        {
        }

        public function dispose():void
        {
            if (disposed) return;

            methodQueue = [];
            if (processManager) processManager.removeAllProcesses();
            disposed = true;
        }

        public function addWithTarget(target:*, method:Function, args:Array = null, flags:int = -1, delayFrames:uint = 0):String
        {
            if (disposed)
            {
                trace("hmm..");
            }

            if (flags == -1) flags = CLEAR_ALL_PREV_ACTION;

            var mqe:MethodQueueElement = new MethodQueueElement(Delegate.create(target, method, args), flags, delayFrames);

            var needAdd:Boolean;
            var insertIndex:uint = methodQueue.length;

            var mqeItem:MethodQueueElement;
            var i:uint;

            switch (mqe.action)
            {
                case CLEAR_ALL_PREV_ACTION:

                    needAdd = true;
                    for (i = 0; i < methodQueue.length; i++)
                    {
                        mqeItem = methodQueue[i];
                        if (mqeItem.equals(mqe)) methodQueue.splice(i--, 1);
                    }

                    break;

                default:
                {
                    for (i = 0; i < methodQueue.length; i++)
                    {
                        mqeItem = methodQueue[i];
                        if (mqe.priority > mqeItem.priority)
                        {
                            if (methodQueue[i - 1] && (methodQueue[i - 1] as MethodQueueElement).equals(mqe))
                            {
                                needAdd = false;
                            }
                            else
                            {
                                needAdd = true;
                                insertIndex = i;
                            }

                            break;
                        }

                        if (i == (methodQueue.length - 1) &&
                                !(methodQueue[methodQueue.length - 1] as MethodQueueElement).equals(mqe))
                        {

                            needAdd = true;
                            insertIndex = methodQueue.length;
                        }
                    }
                }
            }

            if (needAdd)
            {
                methodQueue.splice(insertIndex, 0, mqe);
            }
            else if (methodQueue.length == 0)
            {
                methodQueue.push(mqe);
            }

            if (!processManager)
            {
                processManager = new ProcessManager();
                callLaterProcess = new Process(callLaterDispatcher);
            }

            if (!processManager.hasProcess(callLaterProcess) && methodQueue.length > 0)
                processManager.addProcess(callLaterProcess);

            return UIDUtil.getUID(mqe);
        }

        public function add(method:Function, args:Array = null, flags:int = -1, delayFrames:uint = 0):String
        {
            return addWithTarget(null, method, args, flags, delayFrames);
        }

        public function remove(value:String):Boolean
        {
            var uid:String = value;
            for (var i:int = 0; i < methodQueue.length; i++)
            {
                if (UIDUtil.getUID(methodQueue[i]) == uid)
                {
                    methodQueue.splice(i, 1);
                    return true;
                }
            }

            return false;
        }

        private function callLaterDispatcher():uint
        {
            var queue:Array = methodQueue;
            methodQueue = [];

            var n:int = queue.length;

            for each (var mqe:MethodQueueElement in queue)
            {
                if (disposed) return ProcessState.COMPLETED;
                if (mqe.delayFrames <= 0) mqe.apply();
                else
                {
                    mqe.delayFrames--;
                    methodQueue.push(mqe);
                }
            }

            if (queue.length == 0) return ProcessState.COMPLETED;
            return 0;
        }
    }
}

import ru.ganzin.apron2.utils.Delegate;

class MethodQueueElement
{
    protected var func:Function;

    public var flags:uint;
    public var delayFrames:uint;

    public function MethodQueueElement(func:Function, flags:uint, delayFrames:uint)
    {
        this.func = func;
        this.flags = flags;
        this.delayFrames = delayFrames;
    }

    public function get priority():uint
    {
        return flags & 0xF0;
    }

    public function get action():uint
    {
        return flags & 0xF00;
    }

    public function equals(mqe:MethodQueueElement):Boolean
    {
        if (flags == mqe.flags) return Delegate.equals(func, mqe.func);
        return false;
    }

    public function apply():void
    {
        func();
    }

}