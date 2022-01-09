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
    function getInitialView() as Array<Views or InputDelegates>? {
        return [new digital_minimalism_watch_faceView()] as Array<Views or InputDelegates>;
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    function getSettingsView() as Array<Views or InputDelegates>? {
        return [new SettingsView(), new SettingsDelegate()] as Array<Views or InputDelegates>;
    }

}

function getApp() as digital_minimalism_watch_faceApp {
    return Application.getApp() as digital_minimalism_watch_faceApp;
}