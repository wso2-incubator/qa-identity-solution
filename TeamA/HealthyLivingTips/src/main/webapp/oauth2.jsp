<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="org.apache.commons.httpclient.HttpClient" %>
<%@ page import="org.apache.commons.httpclient.methods.GetMethod" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@page import="com.nimbusds.jwt.SignedJWT" %>
<%@page import="org.apache.commons.lang.StringUtils" %>
<%@page import="org.apache.oltu.oauth2.client.response.OAuthAuthzResponse" %>
<%@page import="org.wso2.sample.identity.oauth2.OAuth2Constants" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.UUID" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>

<%@ page import = "java.util.ResourceBundle" %>

<%
    ResourceBundle resource = ResourceBundle.getBundle("pharmacy");
    String code = null;
    String accessToken = null;
    String idToken = null;
    String name = null;
    String scope = null;
    String sessionState = null;
    String error = null;
    String grantType = null;
    String code_verifier = null;
    String code_challenge = null;

    boolean isOIDCLogoutEnabled = false;
    boolean isOIDCSessionEnabled = false;

    OAuthAuthzResponse authzResponse = null;

    try {
        String reset = request.getParameter(OAuth2Constants.RESET_PARAM);
        if (reset != null && Boolean.parseBoolean(reset)) {
            session.removeAttribute(OAuth2Constants.OAUTH2_GRANT_TYPE);
            session.removeAttribute(OAuth2Constants.ACCESS_TOKEN);
            session.removeAttribute(OAuth2Constants.CODE);
            session.removeAttribute(OAuth2Constants.ID_TOKEN);
            session.removeAttribute(OAuth2Constants.RESULT);
            session.removeAttribute(OAuth2Constants.SESSION_STATE);
            session.removeAttribute(OAuth2Constants.SCOPE);
            session.removeAttribute(OAuth2Constants.OAUTH2_AUTHZ_ENDPOINT);
            session.removeAttribute(OAuth2Constants.OIDC_LOGOUT_ENDPOINT);
            session.removeAttribute(OAuth2Constants.OIDC_SESSION_IFRAME_ENDPOINT);
            session.removeAttribute(OAuth2Constants.OAUTH2_PKCE_CODE_VERIFIER);
            session.removeAttribute(OAuth2Constants.OAUTH2_USE_PKCE);
        }

        sessionState = request.getParameter(OAuth2Constants.SESSION_STATE);
        if (StringUtils.isNotBlank(sessionState)) {
            session.setAttribute(OAuth2Constants.SESSION_STATE, sessionState);
        }

        error = request.getParameter(OAuth2Constants.ERROR);
        grantType = (String) session.getAttribute(OAuth2Constants.OAUTH2_GRANT_TYPE);
        if (StringUtils.isNotBlank(request.getHeader(OAuth2Constants.REFERER)) &&
                request.getHeader(OAuth2Constants.REFERER).contains("rpIFrame")) {
            /**
             * Here referer is being checked to identify that this is exactly is an response to the passive request
             * initiated by the session checking iframe.
             * In this sample, every error is forwarded back to this page. Thus, this condition is added to treat
             * error response coming for the passive request separately, and to identify that as a logout scenario.
             */
            if (StringUtils.isNotBlank(error)) { // User has been logged out
                session.invalidate();
                response.sendRedirect("index.jsp");
                return;
            } else {
                if (grantType != null && OAuth2Constants.OAUTH2_GRANT_TYPE_CODE.equals(grantType)) {
                    code = request.getParameter(OAuth2Constants.CODE);
                    session.setAttribute(OAuth2Constants.CODE, code);
                }
            }
        }

        if (grantType != null && OAuth2Constants.OAUTH2_GRANT_TYPE_CODE.equals(grantType)) {
            code = (String) session.getAttribute(OAuth2Constants.CODE);
            if (code == null) {
                authzResponse = OAuthAuthzResponse.oauthCodeAuthzResponse(request);
                code = authzResponse.getCode();
                session.setAttribute(OAuth2Constants.CODE, code);
            } else {
                accessToken = (String) session.getAttribute(OAuth2Constants.ACCESS_TOKEN);
                idToken = (String) session.getAttribute(OAuth2Constants.ID_TOKEN);
            }
        } else if (grantType != null && OAuth2Constants.OAUTH2_GRANT_TYPE_CLIENT_CREDENTIALS.equals(grantType)) {
            accessToken = (String) session.getAttribute(OAuth2Constants.ACCESS_TOKEN);
        } else if (grantType != null && OAuth2Constants.OAUTH2_GRANT_TYPE_RESOURCE_OWNER.equals(grantType)) {
            accessToken = (String) session.getAttribute(OAuth2Constants.ACCESS_TOKEN);
        }

        scope = (String) session.getAttribute(OAuth2Constants.SCOPE);
        if (StringUtils.isNotBlank(scope) && scope.contains(OAuth2Constants.SCOPE_OPENID)) {
            if (StringUtils.isNotBlank((String) session.getAttribute(OAuth2Constants.OIDC_LOGOUT_ENDPOINT))) {
                isOIDCLogoutEnabled = true;
            }

            if (StringUtils.isNotBlank((String) session.getAttribute(OAuth2Constants.OIDC_SESSION_IFRAME_ENDPOINT))) {
                isOIDCSessionEnabled = true;
            }
        }

    } catch (Exception e) {
        error = e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>

<style>
    /* Define custom CSS by the user here */
    body{
        background-color: #0099cc;
    }
</style>

    <title>Healthy Living Tips</title>
    <meta charset="UTF-8">
    <meta name="description" content=""/>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
    <!--[if lt IE 9]>
    <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
    <script type="text/javascript" src="js/prettify.js"></script>
    <!-- PRETTIFY -->
    <script type="text/javascript" src="js/kickstart.js"></script>
    <!-- KICKSTART -->
    <link rel="stylesheet" type="text/css" href="css/kickstart.css" media="all"/>
    <!-- KICKSTART -->
    <link rel="stylesheet" type="text/css" href="style.css" media="all"/>
    <!-- CUSTOM STYLES -->

    <script type="text/javascript">
        function setVisibility() {

            var grantType = document.getElementById("grantType").value;
            var scope = document.getElementById("scope").value;

            document.getElementById("logutep").style.display = "none";
            document.getElementById("sessionep").style.display = "none";

            if ('code' == grantType) {
                document.getElementById("clientsecret").style.display = "none";
                document.getElementById("callbackurltr").style.display = "";
                document.getElementById("authzep").style.display = "";
                document.getElementById("accessep").style.display = "none";
                document.getElementById("recownertr").style.display = "none";
                document.getElementById("recpasswordtr").style.display = "none";

                if (scope.indexOf("openid") > -1) {
                    document.getElementById("logutep").style.display = "";
                    document.getElementById("sessionep").style.display = "";
                }
            } else if ('token' == grantType) {
                document.getElementById("clientsecret").style.display = "none";
                document.getElementById("callbackurltr").style.display = "";
                document.getElementById("authzep").style.display = "";
                document.getElementById("accessep").style.display = "none";
                document.getElementById("recownertr").style.display = "none";
                document.getElementById("recpasswordtr").style.display = "none";
            } else if ('password' == grantType) {
                document.getElementById("clientsecret").style.display = "";
                document.getElementById("callbackurltr").style.display = "none";
                document.getElementById("authzep").style.display = "none";
                document.getElementById("accessep").style.display = "";
                document.getElementById("recownertr").style.display = "";
                document.getElementById("recpasswordtr").style.display = "";
            } else if ('client_credentials' == grantType) {
                document.getElementById("clientsecret").style.display = "";
                document.getElementById("callbackurltr").style.display = "none";
                document.getElementById("authzep").style.display = "none";
                document.getElementById("accessep").style.display = "";
                document.getElementById("recownertr").style.display = "none";
                document.getElementById("recpasswordtr").style.display = "none";
            }

            return true;
        }

        function getAcceesToken() {
            var fragment = window.location.hash.substring(1);
            if (fragment.indexOf("&") > 0) {
                var arrParams = fragment.split("&");

                var i = 0;
                for (i = 0; i < arrParams.length; i++) {
                    var sParam = arrParams[i].split("=");

                    if (sParam[0] == "access_token") {
                        return sParam[1];
                    }
                }
            }
            return "";
        }

    </script>

</head>
<!-- ===================================== END HEADER ===================================== -->
<body><a id="top-of-page"></a>

<div id="wrap" class="clearfix"/>
<!-- Menu Horizontal -->
<ul class="menu">
    <li class="current"><a href="index.jsp">Home</a></li>
</ul>

<div class="col_12"/>
<div class="col_9"/>
<h3>Healthy Living Tips</h3>

<table>
    <tr>
        <td>
            <% if (accessToken == null && code == null && grantType == null) {
                code_verifier = UUID.randomUUID().toString() + UUID.randomUUID().toString();
                code_verifier = code_verifier.replaceAll("-", "");

                MessageDigest digest = MessageDigest.getInstance("SHA-256");
                byte[] hash = digest.digest(code_verifier.getBytes(StandardCharsets.US_ASCII));
                //Base64 encoded string is trimmed to remove trailing CR LF
                code_challenge = new String(Base64.encodeBase64URLSafe(hash), StandardCharsets.UTF_8).trim();
                //set the generated code verifier to the current user session
                session.setAttribute(OAuth2Constants.OAUTH2_PKCE_CODE_VERIFIER, code_verifier);

            %>
            <div id="loginDiv" class="sign-in-box" width="100%">
                <% if (error != null && error.trim().length() > 0) {%>
                <table class="user_pass_table" width="100%">
                    <tr>
                        <td><font color="#CC0000"><%=error%>
                        </font></td>
                    </tr>
                </table>
                <%} %>

                    <form action="oauth2-authorize-user.jsp" id="loginForm" method="post" name="oauthLoginForm">
                    <table class="user_pass_table" width="100%">
                        <tbody>

                        <tr>

                            <td>
                                <select id="grantType" name="grantType" onchange="setVisibility();">
                                    <option value="<%=OAuth2Constants.OAUTH2_GRANT_TYPE_CODE%>" selected="selected">
                                        Authorization Code
                                    </option>
                                    <option value="<%=OAuth2Constants.OAUTH2_GRANT_TYPE_IMPLICIT%>">Implicit</option>
                                    <option value="<%=OAuth2Constants.OAUTH2_GRANT_TYPE_CLIENT_CREDENTIALS%>">Client
                                        Credentials
                                    </option>
                                    <option value="<%=OAuth2Constants.OAUTH2_GRANT_TYPE_RESOURCE_OWNER%>">Resource
                                        Owner
                                    </option>
                                </select>
                            </td>
                        </tr>

                        <tr><%
                            String clientID=resource.getString("clientID");
                            %>
                           <!--
                           <td><label>Client Id : </label></td>
                            -->
                            <td><input type="hidden" id="consumerKey" name="consumerKey" value="<%=clientID%>" style="width:350px"></td>
                        </tr>

                        <tr id="clientsecret" style="display:none">
                            <td><label>Client Secret : </label></td>
                            <td><input type="password" id="consumerSecret" name="consumerSecret" style="width:350px">
                            </td>
                        </tr>

                        <tr id="recownertr" style="display:none">
                            <td><label>Resource Owner User Name: </label></td>
                            <td><input type="text" id="recowner" name="recowner" style="width:350px"></td>
                        </tr>

                        <tr id="recpasswordtr" style="display:none">
                            <td><label>Resource Owner Password : </label></td>
                            <td><input type="password" id="recpassword" name="recpassword" style="width:350px">
                            </td>
                        </tr>

                        <tr>                            <%
                                                            String scopeGiven=resource.getString("scopeGiven");
                                                        %>
                           <!--  <td><label>Scope : </label></td> -->
                            <td><input type="hidden" id="scope" name="scope" value="<%=scopeGiven%>" onchange="setVisibility();">
                            </td>
                        </tr>

                        <tr id="callbackurltr">
                        <%
                            String callbackurlJ=resource.getString("callbackurl");
                        %>
                          <!--   <td><label>Callback URL : </label></td> -->
                            <td><input type="hidden" id="callbackurl" name="callbackurl" value="<%=callbackurlJ%>" style="width:350px">
                            </td>
                        </tr>

                        <tr id="authzep">
                                                <%
                                                    String authorizeEndpointJ=resource.getString("authorizeEndpoint");
                                                %>
                           <!--  <td>Authorize Endpoint :</td> -->
                            <td><input type="hidden" id="authorizeEndpoint" name="authorizeEndpoint" value="<%=authorizeEndpointJ%>" style="width:350px">
                            </td>
                        </tr>

                        <tr id="accessep" style="display:none">
                            <td>Access Token Endpoint :</td>
                            <td><input type="text" id="accessEndpoint" name="accessEndpoint" style="width:350px"></td>
                        </tr>

                        <tr id="logutep" style="display:none">
                            <td>Logout Endpoint :</td>
                            <td><input type="text" id="logoutEndpoint" name="logoutEndpoint" style="width:350px">
                            </td>
                        </tr>

                        <tr id="sessionep" style="display:none">
                            <td>Session Iframe Endpoint :</td>
                            <td><input type="text" id="sessionIFrameEndpoint" name="sessionIFrameEndpoint"
                                       style="width:350px"></td>
                        </tr>

                       <tr id="pkceOption">

                            <td>
                                <input type="radio" id="firstButton" name="use_pkce" checked="checked" value="no">
                            </td>
                        </tr>
                        <tr id="pkceMethod">
                            <td>PKCE Challenge Method</td>
                            <td><input type="radio" name="code_challenge_method" onchange="togglePKCEMethod()"
                                       value="S256" checked>S256 &nbsp;
                                <input type="radio" name="code_challenge_method" onchange="togglePKCEMethod()"
                                       value="plain">plain
                            </td>
                        </tr>
                        <tr id="pkceChallenge">
                            <td>PKCE Code Challenge</td>
                            <td><input type="text" style="width: 350px" readonly name="code_challenge"
                                       value="<%=code_challenge%>"></td>
                        </tr>
                        <tr id="pkceVerifier">
                            <td>PKCE Code Verifier [length : <%=code_verifier.length()%>]</td>
                            <td><label><%=code_verifier%>
                            </label></td>
                        </tr>

                        <tr>
                            <td colspan="2"><input type="submit" name="authorize" value="Login"></td>
                        </tr>
                        </tbody>
                    </table>

                </form>
            </div>

            <%} else if (code != null && accessToken == null) { %>
            <div>
                <form action="oauth2-get-access-token.jsp" id="loginForm" method="post">

                    <table class="user_pass_table">
                        <tbody>
                        <tr>

                           <!-- <td><%=code%></td> -->
                        </tr>
                        <tr>
                                                                        <%
                                                                            String callbackurlJJ=resource.getString("callbackurl");
                                                                        %>

                            <td><input type="hidden" id="callbackurl" name="callbackurl" value="<%=callbackurlJJ%>" style="width:350px"></td>
                        </tr>
                        <tr>

                        <%
                         String accessTokenEndpointJ=resource.getString("accessTokenEndpoint");
                         %>

                            <td><input type="hidden" id="accessEndpoint" name="accessEndpoint" value="<%=accessTokenEndpointJ%>" style="width:350px"></td>
                        </tr>
                        <tr>
                            <%
                            String clinetSecretJ=resource.getString("clinetSecret");
                            %>

                            <td><input type="hidden" id="consumerSecret" name="consumerSecret" value="<%=clinetSecretJ%>" style="width:350px">
                            </td>
                        </tr>
                        <% if (session.getAttribute(OAuth2Constants.OAUTH2_USE_PKCE) != null) {%>
                        <tr>
                            <td><label>PKCE Verifier : </label></td>
                            <td><input type="text" id="pkce_verifier" name="code_verifier" style="width:350px"
                                       value="<%=(String)session.getAttribute(OAuth2Constants.OAUTH2_PKCE_CODE_VERIFIER)%>">
                            </td>
                        </tr>
                        <% }%>

                        <!-- -->

                        <tr>
                            <td><input type="submit" name="authorize" value="View Todays Deadliest Disease"></td>
                            <%
                                if (isOIDCLogoutEnabled) {
                            %>
                            <td>
                                <button type="button" class="button"
                                        onclick="document.location.href='<%=(String)session.getAttribute(OAuth2Constants.OIDC_LOGOUT_ENDPOINT)%>';">
                                    Logout
                                </button>
                            </td>
                            <%
                                }
                            %>
                        </tr>
                        </tbody>
                    </table>
                </form>

            </div>
            <%
            } else if (accessToken != null) {

                if (idToken != null) {
                    try {
                        name = SignedJWT.parse(idToken).getJWTClaimsSet().getSubject();
                    } catch (Exception e) {
                        //ignore
                    }
            %>


<form action="oauth2-access-resource.jsp" id="loginForm" method="post">

                    <table class="user_pass_table">
                        <tbody>
                        <tr>
                            <td><label>Logged In User :</label></td>
                            <td><label id="loggedUser"><%=name%></label></td>
                        </tr>


                        <tr>
                            	    <%
                                                if(accessToken != null) {
                                        %>

                                        <%
                                                    // Creates an HTTP REST call to micro service
                                                    // Create an instance of HttpClient.
                                                    HttpClient client = new HttpClient();
                                                    String microServiceURL = "http://192.168.48.218:8081/hello/";

                                                    // Create a method instance.
                                                    GetMethod method = new GetMethod(microServiceURL + "admin");
                                                    method.setRequestHeader("X-JWT-Assertion", accessToken);


                                                    try {
                                                        client.executeMethod(method);
                                                        byte[] responseBody = method.getResponseBody();
                                                        String responseString = new String(responseBody);
                                        %>

                                                                  <div style="text-indent: 50px">
                                                                                <br/>

                                                                                <p style="font-size:16px" > "Healthy living" to most people means both physical and mental health are in balance or functioning well together in a person. In many instances, physical and mental health are closely linked, so that a change (good or bad) in one directly affects the other. Consequently, some of the tips will include suggestions for emotional and mental "healthy living."</p>
                                                                                <br/>
                                                                                <center><img src="images/healthy.jpg" width="400" height="400" border="0" align="middle"/></center>
                                                                                <br/> <br/>
                                                                                  <div class="w3-panel w3-gray w3-leftbar w3-rightbar w3-border-black">
                                                                                          <p>You can reduce the risk of diseases like <b><i><%=responseString%></i></b> if you follow a healthy life style </p>

                                                                                  </div>
                                                                                <br/>
                                                                            </div>

                                                                    </div>
                                        <%
                                                    } catch (Exception e) {
                                        %>
                                                        <u><b>Error</b></u>
                                                        <div style="text-indent: 50px">An error occurred while calling
                                                            the micro service: <%=e.getMessage()%> <br/></div>
                                        <%
                                                    }
                                                } else {
                                                    if(accessToken != null){
                                        %>
                                                        <a href="token">Request OAuth2 Access Token and send to micro service</a><br/>
                                        <%

                                                    }
                                                }
                                        %>
                        </tr>


                        </tbody>
                    </table>

                </form>


            <%} else { %>
            <div>
                <form action="oauth2-access-resource.jsp" id="loginForm" method="post">

                    <table class="user_pass_table">
                        <tbody>
                        <tr>
                            <td><label>Access Token :</label></td>
                            <td><input id="accessToken" name="accessToken" style="width:350px" value="<%=accessToken%>"/>
                        </tr>
                        <% if (application.getInitParameter("setup").equals("AM")) { %>
                        <tr>
                            <td><label>Resource URL :</label></td>
                            <td><input id="resource_url" name="resource_url" type="text" style="width:350px"/>
                        </tr>
                        <% } %>
                        <tr>
                            <td><label>Introspection Endpoint :</label></td>
                            <td><input id="resource_url" name="resource_url" type="text" style="width:350px"/>
                        </tr>
                        <tr>
                            <td>
                                <input type="submit" class="button" value="Get TokenInfo">
                            </td>
                        </tr>
                        </tbody>
                    </table>

                </form>
            </div>
            <%} %>

            <% } else if (grantType != null && OAuth2Constants.OAUTH2_GRANT_TYPE_IMPLICIT.equals(grantType)) {%>
            <div>
                <form action="oauth2-access-resource.jsp" id="loginForm" method="post">

                    <table class="user_pass_table">
                        <tbody>
                        <tr>
                            <td><label>Access Token :</label></td>
                            <td><input id="accessToken" name="accessToken" style="width:350px"/>
                                <script type="text/javascript">
                                    document.getElementById("accessToken").value = getAcceesToken();
                                </script>
                        </tr>
                        <% if (application.getInitParameter("setup").equals("AM")) { %>
                        <tr>
                            <td><label>Resource URL :</label></td>
                            <td><input id="resource_url" name="resource_url" type="text" style="width:350px"/>
                        </tr>
                        <% } %>
                        <tr>
                            <td><label>Introspection Endpoint :</label></td>
                            <td><input id="resource_url" name="resource_url" type="text" style="width:350px"/>
                        </tr>
                        <tr>
                            <td>
                                <input type="submit" class="button" value="Get TokenInfo">
                            </td>
                        </tr>
                        </tbody>
                    </table>

                </form>

            </div>
            <% } %>
        </td>
    </tr>
</table>
<script type="text/javascript">
    function togglePKCEMethod() {
        var radios = document.getElementsByName('code_challenge_method');
        var pkceMethod = "";
        for (var i = 0, length = radios.length; i < length; i++) {
            if (radios[i].checked) {
                pkceMethod = radios[i].value;
                break;
            }
        }
        var pkceChallenge = document.getElementsByName("code_challenge")[0];
        console.log(pkceMethod + " " + pkceChallenge.value);
        if (pkceMethod == "S256") {
            pkceChallenge.value = "<%=code_challenge%>";
        } else if (pkceMethod == "plain") {
            pkceChallenge.value = "<%=code_verifier%>";
        }
    }

    function pkceChangeVisibility(jQuery ) {
        if ($("#grantType").val() == "<%=OAuth2Constants.OAUTH2_GRANT_TYPE_CODE%>" &&
                $("input[name='use_pkce']:checked")[0].value == "yes") {
            $("#pkceMethod").show();
            $("#pkceChallenge").show();
            $("#pkceVerifier").show();


            $("input[name='code_challenge_method']")[0].removeAttribute('disabled');
            $("input[name='code_challenge_method']")[1].removeAttribute('disabled');
            $("input[name='code_challenge']")[0].removeAttribute('disabled');
        } else {
            $("#pkceMethod").hide();
            $("#pkceChallenge").hide();
            $("#pkceVerifier").hide();
            $("#pkceOption").hide();

            $("input[name='code_challenge_method']")[0].setAttribute('disabled', true);
            $("input[name='code_challenge_method']")[1].setAttribute('disabled', true);
            $("input[name='code_challenge']")[0].setAttribute('disabled', true);
        }
        if ($("#grantType").val() == "<%=OAuth2Constants.OAUTH2_GRANT_TYPE_CODE%>") {
            $("#pkceOption").show();
        }
    }

    $( document ).ready(pkceChangeVisibility);
    //set form change handler.
    $("form[name='oauthLoginForm']").change(pkceChangeVisibility)
</script>
<%
    if (isOIDCSessionEnabled) {
%>
<iframe id="rpIFrame" src="rpIFrame.jsp" frameborder="0" width="0" height="0"></iframe>
<%
    }
%>

</body>
</html>