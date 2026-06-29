import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class digital_minimalism_watch_faceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void { }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void { }

    // Return the initial view of your application here
    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        return [new digital_minimalism_watch_faceView()];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    function getSettingsView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] or Null {
        var settingsView = new SettingsView();
        var settingsDelegate = new SettingsDelegate(settingsView);
        return [settingsView, settingsDelegate];
    }

}

function getApp() as digital_minimalism_watch_faceApp {
    return Application.getApp() as digital_minimalism_watch_faceApp;
}