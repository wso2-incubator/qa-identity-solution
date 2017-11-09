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
    <link rel="stylesheet" type="text/css" href="css/cart-styles.css">
    <title>WSO2</title>
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
<style>
h1{
    text-indent: 510px;
    margin-top: 20px;
}

    footer {
        position: fixed;
        height: 40px;
        bottom:0px;
        width: 100%;
        background-color: #333333;
    }

    p.copyright {
        position: absolute;
        width: 100%;
        color: #fff;
        line-height: 20px;
        font-size: 0.7em;
        text-align: center;
        bottom:10;
    }
</style>
<body>
<div>
    <div>
        <h1>Welcome to Authority User Page</h1>
        <div class="text-center">
            <%
                if(subjectId != null){
            %>
                    <h4> You are logged in as <%=subjectId%></h4>
            <%
                } else if (claimedId != null) {
            %>
                    <h4> You are logged in as <%=claimedId%></h4>
            <%
                }
            %>

            <a href="CriticalDisease.html" class="button-style mar-b-5">View Critical Disease List</a> <br />
            <a href="ToxicDoses.html" class="button-style">View Toxic Doses</a>


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

            <%
                if(subjectId != null && ssoAgentConfig.getSAML2().isSLOEnabled()){

                }
            %>
        </div>
    </div>
<footer>
    <p class="copyright">© XYZ Pharmacy 2017</p>
</footer>
</div>
</body>
</html>