@isTest
global class CSS_GetQues_Testone implements HttpCalloutMock
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            
             res.setBody('{"state":{"name":"guide","transition":"next"},"dsid":"DSBDT4780","selection":{"slots":[{"valueId":["18313#8529"],"id":"10#36366"}]},"views":{"result":{"pagination":{"currentPage":0,"numberPerPage":8,"numberOfPages":4,"totalNumberOfRecord":29},"state":"results","searchCompleted":false},"dialog":{"searchCompleted":false},"guide":{"questions":[{"caption":"Engine Performance Symptom","id":"10#8921","question":"Are any of these performance symptoms occuring? If none of these symptoms are present, click the NEXT button.","cardinality":3,"isShowMoreValue":false,"values":[{"caption":"Engine Decelerates Slowly","id":"18325#8549","name":"Engine Decelerates Slowly","score":1,"selected":false},{"caption":"Engine Overspeed","id":"18325#37592","name":"Engine Overspeed","score":2,"selected":false},{"caption":"Engine Speed Surges","id":"18325#8553","name":"Engine Speed Surges","score":13,"selected":false},{"caption":"Engine Stalls/Shutdown","id":"18325#8551","name":"Engine Stalls/Shutdown","score":18,"selected":false},{"caption":"Erratic Idle Speed","id":"18325#42714","name":"Erratic Idle Speed","score":1,"selected":false},{"caption":"Excessive Fuel Consumption","id":"18325#8564","name":"Excessive Fuel Consumption","score":4,"selected":false},{"caption":"Low Power","id":"18325#8560","name":"Low Power","score":13,"selected":false},{"caption":"Runs Rough or Misfires","id":"18325#8562","name":"Runs Rough or Misfires","score":21,"selected":false}],"empty":false,"showValuesScore":false,"zeroScores":true}],"state":"guide","searchCompleted":false}}}');
   
       
        }
        return res;
    }
}