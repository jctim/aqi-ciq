using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Position as Position;
using Toybox.Application.Properties as Properties;

class AqicnMainView extends Ui.View {

    var dataLoader;

    function initialize(dataLoader) {
        self.dataLoader = dataLoader;
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
        // 
    }


    // Update the view
    function onUpdate(dc) {
        Sys.println("main view: status: " + dataLoader.status);
        Sys.println("main view: data:   " + dataLoader.data);

        if (dataLoader.status >= 10) {
            var cityView = View.findDrawableById("CityValue");
            var aqiView  = View.findDrawableById("AqiValue");
            var pm25View = View.findDrawableById("Pm25Value");
            var pm10View = View.findDrawableById("Pm10Value");

            // it should be OkData, else fail
            var data = dataLoader.data;
            if (data.city != null) {
                cityView.setText(data.city.toString());
            }
            if (data.aqi != null) {
                aqiView.setText(data.aqi.toString());
            }
            if (data.pm25 != null) {
                pm25View.setText(data.pm25.toString());
            }
            if (data.pm10 != null) {
                pm10View.setText(data.pm10.toString());
            }

            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
        } else {
            Ui.popView(Ui.SLIDE_IMMEDIATE);
        }

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
