/**
* @author Ben Edwards (ben@edwards.nz)
* @date 3rd February 2020
* @description Generic utily class for Xero methods
**/
public with sharing class XeroUtils {
    
    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Method to take the full JSON response and just return the object portion. Eg. The Contact and Invoice portion only
    *   @return JSON String with only specific object data
    **/
    public static String generateJsonStringForParsing (String jsonBody, String objectName) {

    	// Parse the JSON response
        Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);

        // Re-serialize just the object portion back to JSON
        return JSON.serialize((List<Object>) jsonResponseMap.get(objectName));
    }

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Process 401 responses, which reutrn in a different format that other errors
    **/
    public static String process401Error (String responseBody) {

        // Example response:
        // oauth_problem=token_rejected&oauth_problem_advice=The%20organisation%20for%20this%20access%20token%20is%20not%20active

        Map<String, String> errorsMap = new Map<String, String>();

        // First, split on the & sign to break out each parameter
        for (String keyValuePair :responseBody.split('&')) {

            errorsMap.put(
                keyValuePair.split('=')[0],
                keyValuePair.split('=')[1]
            );
        }

        return errorsMap.get('oauth_problem') + ': ' + EncodingUtil.urlDecode(errorsMap.get('oauth_problem_advice'), 'UTF-8');
    }

}