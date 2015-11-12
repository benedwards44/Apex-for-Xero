/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  OAuth Utility for logging in to Xero via OAuth 1.0
*               Taken mostly from https://gist.github.com/surjikal/7539745 but converted to support RSA signing, over HMAC  
*               OAuth 1.0a Documentation: http://oauth.net/core/1.0a/#RFC3986
*               Details also take from http://help.interfaceware.com/kb/writing-a-xero-adapter
*
*               This applicatino uses the Private Application integration approach as per the Xero documentation:
*               http://developer.xero.com/documentation/getting-started/private-applications/
**/
public with sharing class XeroOAuthUtility {
	
    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Accepts an HttpRequest, consumer key (supplied by Xero) and private key (generated via openssl with public key loaded in Xero)
    *   @return Return HttpRequest with OAuth parameters set in the header
    **/
    public static HttpRequest signRequest(HttpRequest req, String consumerKey, String privateKey) {

    	// Nonce and Timestamp logic from OAauth documentation: http://oauth.net/core/1.0a/#nonce
    	// None must be unique for all requests with that timestamp. A nonce is a random string, uniquely generated for each request.
        String nonce = String.valueOf(Crypto.getRandomLong());

        // Timestamp = # Seconds since Jan 1 1970 00:00:00 GMT
    	// The timestamp value MUST be a positive integer and MUST be equal or greater than the timestamp used in previous requests.
        String timestamp = String.valueOf(DateTime.now().getTime() / 1000);

        // Create map of OAuth paramaters used for signing
        Map<String,String> parameters = new Map<String,String>();
        parameters.put('oauth_version', '1.0');
        parameters.put('oauth_nonce', nonce);
        parameters.put('oauth_timestamp', timestamp);

        // RSA-SHA1 is the signature method used for the Xero authentication
        parameters.put('oauth_signature_method','RSA-SHA1');
        parameters.put('oauth_consumer_key', consumerKey);

        // As no token is requested, set the token as the consumer key. The Xero API doesn't use tokens, but rather uses 1-legged OAuth to make requests
        parameters.put('oauth_token', consumerKey);

        // Generate signature
        String signature = generateSignature(req, consumerKey, privateKey, parameters);

        // Now take the generated signature add to the headers
        req.setHeader('Authorization', generateHeader(signature, parameters));

        return req;
    }


    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Generate the header used for the authenticated with Xero. This takes the generated signature to build the header for the request
    *   @return Return the OAuth 1.0 header string, which is a concatenation of all the OAuth parameters
    **/
    private static String generateHeader(String signature, Map<String,String> parameters) {

    	// Add OAuth value to the start of the header
        String header = 'OAuth ';

        // Itererate of all paramneters
        for (String key : parameters.keySet()) {

        	// dd each paramaeter to the header string
            header = header + key + '="'+parameters.get(key)+'", ';
        }

        // Add the OAuth signature and return.
        // Note: The signature needs to be URL encoded, as if it includes / and + these should be encoded correctly
        return header + 'oauth_signature="' + EncodingUtil.urlEncode(signature, 'UTF-8') + '"';
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Generate the signature using the consumer secret, private key, the request and parameters
    *   @return Returns a URL encoded RSA-SHA1 formatted signature. (http://oauth.net/core/1.0a/#anchor18)
    **/
    private static String generateSignature(HttpRequest req, String consumerSecret, String privateKey, Map<String,String> parameters) {

    	// Generates a base string to use for encoding.
    	// Eg. GET&https%3A%2F%2Fapi.xero.com%2Fapi.xro%2F2.0%2FInvoices&oauth_consumer_key%3D7YBW ...
        String baseString = createBaseString(req, parameters);

        // Encrypt the string using RSA signature, the baseString as the input and the decoded privatekey
        Blob signatureBlob = Crypto.sign('RSA-SHA1', Blob.valueOf(baseString), EncodingUtil.base64Decode(privateKey));
        
        // Re-Encode back to string and return
		return EncodingUtil.base64Encode(signatureBlob);  
    }


    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Take the current request and parameters to build a base string for encoding
    *   @return Returns the base string used for creating the OAuth signature. 
    *           Eg. GET&https%3A%2F%2Fapi.xero.com%2Fapi.xro%2F2.0%2FInvoices&oauth_consumer_key%3D7YBW ...
    **/
    private static String createBaseString(HttpRequest req, Map<String,String> parameters) {

    	// Take a copy of the passed parameters
        Map<String,String> p = parameters.clone();

        // If a POST request with a body, take parameters and add to the parameter map
        if (req.getMethod().equalsIgnoreCase('post') && req.getBody()!= null && req.getHeader('Content-Type') == 'application/x-www-form-urlencoded') {
            
            // Add all parameters to parameter map
            p.putAll(getUrlParams(req.getBody()));
        }

        // Get the Endpoint from the request 
        String host = req.getEndpoint();

        // Determine the index of the parameters after the endpoint
        Integer n = host.indexOf('?');

        // If parameters exist in the endpoint
        if (n > -1) {

        	// Add all parameters to the map
            p.putAll(getUrlParams(host.substring(n + 1)));

            // Strip parameters from the URL. These are now added
            // to the parameters map
            host = host.substring(0,n);
        }

       	// Convert all converts into a string list. This is because
       	// they needed to be sorted alphabetically as per OAuth standards
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();

        // Add parameters back into string seperated with = and & values
        String s = keys.get(0)+'='+p.get(keys.get(0));
        for (Integer i = 1; i < keys.size(); i++) {

            s = s + '&' + keys.get(i)+'='+p.get(keys.get(i));
        }

        // Return the concatenated string required for OAauth 1.0
        return req.getMethod().toUpperCase()+ '&' + EncodingUtil.urlEncode(host, 'UTF-8') + '&' + EncodingUtil.urlEncode(s, 'UTF-8');
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Method to retrieve a URL parameter from a given value
    *   @return Return a map of URL parameters to the parameter value. Eg. oauth_token (key) => token_value (value)
    **/
    private static Map<String,String> getUrlParams(String value) {

		Map<String,String> res = new Map<String,String>();

		// If no value is passed, return empty map
    	if (value == null || value=='') {

        	return res;
    	}

    	// Iterate over the split parameters based on &
	    for (String s : value.split('&')) {

	        List<String> kv = s.split('=');

	        if (kv.size()>1) {
	            // RFC 5849 section 3.4.1.3.1 and 3.4.1.3.2 specify that parameter names 
	            // and values are decoded then encoded before being sorted and concatenated
	            // Section 3.6 specifies that space must be encoded as %20 and not +
	            String encName = EncodingUtil.urlEncode(EncodingUtil.urlDecode(kv[0], 'UTF-8'), 'UTF-8').replace('+','%20');
	            String encValue = EncodingUtil.urlEncode(EncodingUtil.urlDecode(kv[1], 'UTF-8'), 'UTF-8').replace('+','%20');
	            res.put(encName,encValue);
	        }
	    }
	    return res;
	}

}