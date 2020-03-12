/**
* @author Ben Edwards (ben@edwards.nz)
* @date 3rd February 2020
* @description Test class for XeroValidationError
**/
@isTest
public class XeroValidationErrorTest {
    
    @isTest 
    static void testProcessValidationErrors () {

        XeroValidationError xeroError = new XeroValidationError();
        xeroError.Message = 'Test Error';

        XeroValidationError.processValidationErrors(new List<XeroValidationError>{xeroError});
    }
}