import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Application.Properties;

class SettingsView extends WatchUi.Menu2 {
    function initialize() {
        View.initialize();
        Menu2.initialize({:title=>"Settings"});

        // Time & Date
        addToggleItem("UseMilitaryFormat", Rez.Strings.MilitaryFormatTitle);
        addToggleItem("DisplayDate", Rez.Strings.DisplayDateTitle);
        addToggleItem("DisplayMonth", Rez.Strings.DisplayMonthTitle);

        // Field 1
        addToggleItem("DisplayHeartRate", Rez.Strings.DisplayHeartRateTitle);

        // Field 2
        addToggleItem("DisplaySteps", Rez.Strings.DisplayStepsTitle);

        // Field 3
        addSubMenuItem("BatteryThreshold", "Battery Threshold", "%");

        // Misc
        addToggleItem("DisplayStepsProgress", Rez.Strings.DisplayStepsProgressTitle);
        // TODO: Add colors

        Menu2.addItem(new WatchUi.MenuItem("Done", null, "done", null));
    }

    // onShow() is called when this View is brought to the foreground
    function onShow() { }

    // onUpdate() is called periodically to update the View
    function onUpdate(dc) { }

    // onHide() is called when this View is removed from the screen
    function onHide() { }

    function addToggleItem(id, resource) as Void {
        var label = WatchUi.loadResource(resource);
        var options = {:enabled=>"On", :disabled=>"Off"};
        var property = Properties.getValue(id);
        Menu2.addItem(new WatchUi.ToggleMenuItem(label, options, id, property, null));
    }

    function addSubMenuItem(id, resource, subLabelSuffix) as Void {
        // var label = WatchUi.loadResource(resource);
        var property = Properties.getValue(id) as String;

        Menu2.addItem(new WatchUi.MenuItem(resource, property + subLabelSuffix, id, null));
    }
}

class SettingsDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
		var sublabel = item.getSubLabel();

        if (item instanceof WatchUi.ToggleMenuItem) {
            var isEnabled = item.isEnabled();
			System.println("id: " + id + ", value: " + isEnabled);
			Properties.setValue(id as String, isEnabled);
		}

        if (item instanceof WatchUi.MenuItem) {
            switch(id) {
                case "done":
                    WatchUi.popView(WatchUi.SLIDE_DOWN);
                    break;
                case "BatteryThreshold":
                    pushSubMenu(BatteryThresholdSubMenuDelegate, item);
                    break;
            }

        }

        WatchUi.requestUpdate();
    }

    function pushSubMenu(delegate, parentItem as WatchUi.MenuItem) as Void {
        WatchUi.pushView(delegate.subMenu(), new delegate(parentItem), WatchUi.SLIDE_LEFT);
    }

    function onBack() {
	    WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

class BatteryThresholdSubMenuDelegate extends WatchUi.Menu2InputDelegate {
    var parentMenuItem;

    static function subMenu() as Menu2 {
        var subMenu = new WatchUi.Menu2({:title => "Battery Threshold"});

        var items = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
        for( var i = 0; i < items.size(); i++ ) {
            subMenu.addItem(new WatchUi.MenuItem((items[i] as String) + "%", null, items[i], null));
        }

        return subMenu;
    }

    function initialize(p) {
        Menu2InputDelegate.initialize();
        parentMenuItem = p;
    }

    function onSelect(subMenuItem as WatchUi.MenuItem) as Void {
        var parentId = parentMenuItem.getId();
        var id = subMenuItem.getId();
        var label = subMenuItem.getLabel();

        System.println("id: " + parentId + ", value: " + id);
        Properties.setValue(parentId as String, id);

		parentMenuItem.setSubLabel(label);
		WatchUi.popView(WatchUi.SLIDE_RIGHT);
	}
}