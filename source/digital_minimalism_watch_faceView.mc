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

        // clearElement("TimeLabel");
        // clearElement("DateLabel");
        // clearElement("BatteryLabel");
        // clearElement("StepsLabel");
        // clearElement("HeartRateLabel");

        displayTime("TimeLabel");
        displayDate("DateLabel");
        displayBattery("BatteryLabel");
        displayBatteryIcon("BatteryIcon");
        displaySteps("StepsLabel");
        displayHeartRate("HeartRateLabel");
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // drawings not updating the layout need to be made after View.onUpdate
        // as View.onUpdate removes them
        displayStepsProgress(dc);
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





    function clearElement(id as String) as Void {
        var view = View.findDrawableById(id) as Text;
        view.setText("");
    }

    function displayTime(id as String) as Void {
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
        var view = View.findDrawableById(id) as Text;
        view.setColor(color);
        view.setText(text);
    }

    function displayDate(id as String) {
        // settings
        var color = getApp().getProperty("DateColor") as Number;
        var displayMonth = getApp().getProperty("DisplayMonth") as Boolean;

        // data and format
        var format = "$1$ $2$";
        if (displayMonth) { format = "$1$, $2$ $3$"; }
        var localTimeInfo = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dayOfWeek = localTimeInfo.day_of_week.toUpper();
        var day = localTimeInfo.day.format("%02d");
        var month = localTimeInfo.month;
        var text = Lang.format(format, [dayOfWeek, day, month]);

        // update the view
		var view = View.findDrawableById(id) as Text;
        view.setColor(color);
		view.setText(text);
    }

    function displayBattery(id as String) {
        // settings
        var color = getApp().getProperty("BatteryColor") as Number;

        // data and format
        var format = "$1$%";
        var battery = System.getSystemStats().battery;
        var text = Lang.format(format, [battery.format("%2d")]);

        // update the view
        var view = View.findDrawableById(id) as Text;
        if (battery <= getApp().getProperty("BatteryThreshold").toFloat()) {
            view.setColor(color);
            view.setText(text);
        } else {
            view.setText("");
        }
    }

    function displayBatteryIcon(id as String) {
        // data
        var battery = System.getSystemStats().battery;

        // update the view
        var view = View.findDrawableById(id) as Text;
        if (battery <= getApp().getProperty("BatteryThreshold").toFloat()) {
            view.setColor(iconsColor);
            if (battery >80) { view.setText("f"); }
            if (battery <=80) { view.setText("d"); }
            if (battery <=60) { view.setText("c"); }
            if (battery <=40) { view.setText("b"); }
            if (battery <=20) { view.setText("a"); }
        } else {
            view.setText("");
        }
    }

    function displaySteps(id as String) {
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
		var view = View.findDrawableById(id) as Text;
        view.setColor(color);
		view.setText(text);

        view = View.findDrawableById("StepsIcon") as Text;
        view.setColor(iconsColor);
    }

    function displayHeartRate(id as String) {
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
        var view = View.findDrawableById(id);
        view.setColor(color);
        view.setText(text);

        view = View.findDrawableById("HeartRateIcon") as Text;
        view.setColor(iconsColor);
    }

    function displayStepsProgress(dc as DC) {
        if (getApp().getProperty("DisplayStepsProgress")) {
            var xCenter = dc.getWidth() / 2.0;
            var yCenter = dc.getWidth() / 2.0;
            
            var attr = Graphics.ARC_CLOCKWISE;
            var penWidth = 3;
            // show the whole pen and account for "center" not beeing centered on "even" displays
            var radius = xCenter - penWidth - 1;

            var steps = ActivityMonitor.getInfo().steps as Number;
            var stepGoal = ActivityMonitor.getInfo().stepGoal as Number;
            var progress = (steps.toFloat() / stepGoal) as Float;
            var color = getApp().getProperty("StepsProgressColor") as Number;

            if (steps > 0) {
                // Degree -> Time
                // API: 0 -> 0300, 90 -> 1200, 180 -> 0900, 270 -> 0600
                // APP: 0 -> 1200, 90 -> 0300, 180 -> 0600, 270 -> 0900
                var degree = 360 - (360.0 * progress - 90.0); // API -> APP
                if (degree < 90) { degree = 90; } // goal has been reached

                dc.setPenWidth(penWidth);
                dc.setColor(color, Graphics.COLOR_BLACK);
                dc.drawArc(xCenter, yCenter, radius, attr, 90, degree);
            }
        }
    }
}
