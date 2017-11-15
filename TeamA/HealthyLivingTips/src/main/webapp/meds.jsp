<!--
~ Copyright (c) WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
~
~ WSO2 Inc. licenses this file to you under the Apache License,
~ Version 2.0 (the "License"); you may not use this file except
~ in compliance with the License.
~ You may obtain a copy of the License at
~
~    http://www.apache.org/licenses/LICENSE-2.0
~
~ Unless required by applicable law or agreed to in writing,
~ software distributed under the License is distributed on an
~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
~ KIND, either express or implied.  See the License for the
~ specific language governing permissions and limitations
~ under the License.
-->
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.bean.LoggedInSessionBean" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.bean.SSOAgentConfig" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.SSOAgentConstants" %>
<%@ page import="org.apache.commons.httpclient.HttpClient" %>
<%@ page import="org.apache.commons.httpclient.methods.GetMethod" %>




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


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
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
%>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/cart-styles.css">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <title>Medicine Stock</title>
</head>

<body>
<div id="container">

          <div id="header-area">
                    <h2> <b> Deadliest Disease in Sri Lanka</b> </h2>
          </div>
          <div>
                                                  	    <%
                                                                      if(accessToken != null) {
                                                              %>
                                                                          <u><b>Your OAuth2 Access Token details</b></u>
                                                                          <div style="text-indent: 50px">Token Type:  <br/></div>
                                                                          <div style="text-indent: 50px">Expiry In:   <br/></div>
                                                              <%
                                                                          // Creates an HTTP REST call to micro service
                                                                          // Create an instance of HttpClient.
                                                                          HttpClient client = new HttpClient();
                                                                          String microServiceURL = "http://localhost:8081/hello/";

                                                                          // Create a method instance.
                                                                          GetMethod method = new GetMethod(microServiceURL + "admin");
                                                                          method.setRequestHeader("X-JWT-Assertion", accessToken);


                                                                          try {
                                                                              client.executeMethod(method);
                                                                              byte[] responseBody = method.getResponseBody();
                                                                              String responseString = new String(responseBody);
                                                              %>
                                                                              <u><b>Micro service details</b></u>
                                                                              <div style="text-indent: 50px">Micro service URL: <%=microServiceURL%> <br/></div>
                                                                              <div style="text-indent: 50px">OIDC is working too, Response from micro service is :- <%=responseString%> <br/></div>
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
                                              </div>
          <div style="text-indent: 50px">
                        <br/>
                       <!--<p style="font-size:20px" >WHO | <b><i><%=responseString%></i></b> is the most Deadliest Disease as per the records of <span id="time"></span></p> -->
                        <p style="font-size:16px" > The deadliest disease in Sri Lanka, as at 2016 WHO records, is coronary artery disease (CAD). Also called ischemic heart disease, CAD occurs when the blood vessels that supply blood to the heart become narrowed. Untreated CAD can lead to chest pain, heart failure, and arrhythmias. Although it’s still the leading cause of death, mortality rates have declined in many European countries and in the United States. This may be due to better public health education, access to healthcare, and forms of prevention. However, in many developing nations, mortality rates of CAD are on the rise. An increasing life span, socioeconomic changes, and lifestyle risk factors play a role in this rise.</p>
                        <br/>
                        <center><img src="images/heart.jpg" width="400" height="400" border="0" align="middle"/></center>
                        <br/> <br/>
                          <div class="w3-panel w3-gray w3-leftbar w3-rightbar w3-border-black">
                                  <p>WHO | <b><i><%=responseString%></i></b> is the most Deadliest Disease as per the records of <span id="time"></span></p>
                                  <p style="font-size:16px">  <b> Antiplatelet </b> is the most recommended medicine for heart disease </p>
                          </div>
                        <br/>
                    </div>

            </div>

</div>
    <div id="footer-area">
        <p>©2017 XYZ Pharmacy</p>
    </div>



</body>
</html>