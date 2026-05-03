public with sharing class AuthorizeYourSelf {
    
    public PageReference getAuthCode() {
  
        Salesforce_Config__mdt config = Salesforce_Config__mdt.getInstance('SalesforceToken');
        if(config == null) return null;

        // Prepare the Get Authorization Code!
        // https://login.salesforce.com/services/oauth2/authorize?
        // client_id=3MVG97L7PWbPq6Ux4TXQzYGE5xjzvCE8EooXZzYzPHfXkLLmXu510r5aUiFzK1nbK5prh8hXoWRVfHkMLF3O2
        // &redirect_uri=https://google.com
        // &response_type=code
        // &prompt=consent
        
        // System.debug(System.Url.getOrgDomainUrl().toExternalForm());
       String orgUrl = config.enviroment__c == 'Production' ? 'https://login.salesforce.com' : 'https://test.salesforce.com';
       String redirect_uri = System.Url.getOrgDomainUrl().toExternalForm() + '/apex/' + config.page_name__c;
       System.debug('REDIRECT URL = '+ redirect_uri);
       String authorizeUrl = orgUrl + config.auth_url__c 
                            + '?client_id=' + config.client_id__c 
                            + '&redirect_uri=' + redirect_uri 
                            + '&response_type=code';

        return new PageReference(authorizeUrl);
    }   

    public void getAccessToken() {
        // Request an Access Token
        String code = ApexPages.currentPage().getParameters().get('code');

        Salesforce_Config__mdt config = Salesforce_Config__mdt.getInstance('SalesforceToken');

        if(config != null) {
            String orgUrl = config.enviroment__c == 'Production' ? 'https://login.salesforce.com' : 'https://test.salesforce.com';
            String redirect_uri = System.Url.getCurrentRequestUrl().toExternalForm();
            String endpointUrl = orgUrl + config.token_url__c;
            String reqBody = 'grant_type=authorization_code'
                                + '&code=' + code
                                + '&client_id=' + config.client_id__c 
                                + '&client_secret=' + config.client_secret__c
                                + '&redirect_uri=' + redirect_uri;


            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-type', 'application/x-www-form-urlencoded');
            req.setHeader('Accept', 'application/json');
            req.setEndpoint(endpointUrl);
            req.setBody(reqBody);

            try {
                HttpResponse res = (new Http()).send(req);
                System.debug(res.getBody());
                System.debug(System.JSON.serializePretty(res.getBody()));
                System.debug('SUCESSFULL CALLOUT USING ACCESS TOKEN!');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfull!'));

                Map<String, Object> fieldsWithValueMap = new Map<String,Object>();
                SalesforceTokenWrapper wrapper = (SalesforceTokenWrapper)System.JSON.deserialize(res.getBody(), SalesforceTokenWrapper.class);
                
                String fullName = 'Salesforce_Config.' + 'SalesforceToken';
                String label = 'SalesforceToken';

                fieldsWithValueMap.put('access_token__c', wrapper.access_token);
                fieldsWithValueMap.put('refresh_token__c', wrapper.refresh_token);
                fieldsWithValueMap.put('expire_in_time__c', System.now().addHours(2));
                fieldsWithValueMap.put('instance_url__c', wrapper.instance_url);
                fieldsWithValueMap.put('client_id__c', config.client_id__c);
                fieldsWithValueMap.put('client_secret__c', config.client_secret__c);
                fieldsWithValueMap.put('scope__c', wrapper.scope);

                CreateUpdateMetadataUtils.createUpdateMetadata(fullName, label, fieldsWithValueMap);
            } catch(CalloutException e) {
                System.debug('Callout Exception Occure  at ' + e.getStackTraceString());
                System.debug('Callout Exception message ' + e.getMessage());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Successfull!'));
            } catch(Exception e) {
                System.debug('Callout Exception Occure  at ' + e.getStackTraceString());
                System.debug('Callout Exception message ' + e.getMessage());
            }

        }
    }


}