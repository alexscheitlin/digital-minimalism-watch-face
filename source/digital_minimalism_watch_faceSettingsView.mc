import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Application.Properties;

class SettingsView extends WatchUi.Menu2 {
    // properties
    var displayMonth;
    var useMilitaryFormat;

    function initialize() {
        View.initialize();
        initializeProperties();

        Menu2.initialize({:title=>"Settings"});
        Menu2.setTitle("Settings");

        addDisplayMonth();
        addUseMilitaryFormat();

        // done button
        Menu2.addItem(new WatchUi.MenuItem("Done", null, "done", null));
    }

    function initializeProperties() as Void {
        useMilitaryFormat = Properties.getValue("UseMilitaryFormat");
        displayMonth = Properties.getValue("DisplayMonth");
    }

    // onShow() is called when this View is brought to the foreground
    function onShow() { }

    // onUpdate() is called periodically to update the View
    function onUpdate(dc) { }

    // onHide() is called when this View is removed from the screen
    function onHide() { }

    function addUseMilitaryFormat() as Void {
        var label = WatchUi.loadResource(Rez.Strings.MilitaryFormatTitle);
        var options = {:enabled=>"On", :disabled=>"Off"};
        var id = "UseMilitaryFormat";
        var enabled = useMilitaryFormat;
        Menu2.addItem(new WatchUi.ToggleMenuItem(label, options, id, enabled, null));
    }

    function addDisplayMonth() as Void {
        var label = WatchUi.loadResource(Rez.Strings.DisplayMonthTitle);
        var options = {:enabled=>"On", :disabled=>"Off"};
        var id = "DisplayMonth";
        var enabled = displayMonth;
        Menu2.addItem(new WatchUi.ToggleMenuItem(label, options, id, enabled, null));
    }
}

class SettingsDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        if (item instanceof WatchUi.ToggleMenuItem) {
			System.println("id: " + item.getId() + ", value: " + item.isEnabled()); 
			Properties.setValue(item.getId() as String, item.isEnabled());
		}

        if (item instanceof WatchUi.MenuItem && item.getId().equals("done")) {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
       
        WatchUi.requestUpdate();
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
