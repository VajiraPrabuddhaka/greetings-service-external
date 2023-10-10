import ballerina/http;
import ballerina/io;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(
        @http:Header string apiKey,
        @http:Header string internalHost,
        @http:Header string path
    ) returns json|error {
        // Send a response back to the caller.
        http:Client greetingClient = check new (string `https://${internalHost}`);

        map<string> additionalHeaders = {
            "API-Key" : apiKey
        };
        
        json|error response = greetingClient->get(path, additionalHeaders);
        if response is error {
            io:println("GET request error:" + response.detail().toString());
        } else {
            io:println("GET request:" + response.toJsonString());
        }

        return response;
    }
}
