import ballerina/http;
import ballerina/io;

service / on new http:Listener(8090) {
    resource function get .(
        string name,
        @http:Header string apiKey
    ) returns json|error {
        return sayGreetings(name, apiKey);
    }
}

public function sayGreetings(string name, string apiKey) returns json|error {
    // Creates a new client with the Basic REST service URL.
    // https://webhook.site/aff29f66-fcd7-40d5-ab88-6bc9878cccf5
    http:Client greetingClient = check new ("https://1e63a877-dbdc-4aa0-90d3-b6a2b66c1b9e-test02-ywdm-internal.st-internal-waw.choreoapis.dev", 
        {
            secureSocket: { 
                enable: false
            }
        });

    // Sends a `GET` request to the "/albums" resource.
    // The verb is not mandatory as it is default to "GET".
    map<string> additionalHeaders = {
        "API-Key" : apiKey
    };
    json|error response = greetingClient->get(string `/ywdm/greetingserviceinternal/1.0.0?name=${name}`, additionalHeaders);
    if response is error {
        io:println("GET request error:" + response.detail().toString());
    } else {
        io:println("GET request:" + response.toJsonString());
    }

    return response;
}
