package ru.ganzin.apron2.executor.tasks
{
	import flash.events.EventDispatcher;

	import org.osflash.signals.Signal;

	import ru.ganzin.apron2.executor.TaskResult;
	import ru.ganzin.apron2.executor.events.TaskEvent;

	public class SignalTask extends EventDispatcher implements ITask
	{
		private var func:Function;
		private var signal:Signal;

		public function SignalTask(func:Function, signal:Signal)
		{
			this.func = func;
			this.signal = signal;
		}

		public function invoke():void
		{
			signal.addOnce(signalHandler);
			if (func != null) func();
		}

		private function signalHandler(...rest):void
		{
			dispatchEvent(new TaskEvent(TaskEvent.TASK_COMPLETE, TaskResult.COMPLETE));
		}
	}
}