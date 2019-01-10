[<img src="http://developer.garmin.com/img/connect-iq/brand/available-badge.svg" alt="Connect IQ" height="88"/>](https://apps.garmin.com/en-US/apps/7bb1bc3d-0f5d-4a38-98ac-cf55d35a6e2b)

# aqi-ciq

**Air Quality Index widget for Garmin Connect IQ** - the widget aimed to display AQI (Air Quality Index) for current geo position or desired city station right on a Garmin wearable device. 

Basically the widget is a simple client of the web service [http://aqicn.org](http://aqicn.org). Now it can provide: 

* AQI - overall air quality index
* PM2.5 value (Fine particles, are 2.5 micrometers in diameter or smaller, and can only be seen with an electron microscope)
* PM10 value (Coarse dust particlesare 2.5 to 10 micrometers in diameter)

Before using the widget you should obtain an API Token which is needed to make requests to the API of [http://aqicn.org](http://aqicn.org) and enter it to the Settings of this widget 
via Garmin Connect Mobile (iOS or Android app) or via Garmin Express (desktop app). 

The can be requested via simple form on the page [http://aqicn.org/data-platform/token/#/](http://aqicn.org/data-platform/token/#/
).

Also in Settings you can choose how do want to obtain AQI - via geo position or directly from desired station, if you now its id.

### Existing Features

- Shows AQI, PM2.5, PM10 
- Shows description of **current** AQI (by tapping touch device or pressing START button)

### TODO Features

- Configure which else data to provide via Settings (*e.g.* O3, NO2, CO etc.) 
- Support Garmin watches from square family

# Links

- [Connect IQ Store](https://apps.garmin.com/en-US/apps/7bb1bc3d-0f5d-4a38-98ac-cf55d35a6e2b)
- [Air Quality Index API doc](http://aqicn.org/json-api/doc/)

# License

The source code is released under the [MIT license](https://opensource.org/licenses/MIT)
