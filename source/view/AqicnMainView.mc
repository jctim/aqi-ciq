import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

class AqicnMainView extends WatchUi.View {

    var dataLoader;
    var initialView;

    function initialize(dataLoader, initialView) {
        self.dataLoader = dataLoader;
        self.initialView = initialView;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }


    // Update the view
    function onUpdate(dc) {
        System.println("main view: status: " + dataLoader.status);
        // System.println("main view: data:   " + dataLoader.data);

        if (dataLoader.status >= 10) {
            var bgView   = View.findDrawableById("MainBackground") as MainBackgroundView;
            
            var aqiLabel  = View.findDrawableById("AqiLabel") as Text;
            var pm25Label = View.findDrawableById("Pm25Label") as Text;
            var pm10Label = View.findDrawableById("Pm10Label") as Text;

            var cityView = View.findDrawableById("CityValue") as Text;
            var aqiView  = View.findDrawableById("AqiValue") as Text;
            var pm25View = View.findDrawableById("Pm25Value") as Text;
            var pm10View = View.findDrawableById("Pm10Value") as Text;

            // it should be OkData, else fail
            var data = dataLoader.data;

            var fgColor = decideFgColor(data.level);
            var bgColor = decideBgColor(data.level); 

            bgView.setBgColor(bgColor); 
            aqiLabel.setColor(fgColor);
            pm25Label.setColor(fgColor);
            pm10Label.setColor(fgColor);

            if (data.city != null) {
                cityView.setColor(fgColor);
                cityView.setText(data.city.toString());
            }
            if (data.aqi != null) {
                aqiView.setColor(fgColor);
                aqiView.setText(data.aqi.toString());
            }
            if (data.pm25 != null) {
                pm25View.setColor(fgColor);
                pm25View.setText(data.pm25.toString());
            }
            if (data.pm10 != null) {
                pm10View.setColor(fgColor);
                pm10View.setText(data.pm10.toString());
            }
            pm10View.setText("17");

            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
        } else {
            WatchUi.switchToView(initialView, null, WatchUi.SLIDE_IMMEDIATE);
        }
    }

    private function decideFgColor(level) as ColorValue {
        // System.println("deciding FG color by level " + level);
        switch (level) {
            case Undefined: return Graphics.COLOR_BLACK;
            case Good: return Graphics.COLOR_WHITE;
            case Moderate: return Graphics.COLOR_WHITE;
            case UnhealthyForSensitive: return Graphics.COLOR_WHITE;
            case Unhealthy: return Graphics.COLOR_WHITE;
            case VeryUnhealthy: return Graphics.COLOR_WHITE;
            case Hazardous: return Graphics.COLOR_WHITE;
            default: return Graphics.COLOR_WHITE;
        }
    }

    private function decideBgColor(level) as ColorValue {
        // System.println("deciding BG color by level " + level);
        switch (level) {
            case Undefined: return Graphics.COLOR_WHITE;
            case Good: return Graphics.COLOR_DK_GREEN;
            case Moderate: return Graphics.COLOR_YELLOW;
            case UnhealthyForSensitive: return Graphics.COLOR_ORANGE;
            case Unhealthy: return Graphics.COLOR_RED;
            case VeryUnhealthy: return Graphics.COLOR_PURPLE;
            case Hazardous: return Graphics.COLOR_BLACK;
            default: return Graphics.COLOR_WHITE;
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}

class AqicnMainViewDelegate extends WatchUi.BehaviorDelegate {

    var data;

    function initialize(data) {
        self.data = data;
        WatchUi.BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        var detailView = new AqicnDetailView(data.level);
        var detailViewDelegate = new AqicnDetailViewDelegate(detailView);
        return WatchUi.pushView(detailView, detailViewDelegate, WatchUi.SLIDE_LEFT);
    }
}
