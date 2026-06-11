public with sharing class OpenCageGeocoderService {
    
    public static void reverseGeoCoding(String accountId){ // argument
        Account accRecord = [SELECT Id, Location__Latitude__s, Location__Longitude__s 
                            FROM Account 
                            WHERE Id =: accountId 
                            AND Location__Latitude__s != null
                            AND Location__Longitude__s != null
                            LIMIT 1];

        String queryParams = accRecord.Location__Latitude__s+','+accRecord.Location__Longitude__s;

        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndPoint(System.Label.OPENCAGE_API_URL+'?key='
            +System.Label.OPENCAGE_API_KEY+'&q='+queryParams+'&pretty=1');

        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        httpReq.setMethod('GET');

        Http htt = new Http();
        try {
            HttpResponse httpRes = htt.send(httpReq);

            String responseBody = httpRes.getBody();
            Integer statusCode  = httpRes.getStatusCode();

            if(statusCode == 200){
                OpenCageReverseResponseWrapper wrapper = 
                (OpenCageReverseResponseWrapper)System.JSON.deserialize(
                    responseBody, 
                    OpenCageReverseResponseWrapper.class
                );

                if(wrapper?.results?.size() > 0){
                    OpenCageReverseResponseWrapper.results rslt = wrapper.results.get(0);

                    accRecord.BillingStreet = rslt?.components?.road;
                    accRecord.BillingCity = rslt?.components?.city;
                    accRecord.BillingState = rslt?.components?.state;
                    accRecord.BillingPostalCode = rslt?.components?.postcode;
                    accRecord.BillingCountry = rslt?.components?.country;

                    accRecord.ShippingStreet = rslt?.components?.road;
                    accRecord.ShippingCity = rslt?.components?.city;
                    accRecord.ShippingState = rslt?.components?.state;
                    accRecord.ShippingPostalCode = rslt?.components?.postcode;
                    accRecord.ShippingCountry = rslt?.components?.country;

                    update accRecord;
                }
            }else{
                // error handling
            }
            
        }catch(System.CalloutException calloutEx){
            System.debug('System.CalloutException .... '+ calloutEx.getStackTraceString());
        }catch(System.Exception ex){
            System.debug('Exception Executed ... '+ ex.getStackTraceString());
        }
    }
}