/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Handles the physical callout to the Xero API
**/
public with sharing class XeroCalloutUtility {

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Query the custom object for the Xero Account Settings
	* 	@return Returns a single Xero_Setting__c record
	**/
	public static Xero_Setting__c xeroSettings {

		get {

			if (xeroSettings == null) {
				
				try {

					// Query for Xero settings
					xeroSettings = [SELECT Consumer_Key__c, Consumer_Secret__c, Endpoint__c FROM Xero_Setting__c];
				}
				catch (Exception ex) {

					// If no setting found, return empty settings
					xeroSettings = new Xero_Setting__c();
				}
			}
			return xeroSettings;
		}
		set;
	}
	
	
	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Execute the physical callout and return the response
	* 	@return Returns the HttpResponse from the Xero API
	**/
	public static HttpResponse executeCallout (String method, String resourceName, String requestBody) {

		// Instantiate a new request
		HttpRequest request = new HttpRequest();

		// Set request parameters
		request.setMethod(method);
		request.setEndpoint(xeroSettings.Endpoint__c + resourceName);
		request.setHeader('Accept', 'application/json');

		// If the callout includes a body (POST and PUT requests)
		if (String.isNotBlank(requestBody)) {

			request.setBody(requestBody);
		}

		// Sign the request based on OAuth 1.0a
		request = XeroOAuthUtility.signRequest(request, xeroSettings.Consumer_Key__c);

		// Execute callout and return
		return new Http().send(request);
	}

}