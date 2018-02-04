using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class AqicnDetailView extends Ui.View {

    var level;
    var textVerticalShift = 0;

    const ONE_LINE_TXT = "a";
    const TWO_LINES_TXT = "a\nb";

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

        var title = "";
        var text = "";
        switch (level) {
            case Good:
                title = Ui.loadResource(Rez.Strings.GoodTitle);
                text = Ui.loadResource(Rez.Strings.GoodText);
                break;
            case Moderate:
                title = Ui.loadResource(Rez.Strings.ModerateTitle);
                text = Ui.loadResource(Rez.Strings.ModerateText);
                break;
            case UnhealthyForSensitive:
                title = Ui.loadResource(Rez.Strings.UnhealthyForSensitiveTitle);
                text = Ui.loadResource(Rez.Strings.UnhealthyForSensitiveText);
                break;
            case Unhealthy:
                title = Ui.loadResource(Rez.Strings.UnhealthyTitle);
                text = Ui.loadResource(Rez.Strings.UnhealthyText);
                break;
            case VeryUnhealthy:
                title = Ui.loadResource(Rez.Strings.VeryUnhealthyTitle);
                text = Ui.loadResource(Rez.Strings.VeryUnhealthyText);
                break;
            case Hazardous:
                title = Ui.loadResource(Rez.Strings.HazardousTitle);
                text = Ui.loadResource(Rez.Strings.HazardousText);
                break;
        }

        var onLineHeigth = dc.getTextDimensions(ONE_LINE_TXT, Gfx.FONT_XTINY)[1];    // 22 on VA3
        var twoLinesHeigth = dc.getTextDimensions(TWO_LINES_TXT, Gfx.FONT_XTINY)[1]; // 47 on VA3
        var titleBlockHeight = twoLinesHeigth + (twoLinesHeigth - onLineHeigth) / 2;
        var titleHeight = dc.getTextDimensions(title, Gfx.FONT_XTINY)[1];

        // description text
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.clear();
        
        new Ui.Text({
            :text  => text,
            :color => Gfx.COLOR_BLACK,
            :font  => Gfx.FONT_XTINY,
            :locX  => Ui.LAYOUT_HALIGN_CENTER,
            :locY  => Ui.LAYOUT_VALIGN_START + titleBlockHeight - (textVerticalShift * onLineHeigth)
        }).draw(dc);


        // title block + title text
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), titleBlockHeight);

        new Ui.Text({
            :text  => title,
            :color => Gfx.COLOR_WHITE,
            :font  => Gfx.FONT_XTINY,
            :locX  => Ui.LAYOUT_HALIGN_CENTER,
            :locY  => Ui.LAYOUT_VALIGN_START + (twoLinesHeigth - titleHeight) / 2
        }).draw(dc);
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

class AqicnDetailViewDelegate extends Ui.BehaviorDelegate {

    var detailView;

    function initialize(detailView) {
        self.detailView = detailView;
        Ui.BehaviorDelegate.initialize();
    }

    function onSelect() {
        Ui.popView(Ui.SLIDE_RIGHT);
    }

    function onNextPage() {
        detailView.textVerticalShift += 1;
        if (detailView.textVerticalShift > 3) {
            detailView.textVerticalShift = 3;
        }
        Ui.requestUpdate();
    }

    function onPreviousPage() {
        detailView.textVerticalShift -= 1;
        if (detailView.textVerticalShift < 0) {
            detailView.textVerticalShift = 0;
        }
        Ui.requestUpdate();
    }
}
