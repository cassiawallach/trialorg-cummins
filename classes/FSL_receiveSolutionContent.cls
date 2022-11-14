@RestResource(urlMapping='/CDS/solutionContent/*')
global class FSL_receiveSolutionContent
{ 
    @HttpPost
    global static void doPostOperation()
    {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;      
    	string str = FSL_CL_SolutionContent.handleSolutionRequest(req);
        res.responseBody = Blob.valueOf(str);
        //str = 'connected!';        
    }
}