using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class AqicnApp extends App.AppBase {

    var dataLoader = new DataLoader();

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        dataLoader.loadData();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        dataLoader.close();
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new AqicnWaitingView(dataLoader) ];
    }

    function onSettingsChanged() {
        dataLoader.loadData();
    }
}