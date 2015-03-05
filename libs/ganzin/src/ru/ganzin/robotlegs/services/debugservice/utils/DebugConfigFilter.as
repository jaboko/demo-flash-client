package ru.ganzin.robotlegs.services.debugservice.utils
{
    import ru.ganzin.apron2.config.filters.ResourceFilter;
    import ru.ganzin.apron2.resources.IResourceGroup;

    public class DebugConfigFilter extends ResourceFilter
	{
		[Inject]
		public var vo:DebugConfig;

		public function DebugConfigFilter()
		{
			super(true);
		}

		public override function canApply(data:XML):Boolean
		{
			return data.name() == "debug";
		}

		override protected function complete(result:* = null):void
		{
            const group:IResourceGroup = getFirstResourceGroupByE4X(".");
            if (group.hasResource("enabled")) vo.enabled = group.getBoolean("enabled");
			if (group.hasResource("server-profiling-enabled")) vo.serverProfilingEnabled = group.getBoolean("server-profiling-enabled");

			super.complete(result);
		}
	}
}