// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// NOTE: All the tokens/credentials used in this test are dummy tokens/credentials and used only for testing purposes.

import ballerina/encoding;
import ballerina/lang.'string;
import ballerina/regex;
import ballerina/test;

isolated function jwtIssuer() returns string {
    IssuerConfig issuerConfig = {
        username: "John",
        issuer: "wso2",
        audience: ["ballerina", "ballerinaSamples"],
        expTimeInSeconds: 600,
        keyStoreConfig: {
            keyStore: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            keyAlias: "ballerina",
            keyPassword: "ballerina"
        }
    };

    string|Error result = issue(issuerConfig);
    if (result is string) {
        return result;
    }
    return "";
}

@test:Config {}
isolated function testIssueJwt() {
    IssuerConfig issuerConfig = {
        username: "John",
        issuer: "wso2",
        audience: ["ballerina", "ballerinaSamples"],
        expTimeInSeconds: 600,
        keyStoreConfig: {
            keyStore: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            keyAlias: "ballerina",
            keyPassword: "ballerina"
        }
    };

    string|Error result = issue(issuerConfig);
    if (result is string) {
        test:assertTrue(result.startsWith("eyJhbGciOiJSUzI1NiIsICJ0eXAiOiJKV1QifQ."));
        string[] parts = regex:split(result, "\\.");

        // check header
        byte[]|encoding:Error headerDecodedResult = encoding:decodeBase64Url(parts[0]);
        if (headerDecodedResult is byte[]) {
            string|error resultHeader = 'string:fromBytes(headerDecodedResult);
            if (resultHeader is string) {
                test:assertEquals("{\"alg\":\"RS256\", \"typ\":\"JWT\"}", resultHeader, msg = "Found unexpected header");
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }

        // check payload
        byte[]|encoding:Error payloadDecodedResult = encoding:decodeBase64Url(parts[1]);
        if (payloadDecodedResult is byte[]) {
            string|error resultPayload = 'string:fromBytes(payloadDecodedResult);
            if (resultPayload is string) {
                test:assertTrue(resultPayload.startsWith("{\"iss\":\"wso2\", \"sub\":\"John\", \"aud\":[\"ballerina\"" +
                                ", \"ballerinaSamples\"]"));
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }
    } else {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in generated JWT");
    }
}

@test:Config {}
isolated function testIssueJwtWithSingleAud() {
    IssuerConfig issuerConfig = {
        username: "John",
        issuer: "wso2",
        audience: "ballerina",
        expTimeInSeconds: 600,
        keyStoreConfig: {
            keyStore: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            keyAlias: "ballerina",
            keyPassword: "ballerina"
        }
    };

    string|Error result = issue(issuerConfig);
    if (result is string) {
        string[] parts = regex:split(result, "\\.");

        // check header
        byte[]|encoding:Error headerDecodedResult = encoding:decodeBase64Url(parts[0]);
        if (headerDecodedResult is byte[]) {
            string|error resultHeader = 'string:fromBytes(headerDecodedResult);
            if (resultHeader is string) {
                test:assertEquals("{\"alg\":\"RS256\", \"typ\":\"JWT\"}", resultHeader, msg = "Found unexpected header");
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }

        // check payload
        byte[]|encoding:Error payloadDecodedResult = encoding:decodeBase64Url(parts[1]);
        if (payloadDecodedResult is byte[]) {
            string|error resultPayload = 'string:fromBytes(payloadDecodedResult);
            if (resultPayload is string) {
                test:assertTrue(resultPayload.startsWith("{\"iss\":\"wso2\", \"sub\":\"John\", \"aud\":\"ballerina\","));
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }
    } else {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in generated JWT");
    }
}

@test:Config {}
isolated function testIssueJwtWithSingleAudAndAudAsArray() {
    IssuerConfig issuerConfig = {
        username: "John",
        issuer: "wso2",
        audience: ["ballerina"],
        expTimeInSeconds: 600,
        keyStoreConfig: {
            keyStore: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            keyAlias: "ballerina",
            keyPassword: "ballerina"
        }
    };

    string|Error result = issue(issuerConfig);
    if (result is string) {
        string[] parts = regex:split(result, "\\.");

        // check header
        byte[]|encoding:Error headerDecodedResult = encoding:decodeBase64Url(parts[0]);
        if (headerDecodedResult is byte[]) {
            string|error resultHeader = 'string:fromBytes(headerDecodedResult);
            if (resultHeader is string) {
                test:assertEquals("{\"alg\":\"RS256\", \"typ\":\"JWT\"}", resultHeader, msg = "Found unexpected header");
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }

        // check payload
        byte[]|encoding:Error payloadDecodedResult = encoding:decodeBase64Url(parts[1]);
        if (payloadDecodedResult is byte[]) {
            string|error resultPayload = 'string:fromBytes(payloadDecodedResult);
            if (resultPayload is string) {
                test:assertTrue(resultPayload.startsWith("{\"iss\":\"wso2\", \"sub\":\"John\", \"aud\":[\"ballerina\"],"));
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }
    } else {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in generated JWT");
    }
}

@test:Config {}
isolated function testIssueJwtWithNoIssOrSub() {
    IssuerConfig issuerConfig = {
        audience: ["ballerina", "ballerinaSamples"],
        expTimeInSeconds: 600,
        keyStoreConfig: {
            keyStore: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            keyAlias: "ballerina",
            keyPassword: "ballerina"
        }
    };

    string|Error result = issue(issuerConfig);
    if (result is string) {
        string[] parts = regex:split(result, "\\.");

        // check header
        byte[]|encoding:Error headerDecodedResult = encoding:decodeBase64Url(parts[0]);
        if (headerDecodedResult is byte[]) {
            string|error resultHeader = 'string:fromBytes(headerDecodedResult);
            if (resultHeader is string) {
                test:assertEquals("{\"alg\":\"RS256\", \"typ\":\"JWT\"}", resultHeader, msg = "Found unexpected header");
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }

        // check payload
        byte[]|encoding:Error payloadDecodedResult = encoding:decodeBase64Url(parts[1]);
        if (payloadDecodedResult is byte[]) {
            string|error resultPayload = 'string:fromBytes(payloadDecodedResult);
            if (resultPayload is string) {
                test:assertTrue(resultPayload.startsWith("{\"aud\":[\"ballerina\", \"ballerinaSamples\"],"));
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }
    } else {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in generated JWT");
    }
}

@test:Config {}
isolated function testIssueJwtWithNoAudOrSub() {
    IssuerConfig issuerConfig = {
        username: "John",
        issuer: "wso2",
        expTimeInSeconds: 600,
        keyStoreConfig: {
            keyStore: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            keyAlias: "ballerina",
            keyPassword: "ballerina"
        }
    };

    string|Error result = issue(issuerConfig);
    if (result is string) {
        string[] parts = regex:split(result, "\\.");

        // check header
        byte[]|encoding:Error headerDecodedResult = encoding:decodeBase64Url(parts[0]);
        if (headerDecodedResult is byte[]) {
            string|error resultHeader = 'string:fromBytes(headerDecodedResult);
            if (resultHeader is string) {
                test:assertEquals("{\"alg\":\"RS256\", \"typ\":\"JWT\"}", resultHeader, msg = "Found unexpected header");
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }

        // check payload
        byte[]|encoding:Error payloadDecodedResult = encoding:decodeBase64Url(parts[1]);
        if (payloadDecodedResult is byte[]) {
            string|error resultPayload = 'string:fromBytes(payloadDecodedResult);
            if (resultPayload is string) {
                test:assertTrue(resultPayload.startsWith("{\"iss\":\"wso2\", \"sub\":\"John\","));
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }
    } else {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in generated JWT");
    }
}

@test:Config {}
isolated function testIssueJwtWithCustomClaims() {
    IssuerConfig issuerConfig = {
        username: "John",
        issuer: "wso2",
        audience: ["ballerina", "ballerinaSamples"],
        customClaims: { "scope": "test-scope" },
        expTimeInSeconds: 600,
        keyStoreConfig: {
            keyStore: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            keyAlias: "ballerina",
            keyPassword: "ballerina"
        }
    };

    string|Error result = issue(issuerConfig);
    if (result is string) {
        string[] parts = regex:split(result, "\\.");

        // check header
        byte[]|encoding:Error headerDecodedResult = encoding:decodeBase64Url(parts[0]);
        if (headerDecodedResult is byte[]) {
            string|error resultHeader = 'string:fromBytes(headerDecodedResult);
            if (resultHeader is string) {
                test:assertEquals("{\"alg\":\"RS256\", \"typ\":\"JWT\"}", resultHeader, msg = "Found unexpected header");
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }

        // check payload
        byte[]|encoding:Error payloadDecodedResult = encoding:decodeBase64Url(parts[1]);
        if (payloadDecodedResult is byte[]) {
            string|error resultPayload = 'string:fromBytes(payloadDecodedResult);
            if (resultPayload is string) {
                test:assertTrue(resultPayload.startsWith("{\"iss\":\"wso2\", \"sub\":\"John\", \"aud\":[\"ballerina\"" +
                                ", \"ballerinaSamples\"],"));
                test:assertTrue(resultPayload.endsWith("\"scope\":\"test-scope\"}"));
            } else {
                test:assertFail(msg = "Expected string, but found error");
            }
        } else {
            test:assertFail(msg = "Expected byte[], but found error");
        }
    } else {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in generated JWT");
    }
}

@test:Config {
    dataProvider: jwtIssuer
}
isolated function testValidateJwt(string jwt) {
    ValidatorConfig config = {
        issuer: "wso2",
        audience: ["ballerina", "ballerinaSamples"],
        clockSkewInSeconds: 60,
        trustStoreConfig: {
            trustStore: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            certificateAlias: "ballerina"
        }
    };
    Payload|Error result = validate(jwt, config);
    if !(result is Payload) {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in validating JWT");
    }
}

@test:Config {
    dataProvider: jwtIssuer
}
isolated function testValidateJwtWithSingleAud(string jwt) {
    ValidatorConfig config = {
        issuer: "wso2",
        audience: "ballerina",
        clockSkewInSeconds: 60,
        trustStoreConfig: {
            trustStore: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            certificateAlias: "ballerina"
        }
    };
    Payload|Error result = validate(jwt, config);
    if !(result is Payload) {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in validating JWT");
    }
}

@test:Config {
    dataProvider: jwtIssuer
}
isolated function testValidateJwtWithSingleAudAndAudAsArray(string jwt) {
    ValidatorConfig config = {
        issuer: "wso2",
        audience: "ballerina",
        clockSkewInSeconds: 60,
        trustStoreConfig: {
            trustStore: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            certificateAlias: "ballerina"
        }
    };
    Payload|Error result = validate(jwt, config);
    if !(result is Payload) {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in validating JWT");
    }
}

@test:Config {
    dataProvider: jwtIssuer
}
isolated function testValidateJwtWithNoIssOrSub(string jwt) {
    ValidatorConfig config = {
        audience: "ballerinaSamples",
        clockSkewInSeconds: 60,
        trustStoreConfig: {
            trustStore: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            certificateAlias: "ballerina"
        }
    };
    Payload|Error result = validate(jwt, config);
    if !(result is Payload) {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in validating JWT");
    }
}

@test:Config {
    dataProvider: jwtIssuer
}
isolated function testValidateJwtWithInvalidSignature(string jwt) {
    ValidatorConfig config = {
        trustStoreConfig: {
            trustStore: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            certificateAlias: "ballerina"
        }
    };
    Payload|Error result = validate(jwt, config);
    if !(result is Payload) {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in validating JWT");
    }
}

@test:Config {}
isolated function testValidateJwtSignatureWithJwk() {
    string jwt = "eyJhbGciOiJSUzI1NiIsICJ0eXAiOiJKV1QiLCAia2lkIjoiTlRBeFptTXhORE15WkRnM01UVTFaR00wTXpFek9ESmhaV0k0Tk" +
                 "RObFpEVTFPR0ZrTmpGaU1RIn0.eyJzdWIiOiJhZG1pbiIsICJpc3MiOiJiYWxsZXJpbmEiLCAiZXhwIjoxOTA3NjY1NzQ2LCAi" +
                 "anRpIjoiMTAwMDc4MjM0YmEyMyIsICJhdWQiOlsidkV3emJjYXNKVlFtMWpWWUhVSENqaHhaNHRZYSJdfQ.E8E7VO18V6MG7Ns" +
                 "87Y314Dqg8RYOMe0WWYlSYFhSv0mHkJQ8bSSyBJzFG0Se_7UsTWFBwzIALw6wUiP7UGraosilf8k6HGJWbTjWtLXfniJXx5Ncz" +
                 "ikzciG8ADddksm-0AMi5uPsgAQdg7FNaH9f4vAL6SPMEYp2gN6GDnWTH7M1vnknwjOwTbQpGrPu_w2V1tbsBwSzof3Fk_cYrnt" +
                 "u8D_pfsBu3eqFiJZD7AXUq8EYbgIxpSwvdi6_Rvw2_TAi46drouxXK2Jglz_HvheUVCERT15Y8JNJONJPJ52MsN6t297hyFV9A" +
                 "myNPzwHxxmi753TclbapDqDnVPI1tpc-Q";
    ValidatorConfig config = {
        issuer: "ballerina",
        audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
        jwksConfig: {
            url: "https://asb0zigfg2.execute-api.us-west-2.amazonaws.com/v1/jwks"
        }
    };
    Payload|Error result = validate(jwt, config);
    if !(result is Payload) {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in validating JWT");
    }
}

@test:Config {}
isolated function testValidateJwtSignatureWithInvalidJwk() {
    // There is a JWK with the same `kid`, but the `modulus` of the public key does not match.
    string jwt = "eyJ4NXQiOiJOVEF4Wm1NeE5ETXlaRGczTVRVMVpHTTBNekV6T0RKaFpXSTRORE5sWkRVMU9HRmtOakZpTVEiLCJraWQiO" +
             "iJOVEF4Wm1NeE5ETXlaRGczTVRVMVpHTTBNekV6T0RKaFpXSTRORE5sWkRVMU9HRmtOakZpTVEiLCJhbGciOiJSUzI1NiJ9.ey" +
             "JzdWIiOiJhZG1pbkBjYXJib24uc3VwZXIiLCJhdWQiOiJ2RXd6YmNhc0pWUW0xalZZSFVIQ2poeFo0dFlhIiwibmJmIjoxNTg3" +
             "NDc1Njk0LCJhenAiOiJ2RXd6YmNhc0pWUW0xalZZSFVIQ2poeFo0dFlhIiwiaXNzIjoiaHR0cHM6XC9cL2xvY2FsaG9zdDo5ND" +
             "QzXC9vYXV0aDJcL3Rva2VuIiwiZXhwIjoxNTg3NDc1NzA0LCJpYXQiOjE1ODc0NzU2OTQsImp0aSI6ImZmMTk3NmI0LTU0MmYt" +
             "NDgxNC1iOGNlLTg0ODNhNGYxZWE5ZiJ9.VHXgtU72omIibSfwuggIXhykivfAncUFF5-mCCrrVwRBNWpd2KEVBqizGU_onCdNo" +
             "SsJOc608d-2Tq77ZzJkq7RXPRTxdim4lHkL9PgJpuJzbbk7-c9z3Zd10Kd7n_BuiiUCqJxQQTvfwAShjl6pHd-Z6bqBTdIPDBg" +
             "hJnTmGgEydWDBzvl8zsUPZJAUFHLlKUBIW8Qy0tC7NpUnPWyYoXdFf0hpkQi0h58fTG9iMr-30mlFJgBRjsanbBQEemWXokZ6T" +
             "uam1DQAQB9-Tsxk1TQ5GRyMKcsD2gWt-aJsyRLtXSwmgsUxTyA6VCLlF9oJuMxg-hQKxiDS1RSXHReczw";
    ValidatorConfig config = {
        issuer: "ballerina",
        audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
        jwksConfig: {
            url: "https://asb0zigfg2.execute-api.us-west-2.amazonaws.com/v1/jwks"
        }
    };
    Payload|Error result = validate(jwt, config);
    if !(result is Error) {
        test:assertFail(msg = "Error in validating JWT with invalid JWK");
    }
}

@test:Config {}
isolated function testValidateJwtSignatureWithJwkWithClientConfig() {
    string jwt = "eyJhbGciOiJSUzI1NiIsICJ0eXAiOiJKV1QiLCAia2lkIjoiTlRBeFptTXhORE15WkRnM01UVTFaR00wTXpFek9ESmhaV0k0Tk" +
                 "RObFpEVTFPR0ZrTmpGaU1RIn0.eyJzdWIiOiJhZG1pbiIsICJpc3MiOiJiYWxsZXJpbmEiLCAiZXhwIjoxOTA3NjY1NzQ2LCAi" +
                 "anRpIjoiMTAwMDc4MjM0YmEyMyIsICJhdWQiOlsidkV3emJjYXNKVlFtMWpWWUhVSENqaHhaNHRZYSJdfQ.E8E7VO18V6MG7Ns" +
                 "87Y314Dqg8RYOMe0WWYlSYFhSv0mHkJQ8bSSyBJzFG0Se_7UsTWFBwzIALw6wUiP7UGraosilf8k6HGJWbTjWtLXfniJXx5Ncz" +
                 "ikzciG8ADddksm-0AMi5uPsgAQdg7FNaH9f4vAL6SPMEYp2gN6GDnWTH7M1vnknwjOwTbQpGrPu_w2V1tbsBwSzof3Fk_cYrnt" +
                 "u8D_pfsBu3eqFiJZD7AXUq8EYbgIxpSwvdi6_Rvw2_TAi46drouxXK2Jglz_HvheUVCERT15Y8JNJONJPJ52MsN6t297hyFV9A" +
                 "myNPzwHxxmi753TclbapDqDnVPI1tpc-Q";
    ValidatorConfig config = {
        issuer: "ballerina",
        audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
        jwksConfig: {
            url: "https://asb0zigfg2.execute-api.us-west-2.amazonaws.com/v1/jwks",
            clientConfig: {
                httpVersion: HTTP_2,
                secureSocket: {
                    trustStore: {
                        path: TRUSTSTORE_PATH,
                        password: "ballerina"
                    }
                }
            }
        }
    };
    Payload|Error result = validate(jwt, config);
    if !(result is Payload) {
        string? errMsg = result.message();
        test:assertFail(msg = errMsg is string ? errMsg : "Error in validating JWT with client configurations");
    }
}
