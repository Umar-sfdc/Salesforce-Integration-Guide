public with sharing class SimpleGroceryStore {

    private static final String URL = 'https://simple-grocery-store-api.click';

    public static void fetchStore() {

        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL);
        req.setHeader('content-type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setMethod('GET');
        req.setTimeout(6000);

        Http http = new Http();

        try {
            HttpResponse res = http.send(req);
            System.debug('Store is running...');
            System.debug('success message : ' + res.getBody());
            System.debug('request status code : ' + res.getStatusCode());
        
        } catch (CalloutException e) {
            System.debug('Exception Error Message ' + e.getMessage());
        } catch (Exception e) {
            System.debug('General Error Message ' + e.getMessage());
        }
    }

    public static void fetchProducts() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL + '/products');
        req.setHeader('content-type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setMethod('GET');
        req.setTimeout(6000);

        Http http = new Http();

        try {
            HttpResponse res = http.send(req);
            System.debug('Store is running...');
            System.debug('success message : ' + res.getBody());
            System.debug('request status code : ' + res.getStatusCode());
        
        } catch (CalloutException e) {
            System.debug('Exception Error Message ' + e.getMessage());
        } catch (Exception e) {
            System.debug('General Error Message ' + e.getMessage());
        }
    }

}