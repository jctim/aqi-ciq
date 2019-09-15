using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Position as Position;

enum {
    WaitingGeoData      = 0,
    WaitingInternetData = 1,
    DataRetrievedOk     = 10,
    DataRetrievedError  = 11
}

enum {
    Undefined,
    Good,
    Moderate,
    UnhealthyForSensitive,
    Unhealthy,
    VeryUnhealthy,
    Hazardous
}

class OkData {
    var city;
    var aqi;
    var pm25;
    var pm10;
    var level;

    function initialize(city, aqi, pm25, pm10, level) {
        self.city  = city;
        self.aqi   = aqi;
        self.pm25  = pm25;
        self.pm10  = pm10;
        self.level = level;
    }

    function toString() {
        return "okData[city=" + city + ":aqi=" + aqi + ":pm25=" + pm25 + ":pm10=" + pm10 + ":level=" + level + "]";
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

    var useGPS = null;
    var apiToken = null;
    var stationId = null;

    function loadData() {
        resetData();
        if (useGPS) {
            requestGeoPositionAndRequestDataByPosition();
        } else {
            requestHttpDataByStationId();
        }
    }

    function close() {
        Comm.cancelAllRequests();
    }

    private function resetData() {
        data   = null;
        status = -1;

        useGPS   = AppData.readProperty("UseGPS");
        apiToken = AppData.readProperty("ApiKey");
        stationId = AppData.readProperty("StationId");
        if (stationId == null || stationId.length() == 0) {
            stationId = "@0000";
        }
    }

    private function requestGeoPositionAndRequestDataByPosition() {
        // Sys.println("prepare to register geo position event");
        status = WaitingGeoData;

        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onGeoPositionResponse));
        Ui.requestUpdate();
    }

    function onGeoPositionResponse(info) {
        Sys.println("geo received: info=" + info);
        var location = info.position.toDegrees();
        var lat = location[0];
        var lng = location[1];

        requestHttpDataByPosition(lat, lng);
    }

    private function requestHttpDataByPosition(lat, lng) {
        // Sys.println("prepare to send http request");
        status = WaitingInternetData;

        var base  = "https://api.waqi.info";
        var url   = base + "/feed/geo:" + lat + ";" + lng + "/?token=" + apiToken;
        Sys.println("will do request to " + url);

        makeHttpRequest(url);
    }

    private function requestHttpDataByStationId() {
        // Sys.println("prepare to send http request");
        status = WaitingInternetData;

        var base  = "https://api.waqi.info";
        var url   = base + "/feed/" + stationId + "/?token=" + apiToken;
        Sys.println("will do request to " + url);

        makeHttpRequest(url);
    }

    private function makeHttpRequest(url) {
        var options = {
            :method => Comm.HTTP_REQUEST_METHOD_GET,
            :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        Comm.makeWebRequest(url, {}, options, method(:onHttpResponse));

        // Sys.println("request sent");
        Ui.requestUpdate();
    }

    function onHttpResponse(responseCode, data) {
        Sys.println("response received: code=" + responseCode + ", data=" + data);

        if (responseCode == 200
                && data != null && data instanceof Dictionary
                && "ok".equals(data["status"])) {
            self.status = DataRetrievedOk;

            var city  = data["data"]["city"]["name"];
            var aqi   = data["data"]["aqi"];
            var pm25  = data["data"]["iaqi"]["pm25"] != null ? data["data"]["iaqi"]["pm25"]["v"] : "-";
            var pm10  = data["data"]["iaqi"]["pm10"] != null ? data["data"]["iaqi"]["pm10"]["v"] : "-";

            aqi = correctAqi(aqi, pm25, pm10);
            self.data = new OkData(normalize(city), aqi, pm25, pm10, decideLevel(aqi));
        } else if (data != null && data instanceof Dictionary) {
            self.status = DataRetrievedError;
            
            var message = "Error:\ncode=" + responseCode + "\nstatus=" + data["status"] + "\n" + data["data"];
            self.data   = new ErrorData(message);
        } else {
            self.status = DataRetrievedError;
            
            var message = "code=" + responseCode + "\nNo Connection";  // TODO move to String resources???
            self.data   = new ErrorData(message);
        }

        Ui.requestUpdate();
    }

    //! correct aqi if response data doesn't contains valid AQI value
    function correctAqi(aqi, pm25, pm10) {
        if (aqi.toNumber() == null) {
            aqi = pm25;
        }
        if (aqi.toNumber() == null) {
            aqi = pm10;
        }
        return aqi;
    }

    //!
    //!     Undefined,
    //!     Good,
    //!     Moderate,
    //!     UnhealthyForSensitive,
    //!     Unhealthy,
    //!     VeryUnhealthy,
    //!     Hazardous
    //! 
    function decideLevel(aqi) {
        // Sys.println("deciding level by aqi " + aqi);
        var aqiNumber = aqi.toNumber();
        if (aqiNumber == null) {
            return Undefined;
        } else if (aqiNumber <= 50) {
            return Good;
        } else if (aqiNumber <= 100) {
            return Moderate;
        } else if (aqiNumber <= 150) {
            return UnhealthyForSensitive;
        } else if (aqiNumber <= 200) {
            return Unhealthy;
        } else if (aqiNumber <= 300) {
            return VeryUnhealthy;
        } else {
            return Hazardous;
        }
    }

    function normalize(city) {
        // Sys.println("normalizing " + city);
        var idx;
        
        idx = city.find(" - ");
        if (idx != null) {
            city = city.substring(0, idx) + "\n- " + city.substring(idx + 3, city.length());
        }

        idx = city.find(", ");
        if (idx != null) {
            city = city.substring(0, idx) + ",\n" + city.substring(idx + 2, city.length());
        }

        // Sys.println("normalized  " + city);
        return city;
    }
}