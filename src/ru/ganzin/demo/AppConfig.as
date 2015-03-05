/**
 * Created by jaboko on 27.02.15.
 */
package ru.ganzin.demo
{
    import flash.events.UncaughtErrorEvent;

    import robotlegs.bender.extensions.matching.TypeMatcher;
    import robotlegs.bender.framework.api.IConfig;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.LogLevel;
    import robotlegs.starling.extensions.viewProcessorMap.api.IViewProcessorMap;

    import ru.ganzin.demo.model.AuthModel;
    import ru.ganzin.demo.signals.StartupSignal;
    import ru.ganzin.demo.view.base.ViewBase;
    import ru.ganzin.robotlegs.services.debugservice.DebugServiceExtension;

    public class AppConfig implements IConfig
    {
        [Inject]
        public var context:IContext;

        [Inject]
        public var viewProcessorMap:IViewProcessorMap;

        [Inject]
        public var injector:IInjector;

        public function configure():void
        {
            injector.map(AuthModel).asSingleton();

            context.configure(SignalsConfig, ViewConfig, ServerConfig);
            viewProcessorMap.mapMatcher(new TypeMatcher().allOf(ViewBase)).toInjection();

            context.logLevel = LogLevel.DEBUG;
            context.install(DebugServiceExtension);

            context.afterInitializing(init);
        }

        private function init():void
        {
            injector.getOrCreateNewInstance(StartupSignal).dispatch();
        }
    }
}

import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.starling.extensions.mediatorMap.api.IMediatorMap;

import ru.ganzin.demo.controller.SignInCommand;
import ru.ganzin.demo.controller.SignOutCommand;
import ru.ganzin.demo.controller.SignUpCommand;
import ru.ganzin.demo.controller.StartupCommand;
import ru.ganzin.demo.mediators.LoginScreenMediator;
import ru.ganzin.demo.mediators.MainScreenMediator;
import ru.ganzin.demo.mediators.ProfileScreenMediator;
import ru.ganzin.demo.service.auth.AuthHTTPServerService;
import ru.ganzin.demo.service.auth.packets.GetProfileResultPacket;
import ru.ganzin.demo.service.auth.packets.SignInResultPacket;
import ru.ganzin.demo.service.auth.packets.SignOutResultPacket;
import ru.ganzin.demo.service.auth.packets.SignUpResultPacket;
import ru.ganzin.demo.signals.StartupSignal;
import ru.ganzin.demo.signals.requests.ShowScreenSignal;
import ru.ganzin.demo.signals.requests.SignInRequestSignal;
import ru.ganzin.demo.signals.requests.SignOutRequestSignal;
import ru.ganzin.demo.signals.requests.SignUpRequestSignal;
import ru.ganzin.demo.view.MainView;
import ru.ganzin.demo.view.screens.LoginScreen;
import ru.ganzin.demo.view.screens.ProfileScreen;
import ru.ganzin.robotlegs.server.ServerHandlerInvoker;
import ru.ganzin.robotlegs.server.api.IServerService;

class ViewConfig implements IConfig
{
    [Inject]
    public var mediatorMap:IMediatorMap;

    public function configure():void
    {
        mediatorMap.map(MainView).toMediator(MainScreenMediator);
        mediatorMap.map(LoginScreen).toMediator(LoginScreenMediator);
        mediatorMap.map(ProfileScreen).toMediator(ProfileScreenMediator);
    }
}

class SignalsConfig implements IConfig
{
    [Inject]
    public var commandMap:ISignalCommandMap;

    [Inject]
    public var injector:IInjector;

    public function configure():void
    {
        injector.map(ShowScreenSignal).asSingleton();

        commandMap.map(StartupSignal).toCommand(StartupCommand);
        commandMap.map(SignInRequestSignal).toCommand(SignInCommand);
        commandMap.map(SignUpRequestSignal).toCommand(SignUpCommand);
        commandMap.map(SignOutRequestSignal).toCommand(SignOutCommand);
    }
}

class ServerConfig implements IConfig
{
    [Inject]
    public var injector:IInjector;

    public function configure():void
    {
        injector.map(IServerService).toSingleton(AuthHTTPServerService);
        injector.map(ServerHandlerInvoker).asSingleton();

        var s:IServerService = injector.getInstance(IServerService);
        s.registerResultPacket(SignUpResultPacket);
        s.registerResultPacket(SignInResultPacket);
        s.registerResultPacket(SignOutResultPacket);
        s.registerResultPacket(GetProfileResultPacket);
    }
}