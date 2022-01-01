import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class digital_minimalism_watch_faceView extends WatchUi.WatchFace {
    var iconsColor;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        iconsColor = getApp().getProperty("IconsColor") as Number;

        displayTime();
        displayDate();
        displayBattery();
        displaySteps();
        displayHeartRate();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }





    function displayTime() as Void {
        // settings
        var is24Hour = System.getDeviceSettings().is24Hour;
        var useMilitaryFormat = getApp().getProperty("UseMilitaryFormat");
        var color = getApp().getProperty("TimeColor") as Number;

        // data and format
        var format = "$1$:$2$";
        var time = System.getClockTime();
        var hours = time.hour;
        if (!is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (useMilitaryFormat) {
                format = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var text = Lang.format(format, [hours, time.min.format("%02d")]);

        // update the view
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(color);
        view.setText(text);
    }

    function displayDate() {
        // settings
        var color = getApp().getProperty("DateColor") as Number;

        // data and format
        var format = "$1$ $2$";
        var localTimeInfo = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var text = Lang.format(format, [localTimeInfo.day_of_week.toUpper(), localTimeInfo.day.format("%02d")]);

        // update the view
		var view = View.findDrawableById("DateLabel") as Text;
        view.setColor(color);
		view.setText(text);
    }

    function displayBattery() {
        // settings
        var color = getApp().getProperty("BatteryColor") as Number;

        // data and format
        var format = "$1$%";
        var battery = System.getSystemStats().battery;
        var text = Lang.format(format, [battery.format("%2d")]);

        // update the view
		var view = View.findDrawableById("BatteryLabel") as Text;
        view.setColor(color);
		view.setText(text);

        // update icon
        view = View.findDrawableById("BatteryIcon") as Text;
        view.setColor(iconsColor);
		if (battery >80) { view.setText("f"); }
		if (battery <=80) { view.setText("d"); }
		if (battery <=60) { view.setText("c"); }
		if (battery <=40) { view.setText("b"); }
		if (battery <=20) { view.setText("a"); }
    }

    function displaySteps() {
        // settings
        var color = getApp().getProperty("StepsColor") as Number;

        // data and format
        var format = "$1$";
        var steps = ActivityMonitor.getInfo().steps;
        var text = "-";

		if (steps != null) {   
		    text = Lang.format(format, [steps.format("%d")]);
        }

        // update the view
		var view = View.findDrawableById("StepsLabel") as Text;
        view.setColor(color);
		view.setText(text);

        view = View.findDrawableById("StepsIcon") as Text;
        view.setColor(iconsColor);
    }

    function displayHeartRate() {
        // settings
        var color = getApp().getProperty("HeartRateColor") as Number;

        // data and format
        var format = "$1$";
        var heartRate = Activity.getActivityInfo().currentHeartRate;
        var text = "-";

		if (heartRate != null) {
            text = Lang.format(format, [heartRate.format("%d")]);
        }

        // update the view
        var view = View.findDrawableById("HeartRateLabel");
        view.setColor(color);
        view.setText(text);

        view = View.findDrawableById("HeartRateIcon") as Text;
        view.setColor(iconsColor);
    }

}
