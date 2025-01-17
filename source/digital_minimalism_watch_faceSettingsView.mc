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
        addToggleItem("DisplayTemperature", Rez.Strings.DisplayTemperatureTitle);

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
    function onUpdate(dc as Dc) { }

    // onHide() is called when this View is removed from the screen
    function onHide() { }

    function addToggleItem(id as String, resource as Symbol) as Void {
        var label = WatchUi.loadResource(resource);
        var options = {:enabled=>"On", :disabled=>"Off"};
        var property = Properties.getValue(id);
        Menu2.addItem(new WatchUi.ToggleMenuItem(label, options, id, property, null));
    }

    function addSubMenuItem(id as String, resource as String, subLabelSuffix as String) as Void {
        // var label = WatchUi.loadResource(resource);
        var property = Properties.getValue(id) as String;

        Menu2.addItem(new WatchUi.MenuItem(resource, property + subLabelSuffix, id, null));
    }
}

class SettingsDelegate extends WatchUi.Menu2InputDelegate {
    var menu;
    function initialize(settingsView as WatchUi.Menu2) {
        Menu2InputDelegate.initialize();
        menu = settingsView;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId() as String;
		var sublabel = item.getSubLabel();

        if (item instanceof WatchUi.ToggleMenuItem) {
            var isEnabled = item.isEnabled();
            setProperty(id, isEnabled);

            if (isEnabled) {
                var otherItemValue = false;
                if (id.equals("DisplayHeartRate")) {
                    var otherItemId = "DisplayTemperature";
                    setProperty(otherItemId, otherItemValue);
                    setToggleItemEnabled(otherItemId, otherItemValue);
                }
                if (id.equals("DisplayTemperature")) {
                    var otherItemId = "DisplayHeartRate";
                    setProperty(otherItemId, otherItemValue);
                    setToggleItemEnabled(otherItemId, otherItemValue);
                }
            }
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

    private function setProperty(id as String, value) as Void{
        System.println("id: " + id + ", value: " + value);
        Properties.setValue(id, value);
    }

    private function setToggleItemEnabled(id as String, enabled as Boolean) as Void{
        var otherItemIndex = menu.findItemById(id) as Number;
        if (otherItemIndex != -1) {
            var otherItem = menu.getItem(otherItemIndex) as WatchUi.ToggleMenuItem;
            otherItem.setEnabled(enabled);
        }
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

    function initialize(p as WatchUi.MenuItem) {
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