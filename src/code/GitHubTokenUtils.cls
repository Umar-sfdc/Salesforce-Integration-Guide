public with sharing class GitHubTokenUtils {
    

public PageReference getAuthCode(){
     

        GitHub_Portfolio__mdt config = GitHub_Portfolio__mdt.getInstance('Portfolio');
            	if(config != null){
    
                String orgUrl  = config.environment__c == 'production' ? 'https://login.salesforce.com' : 'https://test.salesforce.com';
    
                System.System.debug('Org Environment ::: ' + orgUrl );
    
                String redirect_uri = System.URL.getOrgDomainURL().toExternalForm()+'/apex/'+config.page_name__c;
                System.System.debug( 'Redirect URL ::: ' + redirect_uri );
    
                String authorizeUrl = orgUrl+config.auth_url__c+'client_id='+config.client_id__c
                                +'&redirect_uri='+redirect_uri+'&response_type=code';
                System.System.debug('Authorize URL ::: ' + authorizeUrl );
    
                return new PageReference(authorizeUrl);
            } 
    	return null;
    }

    public void getAccessToken(){ 
        
        String code = ApexPages.currentPage().getParameters().get('code');
        System.debug('Authorization Code ::: ' + code);
        GitHub_Portfolio__mdt config = GitHub_Portfolio__mdt.getInstance('Portfolio'); // Use Custom Label
        if(config != null){
            
            String orgUrl  = config.environment__c == 'production' ? 'https://login.salesforce.com' : 'https://test.salesforce.com';
    
                System.System.debug('Org Environment ::: ' + orgUrl );
    
            String redirect_uri = System.URL.getOrgDomainURL().toExternalForm()+'/apex/'+config.page_name__c;
                System.System.debug( 'Redirect URL ::: ' + redirect_uri );
            

            String requestBody =    'grant_type=authorization_code' +
                                    '&code=' + code + 
                                    '&client_id='+ config.client_id__c +
                                    '&client_secret='+config.client_secret__c +
                                    '&redirect_uri='+redirect_uri +
                                    '&prompt=login';
            
            System.debug('Request Body ::: ' + requestBody);

            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint(orgUrl + config.token_url__c);
            httpReq.setMethod('POST');
            httpReq.setBody(requestBody);
            httpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
            httpReq.setHeader('Accept','application/json');

            Http http = new Http();
            Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
            String fullName = 'GitHub_Portfolio.Portfolio';
            String label = 'Portfolio';
            try{
                HttpResponse httpRes = http.send(httpReq);
                if(httpRes.getStatusCode() == 200){
             		System.debug('Everything working fine! :::');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfull!'));
                    SalesforceTokenWrapper wrapper = (SalesforceTokenWrapper) System.JSON.deserialize(httpRes.getBody(), SalesforceTokenWrapper.class);

                    fieldWithValuesMap.put('access_token__c', wrapper.access_token);
                    //fieldWithValuesMap.put('expires_in__c',wrapper.);
                    fieldWithValuesMap.put('expire_in_time__c', System.now().addHours(2) );
                    fieldWithValuesMap.put('instance_url__c', wrapper.instance_url);
                    fieldWithValuesMap.put('refresh_token__c', wrapper.refresh_token);
                    fieldWithValuesMap.put('scope__c',wrapper.scope);
                    fieldWithValuesMap.put('client_id__c',config.client_id__c);
                    fieldWithValuesMap.put('client_secret__c',config.client_secret__c);

                    
                }
            }catch(System.CalloutException ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage() ));
            }catch(System.Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage() ));
            }
            if(!fieldWithValuesMap.isEmpty() ){
                CreateUpdateMetadataUtils.createUpdateMetadata(fullName, label, fieldWithValuesMap);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Faild to update metadata!'));
            }
        }
        
    }    
    
    public static Boolean isValid(GitHub_Portfolio__mdt config){
        Boolean isValid = true;
        if(config.expire_in_time__c < System.now()){
            isValid = false;
        }
        return isValid;
    }
    
}