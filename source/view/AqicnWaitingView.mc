import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

class AqicnWaitingView extends WatchUi.View {

    var dataLoader;

    function initialize(dataLoader) {
        self.dataLoader = dataLoader;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        System.println("waiting view: status: " + dataLoader.status);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_DK_GRAY);
        dc.clear();

        if (dataLoader.status < 10) {
            var text = "Waiting...";                        // TODO move to String resources
            switch (dataLoader.status) {
                case WaitingGeoData:
                    text = "Waiting for\ngeo location...";  // TODO move to String resources
                    break;
                case WaitingInternetData:
                    text = "Waiting for\nInternet data..."; // TODO move to String resources
                    break;
            }
            var waitingString = new WatchUi.Text({
                :text  => text,
                :color => Graphics.COLOR_WHITE,
                :font  => Graphics.FONT_SMALL,
                :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY  => WatchUi.LAYOUT_VALIGN_CENTER
            });
            waitingString.draw(dc);
        } else {
            switch (dataLoader.status) {
                case DataRetrievedError:
                    WatchUi.switchToView(new AqicnErrorView(dataLoader, self), null, WatchUi.SLIDE_IMMEDIATE);
                    break;
                case DataRetrievedOk:
                    WatchUi.switchToView(new AqicnMainView(dataLoader, self), new AqicnMainViewDelegate(dataLoader.data), WatchUi.SLIDE_IMMEDIATE);
                    break;
            }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
