/**
* @author Ben Edwards (ben@edwards.nz)
* @date 3rd February 2020
* @description Handles the physical callout to the Xero API
**/
public with sharing class XeroCalloutService {

        
    /**
    * 	@author Ben Edwards (ben@edwards.nz)
    *	@description Execute the physical callout and return the response
    * 	@return Returns the HttpResponse from the Xero API
    **/
    public static HttpResponse executeCallout (String method, String resourceName) {
        return executeCallout(method, resourceName, null, null);
    }

    public static HttpResponse executeCallout (String method, String resourceName, String requestBody) {
        return executeCallout(method, resourceName, requestBody, null);
    }

    public static HttpResponse executeCallout (String method, String resourceName, String requestBody, Map<String, String> headers) {

        // Instantiate a new request
        HttpRequest request = new HttpRequest();

        // Set request parameters
        request.setMethod(method);

        // Set the endpoint using the named credential
        request.setEndpoint(
            'callout:Xero/' + 
            (resourceName.equalsIgnoreCase('connections') ? 'connections': 'api.xro/2.0/' + resourceName)
        );
        
        // Accept a JSON response from the call
        request.setHeader('Accept', 'application/json');

        // Set the Xero Tenant ID
        request.setHeader('xero-tenant-id', Label.Xero_Tenant_Id);

        // Set max timeout
        request.setTimeout(120000);

        // If the callout includes a body (POST and PUT requests)
        if (String.isNotBlank(requestBody)) {

            // Set the body to the callout
            request.setBody(requestBody);

            // Set the content to XML
            request.setHeader('Content-Type', 'application/json');
        }

        // If we have headers passed into the method, add them to the request
        if (headers != null && !headers.isEmpty()) {
            for (String headerKey :headers.keySet()) {
                request.setHeader(headerKey, headers.get(headerKey));
            }
        }

        system.debug('### Xero Callout Endpoint: ' + request.getEndpoint());
        system.debug('### Xero Callout Method: ' + request.getMethod());
        system.debug('### Xero Callout Body: ' + request.getBody());

        // Debug headers
        if (headers != null && !headers.isEmpty()) {
            for (String headerKey :headers.keySet()) {
                system.debug('### Xero Callout Header: ' + headerKey + ' => ' + headers.get(headerKey));
            }
        }

        // Execute the callout
        HttpResponse response = new Http().send(request);

        system.debug('### Xero Response Status: ' + response.getStatusCode() + ': ' + response.getStatus());
        system.debug('### Xero Response Body: ' + response.getBody());

        // Execute callout and return
        return response;
    }  

}