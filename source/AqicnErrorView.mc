using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Position as Position;
using Toybox.Application.Properties as Properties;

class AqicnErrorView extends Ui.View {

    var dataLoader;
    var initialView;

    function initialize(dataLoader, initialView) {
        self.dataLoader = dataLoader;
        self.initialView = initialView;
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
        Sys.println("error view: status: " + dataLoader.status);
        Sys.println("error view: data:   " + dataLoader.data);

        if (dataLoader.status >= 10) {
            var messageView = View.findDrawableById("MessageLabel");

            // it should be ErrorData, else fail
            var data = dataLoader.data;
            if (data.message != null) {
                messageView.setText(data.message.toString());
            }

            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
        } else {
            Ui.switchToView(initialView, null, Ui.SLIDE_IMMEDIATE);
        }

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
