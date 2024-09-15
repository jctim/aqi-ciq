import Toybox.Application;
import Toybox.System;

//! App Data is an abstraction to retrieve settings, properties and storage values
//! for devices with CIQ version before and after 2.4
module AppData {

    function readProperty(propertyName) {
        if (Application has :Properties) {
            try {
                return Application.Properties.getValue(propertyName);
            } catch (ex instanceof Application.Properties.InvalidKeyException) {
                // different behaviour on device and simulator:
                // previously stored empty value (OtpDataProvider:89) for given property works correctly on a simulator
                // but deletes the property on a device, thus the exception is thrown
                return null;
            }
        } else {
            return Application.getApp().getProperty(propertyName);
        }
    }

    function saveProperty(propertyName, propertyValue) {
        if (Application has :Properties) {
            try {
                Application.Properties.setValue(propertyName, propertyValue);
                return true;
            } catch (ex instanceof Application.Properties.InvalidKeyException) {
                // if the exception is throw then properties don't have that key
                // return false as indicator the property was not saved
                return false;
            }
        } else {
            Application.getApp().setProperty(propertyName, propertyValue);
            return true;
        }
    }
}