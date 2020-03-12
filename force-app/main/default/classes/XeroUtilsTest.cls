/**
* @author Ben Edwards (ben@edwards.nz)
* @date 3rd February 2020
* @description Test class for XeroUtils
**/
@isTest 
public class XeroUtilsTest {

    @isTest 
    static void testProcess401Error () {

        String errorResponse = 'oauth_problem=token_rejected&oauth_problem_advice=The%20organisation%20for%20this%20access%20token%20is%20not%20active';

        String processedError = XeroUtils.process401Error(errorResponse);

        system.assert(
            processedError.contains(
                'The organisation for this access token is not active'
            ),
            'The error should be decoded and passed into the error message.'
        );
    } 
}