import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

class MainBackgroundView extends WatchUi.Drawable {

    var bgColor = Graphics.COLOR_BLACK;

    function initialize(params) {
        Drawable.initialize(params);
    }

    function setBgColor(bgColor) {
        self.bgColor = bgColor;
    }

    function draw(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, bgColor);
        dc.clear();
    }

}
