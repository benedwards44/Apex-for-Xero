/**
* @author       Gordie Noye (gordie.noye@gmail.com)
* @description  Wrapper class to hold details for a Xero TrackingCategory details
**/
public class XeroTrackingCategory {

    public String TrackingCategoryID {get; set;}    // The Xero identifier for a tracking category e.g. 297c2dc5-cc47-4afd-8ec8-74990b8761e9
    public String Name {get; set;}    // The name of the tracking category e.g. Department, Region (max length = 100)
    public String Status {get; set;}    // The status of a tracking category
    public XeroTrackingOption Options[] {get; set;}   // Array: See Tracking Options

    //The following elements are optional for GET TrackingCategories

    public String TrackingCategoryID {get; set;}        // Filter by a tracking category e.g. 297c2dc5-cc47-4afd-8ec8-74990b8761e9
    public String Where {get; set;}     // Filter by an any element ( see Filters )
    public String order {get; set;}     // Order by any element returned ( see Order By )
    public string includeArchived {get; set;}       // e.g. includeArchived=true - Categories and options with a status of ARCHIVED will be included in the response
}