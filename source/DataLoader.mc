using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Position as Position;
using Toybox.Application.Properties as Properties;

enum {
    WaitingGeoData      = 0,
    WaitingInternetData = 1,
    DataRetrievedOk     = 10,
    DataRetrievedError  = 11
}

class OkData {
    var city;
    var aqi;
    var pm25;
    var pm10;

    function initialize(city, aqi, pm25, pm10) {
        self.city = city;
        self.aqi  = aqi;
        self.pm25 = pm25;
        self.pm10 = pm10;
    }

    function toString() {
        return "okData[city=" + city + ":aqi=" + aqi + ":pm25=" + pm25 + ":pm10=" + pm10 + "]";
    }
}

class ErrorData {
    var message;

    function initialize(message) {
        self.message = message;
    }

    function toString() {
        return "errorData[message=" + message + "]";
    }
}

class DataLoader {
    var data   = null;
    var status = -1;

    function loadData() {
        resetData();
        requestGeoPosition();
    }

    private function resetData() {
        data   = null;
        status = -1;
    }

    private function requestGeoPosition() {
        Sys.println("prepare to register geo position event");
        status = WaitingGeoData;

        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onGeoPositionResponse));
        Ui.requestUpdate();
    }

    private function onGeoPositionResponse(info) {
        Sys.println("geo received: info=" + info);
        var location = info.position.toDegrees();
        var lat = location[0];
        var lng = location[1];

        requestHttpData(lat, lng);
    }

    private function requestHttpData(lat, lng) {
        Sys.println("prepare to send http request");
        status = WaitingInternetData;

        var token = Properties.getValue("ApiKey");
        var base  = "https://api.waqi.info";
        var url   = base + "/feed/geo:" + lat + ";" + lng + "/?token=" + token;
        Sys.println("will do request to " + url);

        var options = {
            :method => Comm.HTTP_REQUEST_METHOD_GET,
            :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        Comm.makeWebRequest(url, {}, options, method(:onHttpDataResponse));

        Sys.println("request sent");
        Ui.requestUpdate();

    }

    private function onHttpDataResponse(responseCode, data) {
        Sys.println("response received: code=" + responseCode + ", data=" + data);

        if (responseCode == 200
                && "ok".equals(data["status"])
                && data["data"] != null) {

            self.status = DataRetrievedOk;

            var city  = data["data"]["city"]["name"];
            var aqi   = data["data"]["aqi"];
            var pm25  = data["data"]["iaqi"]["pm25"] != null ? data["data"]["iaqi"]["pm25"]["v"] : "-";
            var pm10  = data["data"]["iaqi"]["pm10"] != null ? data["data"]["iaqi"]["pm10"]["v"] : "-";
            self.data = new OkData(normalize(city), aqi, pm25, pm10);
        } else {
            self.status = DataRetrievedError;
            
            var message = "Error:\ncode=" + responseCode + "\nstatus=" + data["status"] + "\n" + data["data"];
            self.data   = new ErrorData(message);
        }

        Ui.requestUpdate();
    }

    function normalize(city) {
        Sys.println("normalizing " + city);
        var idx;
        
        idx = city.find(" - ");
        if (idx != null) {
            city = city.substring(0, idx) + "\n- " + city.substring(idx + 3, city.length());
        }

        idx = city.find(", ");
        if (idx != null) {
            city = city.substring(0, idx) + ",\n" + city.substring(idx + 2, city.length());
        }

        Sys.println("normalized  " + city);
        return city;
    }
}