using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class AqicnWaitingView extends Ui.View {

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
        Sys.println("waiting view: status: " + dataLoader.status);

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_DK_GRAY);
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
            var waitingString = new Ui.Text({
                :text  => text,
                :color => Gfx.COLOR_WHITE,
                :font  => Gfx.FONT_SMALL,
                :locX  => Ui.LAYOUT_HALIGN_CENTER,
                :locY  => Ui.LAYOUT_VALIGN_CENTER
            });
            waitingString.draw(dc);
        } else {
            switch (dataLoader.status) {
                case DataRetrievedError:
                    Ui.switchToView(new AqicnErrorView(dataLoader, self), null, Ui.SLIDE_IMMEDIATE);
                    break;
                case DataRetrievedOk:
                    Ui.switchToView(new AqicnMainView(dataLoader, self), new AqicnMainViewDelegate(dataLoader.data), Ui.SLIDE_IMMEDIATE);
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
