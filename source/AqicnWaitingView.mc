using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Position as Position;
using Toybox.Application.Properties as Properties;

class AqicnWaitingView extends Ui.View {

    var dataLoader;

    function initialize(dataLoader) {
        self.dataLoader = dataLoader;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SimpleMessageLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        // 
    }

    // Update the view
    function onUpdate(dc) {
        Sys.println("waiting view: status: " + dataLoader.status);
        
        if (dataLoader.status < 10) {
            var messageView = View.findDrawableById("MessageLabel");

            switch (dataLoader.status) {
                case WaitingGeoData:
                    messageView.setText("Waiting for\ngeo data...");
                    break;
                case WaitingInternetData:
                    messageView.setText("Waiting for\ninternet data...");
                    break;
            }
            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
        } else {
            switch (dataLoader.status) {
                case DataRetrievedError:
                    Ui.pushView(new AqicnErrorView(dataLoader), null, Ui.SLIDE_IMMEDIATE);
                    break;
                case DataRetrievedOk:
                    Ui.pushView(new AqicnMainView(dataLoader), null, Ui.SLIDE_IMMEDIATE);
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
