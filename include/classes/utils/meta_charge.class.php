<?
/**
 * Payment class for MetaCharge payment gateway
 * 
 * @link http://www.metacharge.com/
 * @author Rudenko S.
 */
class MetaCharge
{
    var $sPostUrl  = 'https://secure.metacharge.com/mcpe/purser';        
    var $aPayFields = array(
        'intTestMode'=> 0 ,  // If included, indicates a test purchase. A VISA card with card number
                             // 1234123412341234 should be used on the payment page. Values:
                             // 0=equivalent to field omitted (payment is live), 1=all payments are
                             // successful, 2=all payments fail. Banks are not involved in test payments.

        'intInstID'  => '',  // The unique identifier for the MCPE installation that will process this payment.
        
        'strCartID'  => '',  // Your own unique identifier for this purchase, to identify the purchase at your end.                
        
        'strDesc'    => '',  // Descriptive text for this purchase.
        
        'fltAmount'  => '',  // A decimal value representing the transaction amount in the currency
                             // specified in the strCurrency field, using a point (.) as the separator.
                             // Include no other separators, or non-numeric characters.
                             
        'strCurrency'=> 'USD',  // The 3-letter ISO code for the currency in which this payment is to be made.                     
        'strEmail'   => ''
    );
        
    /** 
     * Constructor
     */
    function MetaCharge($iMode)
    {
        $this->aFields['intTestMode'] = $iMode;
    }
    
    
}    
?>