/*
 *Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *WSO2 Inc. licenses this file to you under the Apache License,
 *Version 2.0 (the "License"); you may not use this file except
 *in compliance with the License.
 *You may obtain a copy of the License at
 *
 *http://www.apache.org/licenses/LICENSE-2.0
 *
 *Unless required by applicable law or agreed to in writing,
 *software distributed under the License is distributed on an
 *"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *KIND, either express or implied.  See the License for the
 *specific language governing permissions and limitations
 *under the License.
 */

package org.wso2.sample.identity.oauth2;

public final class OAuth2Constants {

    // Oauth response parameters and session attributes
    public static final String SCOPE = "scope";
    public static final String ERROR = "error";
    public static final String ACCESS_TOKEN = "access_token";
    public static final String SESSION_STATE = "session_state";

    // oauth scopes
    public static final String SCOPE_OPENID = "openid";

    // oauth grant type constants
    public static final String OAUTH2_GRANT_TYPE_CODE = "code";
    public static final String OAUTH2_GRANT_TYPE_IMPLICIT = "token";
    public static final String OAUTH2_GRANT_TYPE_RESOURCE_OWNER = "password";
    public static final String OAUTH2_GRANT_TYPE_CLIENT_CREDENTIALS = "client_credentials";

    // application specific request parameters
    public static final String RESET_PARAM = "reset";
    public static final String RESOURCE_OWNER_PARAM = "recowner";
    public static final String RESOURCE_OWNER_PASSWORD_PARAM = "recpassword";

    // application specific request parameters and session attributes
    public static final String CONSUMER_KEY = "consumerKey";
    public static final String CONSUMER_SECRET = "consumerSecret";
    public static final String CALL_BACK_URL = "callbackurl";
    public static final String OAUTH2_GRANT_TYPE = "grantType";
    public static final String OAUTH2_AUTHZ_ENDPOINT = "authorizeEndpoint";
    public static final String OAUTH2_ACCESS_ENDPOINT = "accessEndpoint";
    public static final String OIDC_LOGOUT_ENDPOINT = "logoutEndpoint";
    public static final String OIDC_SESSION_IFRAME_ENDPOINT = "sessionIFrameEndpoint";

    // application specific session attributes
    public static final String CODE = "code";
    public static final String ID_TOKEN = "id_token";
    public static final String RESULT = "result";
    public static final String TOKEN_VALIDATION = "valid";

    // request headers
    public static final String REFERER = "referer";

    //OAuth 2.0 PKCE Constants
    public static final String OAUTH2_PKCE_CODE_VERIFIER = "code_verifier";
    public static final String OAUTH2_PKCE_CODE_CHALLENGE = "code_challenge";
    public static final String OAUTH2_PKCE_CODE_CHALLENGE_METHOD = "code_challenge_method";
    public static final String OAUTH2_USE_PKCE = "use_pkce";
}
