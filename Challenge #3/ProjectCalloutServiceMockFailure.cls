public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
    
   public HttpResponse respond(HttpRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setHeader('Content-Type', 'application/json');
        resp.setStatusCode(500);
        resp.setStatus('Error');
        return resp;
    }
}
