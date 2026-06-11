public with sharing class ZendeskTicketUtils {

    public class TicektWrapper {
        public String body;
        public String subject;
        public String priority;
        public String name;
        public String email;
    }
    
    public static void createTicket(TicektWrapper wrapper) {
        
        String endPoint = System.Label.ZENDESK_URL + 'api/v2/tickets';
        String header = System.Label.ZENDESK_USERNAME + '/token' + ':' + System.Label.ZENDESK_TOKEN;
        String requestBody = '{'+
		'    "ticket": {'+
		'        "comment": {'+
		'            "body": "'+wrapper.body+'"'+
		'        },'+
		'        "priority": "'+wrapper.priority+'",'+
		'        "subject": "'+wrapper.subject+'",'+
		'        "requester": {'+
		'            "locale_id": 8,'+
		'            "name": "'+wrapper.name+'",'+
		'            "email": "'+wrapper.email+'"'+
		'        }'+
		'    }'+
		'}'; 
        

        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint);
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json');
        request.setHeader('Accept','application/json');
        request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(header)));
        request.setBody(requestBody);
        

        try {
            HttpResponse response = (new HTTP()).send(request);
            if(response.getStatusCode() == 201) {
                 System.debug('SUCCESS : ' + response.getBody());
             } else {
                System.debug('FAILD! : ' + response.getBody());
            	}

        } catch(Exception e) {
            System.debug('Faild Callout! ' + e.getMessage());
        }


    }
}