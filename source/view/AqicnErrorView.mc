import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

class AqicnErrorView extends WatchUi.View {

    var dataLoader;
    var initialView;

    function initialize(dataLoader, initialView) {
        self.dataLoader = dataLoader;
        self.initialView = initialView;
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
        System.println("error view: status: " + dataLoader.status);
        // System.println("error view: data:   " + dataLoader.data);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_DK_GRAY);
        dc.clear();

        if (dataLoader.status >= 10) {
            var text = "Error:\nunknown";                     // TODO move to String resources
            // it should be ErrorData, else fail
            var data = dataLoader.data;
            if (data.message != null) {
                text = "Error:\n" + data.message.toString();  // TODO move to String resources
            }

            var errorString = new WatchUi.Text({
                :text  => text,
                :color => Graphics.COLOR_WHITE,
                :font  => Graphics.FONT_SMALL,
                :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY  => WatchUi.LAYOUT_VALIGN_CENTER
            });
            errorString.draw(dc);
        } else {
            WatchUi.switchToView(initialView, null, WatchUi.SLIDE_IMMEDIATE);
        }

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
