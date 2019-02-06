/**
* @author       Gordie Noye (gordie.noye@gmail.com)
* @description  Wrapper class to hold details for a Xero XeroTrackingOption details
**/
public class XeroTrackingOption {

    public String TrackingOptionID {get; set;}     // The Xero identifier for a tracking option e.g. ae777a87-5ef3-4fa0-a4f0-d10e1f13073a
    public String Name {get; set;}      // The name of the tracking option e.g. Marketing, East (max length = 100)
    public string Status {get; set;}        // The status of a tracking option

}