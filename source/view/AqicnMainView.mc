using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class AqicnMainView extends Ui.View {

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
        Sys.println("main view: status: " + dataLoader.status);
        // Sys.println("main view: data:   " + dataLoader.data);

        if (dataLoader.status >= 10) {
            var bgView   = View.findDrawableById("MainBackground");
            
            var aqiLabel = View.findDrawableById("AqiLabel");
            var pm25Label = View.findDrawableById("Pm25Label");
            var pm10Label = View.findDrawableById("Pm10Label");

            var cityView = View.findDrawableById("CityValue");
            var aqiView  = View.findDrawableById("AqiValue");
            var pm25View = View.findDrawableById("Pm25Value");
            var pm10View = View.findDrawableById("Pm10Value");

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

            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
        } else {
            Ui.switchToView(initialView, null, Ui.SLIDE_IMMEDIATE);
        }
    }

    private function decideFgColor(level) {
        // Sys.println("deciding FG color by level " + level);
        switch (level) {
            case Undefined: return Gfx.COLOR_BLACK;
            case Good: return Gfx.COLOR_WHITE;
            case Moderate: return Gfx.COLOR_WHITE;
            case UnhealthyForSensitive: return Gfx.COLOR_WHITE;
            case Unhealthy: return Gfx.COLOR_WHITE;
            case VeryUnhealthy: return Gfx.COLOR_WHITE;
            case Hazardous: return Gfx.COLOR_WHITE;
        }
    }

    private function decideBgColor(level) {
        // Sys.println("deciding BG color by level " + level);
        switch (level) {
            case Undefined: return Gfx.COLOR_WHITE;
            case Good: return Gfx.COLOR_DK_GREEN;
            case Moderate: return Gfx.COLOR_YELLOW;
            case UnhealthyForSensitive: return Gfx.COLOR_ORANGE;
            case Unhealthy: return Gfx.COLOR_RED;
            case VeryUnhealthy: return Gfx.COLOR_PURPLE;
            case Hazardous: return Gfx.COLOR_BLACK;
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}

class AqicnMainViewDelegate extends Ui.BehaviorDelegate {

    var data;

    function initialize(data) {
        self.data = data;
        Ui.BehaviorDelegate.initialize();
    }

    function onSelect() {
        var detailView = new AqicnDetailView(data.level);
        var detailViewDelegate = new AqicnDetailViewDelegate(detailView);
        Ui.pushView(detailView, detailViewDelegate, Ui.SLIDE_LEFT);
    }
}
