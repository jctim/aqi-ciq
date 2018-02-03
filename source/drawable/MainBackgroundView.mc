using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class MainBackgroundView extends Ui.Drawable {

    var bgColor = Gfx.COLOR_BLACK;

    function initialize(params) {
        Drawable.initialize(params);
    }

    function setBgColor(bgColor) {
        self.bgColor = bgColor;
    }

    function draw(dc) {
        dc.setColor(Gfx.COLOR_TRANSPARENT, bgColor);
        dc.clear();
    }

}
