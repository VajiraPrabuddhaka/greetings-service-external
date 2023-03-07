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
    http:Client greetingClient = check new ("https://75a0c9ed-5a4c-43da-89ed-32bfa6e84033-tenv2-inyy-internal.prod-us-east-azure.internal.choreo-st.choreoapis.dev");

    // Sends a `GET` request to the "/albums" resource.
    // The verb is not mandatory as it is default to "GET".
    map<string> additionalHeaders = {
        "API-Key" : apiKey
    };
    json|error response = greetingClient->get(string `/inyy/greetingserviceinternal/1.0.0?name=${name}`, additionalHeaders);
    if response is error {
        io:println("GET request error:" + response.detail().toString());
    } else {
        io:println("GET request:" + response.toJsonString());
    }

    return response;
}
