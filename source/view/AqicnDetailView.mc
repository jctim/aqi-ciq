import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

class AqicnDetailView extends WatchUi.View {

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
        // System.println("detail view: level: " + level);

        var title = "";
        var text = "";
        switch (level) {
            case Undefined:
                title = WatchUi.loadResource(Rez.Strings.UndefinedTitle);
                text = WatchUi.loadResource(Rez.Strings.UndefinedText);
                break;
            case Good:
                title = WatchUi.loadResource(Rez.Strings.GoodTitle);
                text = WatchUi.loadResource(Rez.Strings.GoodText);
                break;
            case Moderate:
                title = WatchUi.loadResource(Rez.Strings.ModerateTitle);
                text = WatchUi.loadResource(Rez.Strings.ModerateText);
                break;
            case UnhealthyForSensitive:
                title = WatchUi.loadResource(Rez.Strings.UnhealthyForSensitiveTitle);
                text = WatchUi.loadResource(Rez.Strings.UnhealthyForSensitiveText);
                break;
            case Unhealthy:
                title = WatchUi.loadResource(Rez.Strings.UnhealthyTitle);
                text = WatchUi.loadResource(Rez.Strings.UnhealthyText);
                break;
            case VeryUnhealthy:
                title = WatchUi.loadResource(Rez.Strings.VeryUnhealthyTitle);
                text = WatchUi.loadResource(Rez.Strings.VeryUnhealthyText);
                break;
            case Hazardous:
                title = WatchUi.loadResource(Rez.Strings.HazardousTitle);
                text = WatchUi.loadResource(Rez.Strings.HazardousText);
                break;
        }

        var onLineHeigth = dc.getTextDimensions(ONE_LINE_TXT, Graphics.FONT_XTINY)[1];    // 22 on VA3
        var twoLinesHeigth = dc.getTextDimensions(TWO_LINES_TXT, Graphics.FONT_XTINY)[1]; // 47 on VA3
        var titleBlockHeight = twoLinesHeigth + (twoLinesHeigth - onLineHeigth) / 2;
        var titleHeight = dc.getTextDimensions(title, Graphics.FONT_XTINY)[1];

        // description text
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        
        new WatchUi.Text({
            :text  => text,
            :color => Graphics.COLOR_BLACK,
            :font  => Graphics.FONT_XTINY,
            :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY  => WatchUi.LAYOUT_VALIGN_START + titleBlockHeight - (textVerticalShift * onLineHeigth)
        }).draw(dc);


        // title block + title text
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), titleBlockHeight);

        new WatchUi.Text({
            :text  => title,
            :color => Graphics.COLOR_WHITE,
            :font  => Graphics.FONT_XTINY,
            :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY  => WatchUi.LAYOUT_VALIGN_START + (twoLinesHeigth - titleHeight) / 2
        }).draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
}

class AqicnDetailViewDelegate extends WatchUi.BehaviorDelegate {

    const MAX_SCROLL_LINES = 4;
    
    var detailView;

    function initialize(detailView) {
        self.detailView = detailView;
        WatchUi.BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onNextPage() as Boolean {
        detailView.textVerticalShift += 1;
        if (detailView.textVerticalShift > MAX_SCROLL_LINES) {
            detailView.textVerticalShift = MAX_SCROLL_LINES;
        }
        WatchUi.requestUpdate();
        return true;
    }

    function onPreviousPage() as Boolean {
        detailView.textVerticalShift -= 1;
        if (detailView.textVerticalShift < 0) {
            detailView.textVerticalShift = 0;
        }
        WatchUi.requestUpdate();
        return true;
    }
}
