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
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/home-styles.css">
    <title>Doctors Home</title>
</head>
<%
    String claimedId = null;
    String subjectId = null;
    Map<String, List<String>> openIdAttributes = null;
    Map<String, String> saml2SSOAttributes = null;
    if(request.getSession(false) != null &&
            request.getSession(false).getAttribute(SSOAgentConstants.SESSION_BEAN_NAME) == null){
        request.getSession().invalidate();
%>
        <script type="text/javascript">
        location.href = "index.jsp";
        </script>
<%
        return;
    }
    SSOAgentConfig ssoAgentConfig = (SSOAgentConfig)getServletContext().getAttribute(SSOAgentConstants.CONFIG_BEAN_NAME);
    LoggedInSessionBean sessionBean = (LoggedInSessionBean)session.getAttribute(SSOAgentConstants.SESSION_BEAN_NAME);
    LoggedInSessionBean.AccessTokenResponseBean accessTokenResponseBean = null;

    if(sessionBean != null){
        if(sessionBean.getOpenId() != null) {
            claimedId = sessionBean.getOpenId().getClaimedId();
            openIdAttributes = sessionBean.getOpenId().getSubjectAttributes();
        } else if(sessionBean.getSAML2SSO() != null) {
            subjectId = sessionBean.getSAML2SSO().getSubjectId();
            saml2SSOAttributes = sessionBean.getSAML2SSO().getSubjectAttributes();
            accessTokenResponseBean = sessionBean.getSAML2SSO().getAccessTokenResponseBean();
        } else {
%>
            <script type="text/javascript">
                location.href = "index.jsp";
            </script>
<%
            return;
        }
    } else {
%>
        <script type="text/javascript">
            location.href = "index.jsp";
        </script>
<%
        return;
    }
%>
<body>
<div>
    <div id="header-area">
        <h1> <img src="images/doctor.png" alt="Logo" vspace="10" /> Medicare Doctors Home </h1>

    </div>
    <div id="content-area">
        <hr />
        <div class="product-box">
            <%
                if(subjectId != null){
            %>
                    <h2> You are logged in as Dr. <%=subjectId%></h2>
            <%
                } else if (claimedId != null) {
            %>
                    <h2> You are logged in as <%=claimedId%></h2>
            <%
                }
            %>

            <h3> See Patient Details </h3>
            <a class="patient-view" href="patients.jsp"> </a>
            <hr />

            <h3> See Appointment Details </h3>
            <a class="appointment-view" href="appointments.jsp"> </a>
            <hr />

            <a href="http://192.168.48.131:8080/insurance.com"> View Insurance </a>
            &nbsp;&nbsp;&nbsp;&nbsp;<a href="index.jsp">Go to Login page</a><br/>
            <table>
                <%
                    if(saml2SSOAttributes != null){
                        for (Map.Entry<String, String> entry:saml2SSOAttributes.entrySet()) {
                %>
                            <tr>
                                <td><%=entry.getKey()%></td>
                                <td><%=entry.getValue()%></td>
                            </tr>
                <%
                        }
                    } else if (openIdAttributes != null) {
                        for(Map.Entry<String, List<String>> entry:openIdAttributes.entrySet()) {
                %>
                            <tr>
                                <td><%=entry.getKey()%></td>
                                <td>
                                    <%
                                        Iterator it = entry.getValue().iterator();
                                        if(it.hasNext()){
                                    %>
                                            <%=it.next().toString()%>
                                    <%
                                        }
                                    %>
                                </td>
                            </tr>
                <%
                        }
                    }
                %>
            </table>
            <%
                if (subjectId != null) {
                    if(accessTokenResponseBean != null) {
            %>
                        <u><b>Your OAuth2 Access Token details</b></u>
                        <div style="text-indent: 50px">Token Type: <%=accessTokenResponseBean.getTokenType()%> <br/></div>
                        <div style="text-indent: 50px">Access Token: <%=accessTokenResponseBean.getAccessToken()%> <br/></div>
                        <div style="text-indent: 50px">Refresh Token: <%=accessTokenResponseBean.getRefreshToken()%> <br/></div>
                        <div style="text-indent: 50px">Expiry In: <%=accessTokenResponseBean.getExpiresIn()%> <br/></div>
            <%
                    } else {
                        if(ssoAgentConfig.isOAuth2SAML2GrantEnabled()){
            %>
                            <a href="token">Request OAuth2 Access Token</a><br/>
            <%

                        }
                    }
                }
            %>

        </div>
    </div>
    <div id="footer-area">
        <p>©2017 TeamC</p>
    </div>
</div>
</body>
</html>