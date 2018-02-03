using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

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
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }


    // Update the view
    function onUpdate(dc) {
        Sys.println("error view: status: " + dataLoader.status);
        Sys.println("error view: data:   " + dataLoader.data);

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_DK_GRAY);
        dc.clear();

        if (dataLoader.status >= 10) {
            var text = "Error:\nunknown";                     // TODO move to String resources
            // it should be ErrorData, else fail
            var data = dataLoader.data;
            if (data.message != null) {
                text = "Error:\n" + data.message.toString();  // TODO move to String resources
            }

            var errorString = new Ui.Text({
                :text  => text,
                :color => Gfx.COLOR_WHITE,
                :font  => Gfx.FONT_SMALL,
                :locX  => Ui.LAYOUT_HALIGN_CENTER,
                :locY  => Ui.LAYOUT_VALIGN_CENTER
            });
            errorString.draw(dc);
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
