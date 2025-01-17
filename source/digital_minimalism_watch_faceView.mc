import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class digital_minimalism_watch_faceView extends WatchUi.WatchFace {
    const batteryIcon000 = "a";
    const batteryIcon020 = "b";
    const batteryIcon040 = "c";
    const batteryIcon060 = "d";
    const batteryIcon080 = "e";
    const batteryIcon100 = "f";
    const stepsIcon = "g";
    const heartRateIcon = "h";
    const temperatureIcon = "i";

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
    function onShow() as Void { }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        renderWatchFace(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void { }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void { }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void { }

    // -----------------------------------------------------------------------
    // Rendering
    // -----------------------------------------------------------------------

    private function renderWatchFace(dc as Dc) as Void {
        iconsColor = getProperty("IconsColor") as Number;

        // Time & Date
        renderTime("TimeLabel");
        renderDate("DateLabel");

        // Field 1
        renderHeartRate("HeartRateLabel");
        renderHeartRateIcon("HeartRateIcon");
        renderTemperature("HeartRateLabel");
        renderTemperatureIcon("HeartRateIcon");

        // Field 2
        renderSteps("StepsLabel");
        renderStepsIcon("StepsIcon");

        // Field 3
        renderBattery("BatteryLabel");
        renderBatteryIcon("BatteryIcon");

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // drawings not updating the layout need to be made after View.onUpdate
        // as View.onUpdate removes them
        renderStepsProgress(dc);
    }

    private function renderTime(id as String) as Void {
        // settings
        var useMilitaryFormat = getProperty("UseMilitaryFormat") as Boolean;
        var color = getProperty("TimeColor") as Number;

        // data
        var is24Hour = System.getDeviceSettings().is24Hour as Boolean;
        var time = System.getClockTime() as System.ClockTime;
        var hours = time.hour;
        var minutes = time.min;

        // format
        var format = "$1$:$2$";
        if (!is24Hour && hours > 12) {
            hours = hours - 12;
        }
        if (useMilitaryFormat) {
            format = "$1$$2$";
            hours = hours.format("%02d");
        }
        var text = Lang.format(format, [hours, minutes.format("%02d")]);

        // update view
        var view = View.findDrawableById(id) as Text;
        view.setColor(color);
        view.setText(text);
    }

    private function renderDate(id as String) as Void {
        // settings
        var displayDate = getProperty("DisplayDate") as Boolean;
        var displayMonth = getProperty("DisplayMonth") as Boolean;
        var color = getProperty("DateColor") as Number;
        if (!displayDate) { clearElement(id); return; }

        // data
        var localTimeInfo = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dayOfWeek = localTimeInfo.day_of_week;
        var day = localTimeInfo.day;
        var month = localTimeInfo.month;

        // format
        var format = "$1$ $2$";
        if (displayMonth) { format = "$1$, $2$ $3$"; }
        var text = Lang.format(format, [dayOfWeek.toUpper(), day.format("%02d"), month]);

        // update view
        var view = View.findDrawableById(id) as Text;
        view.setColor(color);
        view.setText(text);
    }

    private function renderHeartRate(id as String) as Void {
        // settings
        var displayHeartRate = getProperty("DisplayHeartRate") as Boolean;
        var color = getProperty("HeartRateColor") as Number;
        if (!displayHeartRate) { clearElement(id); return; }

        // data
        var heartRate = Activity.getActivityInfo().currentHeartRate as Number or Null;

        // format
        var format = "$1$";
        var text = "-";
        if (heartRate != null) {
            text = Lang.format(format, [heartRate.format("%d")]);
        }

        // update view
        var view = View.findDrawableById(id) as Text;
        view.setColor(color);
        view.setText(text);
    }

    private function renderHeartRateIcon(id as String) as Void {
        // settings
        var displayHeartRate = getProperty("DisplayHeartRate") as Boolean;
        if (!displayHeartRate) { clearElement(id); return; }

        // update view
        var view = View.findDrawableById(id) as Text;
        view.setText(heartRateIcon);
        view.setColor(iconsColor);
    }

    private function renderTemperature(id as String) as Void {
        // settings
        var displayTemperature = getProperty("DisplayTemperature") as Boolean;
        var color = getProperty("TemperatureColor") as Number;
        if (!displayTemperature) { return; }

        // data
        var temperature = Weather.getCurrentConditions().temperature as Number or Null;

        // format
        var format = "$1$";
        var text = "-";
        if (temperature != null) {
            text = Lang.format(format, [temperature.format("%d")]);
        }

        // update view
        var view = View.findDrawableById(id) as Text;
        view.setColor(color);
        view.setText(text);
    }

    private function renderTemperatureIcon(id as String) as Void {
        // settings
        var displayTemperature = getProperty("DisplayTemperature") as Boolean;
        if (!displayTemperature) { return; }

        // update view
        var view = View.findDrawableById(id) as Text;
        view.setText(temperatureIcon);
        view.setColor(iconsColor);
    }

    private function renderSteps(id as String) as Void {
        // settings
        var displaySteps = getProperty("DisplaySteps") as Boolean;
        var color = getProperty("StepsColor") as Number;
        if (!displaySteps) { clearElement(id); return; }

        // data
        var steps = ActivityMonitor.getInfo().steps as Number or Null;

        // format
        var format = "$1$";
        var text = "-";
        if (steps != null) {
            text = Lang.format(format, [steps.format("%d")]);
        }

        // update view
        var view = View.findDrawableById(id) as Text;
        view.setColor(color);
        view.setText(text);
    }

    private function renderStepsIcon(id as String) as Void {
        // settings
        var displaySteps = getProperty("DisplaySteps") as Boolean;
        if (!displaySteps) { clearElement(id); return; }

        // update view
        var view = View.findDrawableById(id) as Text;
        view.setText(stepsIcon);
        view.setColor(iconsColor);
    }

    private function renderBattery(id as String) as Void {
        // settings
        var color = getProperty("BatteryColor") as Number;
        var batteryThreshold = getProperty("BatteryThreshold").toFloat() as Float;

        // data
        var battery = System.getSystemStats().battery;

        // format
        var format = "$1$%";
        var text = Lang.format(format, [battery.format("%2d")]);

        // update view
        var view = View.findDrawableById(id) as Text;
        if (battery <= batteryThreshold) {
            view.setColor(color);
            view.setText(text);
        } else {
            view.setText("");
        }
    }

    private function renderBatteryIcon(id as String) as Void {
        // settings
        var batteryThreshold = getProperty("BatteryThreshold").toFloat() as Float;

        // data
        var battery = System.getSystemStats().battery as Float;

        // update view
        var view = View.findDrawableById(id) as Text;
        if (battery <= batteryThreshold) {
            view.setColor(iconsColor);
            // TODO: Also use the 80 indication
            if (battery >80) { view.setText(batteryIcon100); }
            if (battery <=80) { view.setText(batteryIcon060); }
            if (battery <=60) { view.setText(batteryIcon040); }
            if (battery <=40) { view.setText(batteryIcon020); }
            if (battery <=20) { view.setText(batteryIcon000); }
        } else {
            view.setText("");
        }
    }

    private function renderStepsProgress(dc as Dc) as Void {
        // settings
        var displayStepsProgress = getProperty("DisplayStepsProgress") as Boolean;
        var stepsProgressColor = getProperty("StepsProgressColor") as Number;
        if (!displayStepsProgress) { return; }

        // data
        var steps = ActivityMonitor.getInfo().steps as Number;
        var stepGoal = ActivityMonitor.getInfo().stepGoal as Number;

        // calculations
        var stepsProgress = (steps % stepGoal) as Number;
        if (stepsProgress == 0) { return; }
        var percentageProgress = (stepsProgress.toFloat() / stepGoal) as Float;
        var degree = percentageToDegree(percentageProgress);
        var attr = Graphics.ARC_CLOCKWISE;
        if ((((steps / stepGoal) as Number) % 2) == 1) {
            attr = Graphics.ARC_COUNTER_CLOCKWISE;
        }

        // format
        var xCenter = dc.getWidth() / 2.0;
        var yCenter = dc.getWidth() / 2.0;
        var penWidth = 3;
        // show the whole pen and account for "center" not beeing centered on "even" displays
        var radius = xCenter - penWidth - 1;

        // update view
        dc.setPenWidth(penWidth);
        dc.setColor(stepsProgressColor, Graphics.COLOR_BLACK);
        dc.drawArc(xCenter, yCenter, radius, attr, 90, degree);
    }

    // -----------------------------------------------------------------------
    // Helpers
    // -----------------------------------------------------------------------

    private function clearElement(id as String) as Void {
        var view = View.findDrawableById(id) as Text;
        view.setText("");
    }

    private function getProperty(id as String) {
        // TODO: Cache Application in instance variable
        return getApp().getProperty(id);
    }

    private function percentageToDegree(percentage as Float) {
        // Degree -> Time
        // API: 0 -> 0300, 90 -> 1200, 180 -> 0900, 270 -> 0600
        // APP: 0 -> 1200, 90 -> 0300, 180 -> 0600, 270 -> 0900
        return 360 - (360.0 * percentage - 90.0); // API -> APP
    }
}
