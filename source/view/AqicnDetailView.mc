using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class AqicnDetailView extends Ui.View {

    var level;

    function initialize(level) {
        self.level = level;
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
        Sys.println("detail view: level: " + level);

        dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_WHITE );
        dc.clear();

        var text = "";
        switch (level) {
            case Good:
                text = Ui.loadResource(Rez.Strings.GoodText);
                break;
            case Moderate:
                text = Ui.loadResource(Rez.Strings.ModerateText);
                break;
            case UnhealthyForSensitive:
                text = Ui.loadResource(Rez.Strings.UnhealthyForSensitiveText);
                break;
            case Unhealthy:
                text = Ui.loadResource(Rez.Strings.UnhealthyText);
                break;
            case VeryUnhealthy:
                text = Ui.loadResource(Rez.Strings.VeryUnhealthyText);
                break;
            case Hazardous:
                text = Ui.loadResource(Rez.Strings.HazardousText);
                break;
        }

        var levelText = new Ui.Text({
            :text  => fitText(text, dc),
            :color => Gfx.COLOR_BLACK,
            :font  => Gfx.FONT_XTINY,
            :locX  => Ui.LAYOUT_HALIGN_CENTER,
            :locY  => Ui.LAYOUT_VALIGN_START + 30
        });

        levelText.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    function fitText(text, dc) {
        var textWidth = dc.getTextWidthInPixels(text, Gfx.FONT_XTINY); //Sys.println(textWidth);
        var visibleWidth = dc.getWidth() - 25;                         //Sys.println(visibleWidth);
        var lines = textWidth / visibleWidth + 1;                      //Sys.println(lines);
        var charsCount = text.length();                                //Sys.println(charsCount);
        var step = charsCount / lines;                                 //Sys.println(step);

        var newText = "";
        for (var i = 0; i < lines; i++) {
            var t = text.substring(i * step, (i + 1) * step);
            newText += t;
            newText += "\n";
        }
        newText += text.substring(lines * step, text.length());

        //Sys.println(text);
        //Sys.println(newText);
        return newText;
    }

}

class AqicnDetailViewDelegate extends Ui.InputDelegate {

    function initialize() {
        Ui.InputDelegate.initialize();
    }

    function onKey(key) {
        if (key.getKey() == Ui.KEY_ENTER) {
            showMainView();
        }
    }

    function onTap(evt) {
        if (evt.getType() == Ui.CLICK_TYPE_TAP) {
            showMainView();
        }
    }

    private function showMainView() {
        Ui.popView(Ui.SLIDE_RIGHT);
    }

    /* function onBack() {
        Sys.println("on back");
        //Ui.popView(Ui.SLIDE_RIGHT);
    } */



}
