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

<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/cart-styles.css">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <title>Medicine Stock</title>
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
<div id="container">
            <div id="logout-area" style="float:right;">
            <%
            if(subjectId != null){
            %>
                    <p align="left"> You are logged in as <%=subjectId%></p>
            <%
                } else if (claimedId != null) {
            %>
                    <p align="left"> You are logged in as <%=claimedId%></p>
            <%
            }
            %>

            <%
                if(subjectId != null && ssoAgentConfig.getSAML2().isSLOEnabled()){
            %>

            <a id="logout" href="logout?SAML2.HTTPBinding=HTTP-Redirect">
              <img src="images/logout.png" title="Click Log out" border="0"/>
            </a>

            <%
                }
            %>

                                    </div>

            <div id="content-area" style="float:left;">


            <%
            if (subjectId != null && accessTokenResponseBean == null) {
            if(ssoAgentConfig.isOAuth2SAML2GrantEnabled()){
            %>
                <div id="header-area">
                <h2> <b>Top Most Deadliest Diseases</b> </h2>
                </div>
                <br/>
                <p style="font-size:20px" >  Do you know what are the top most Deadliest Diseases? </p>
                <p style="font-size:16px" >When people think of the deadliest diseases in the world, their minds probably jump to the fast-acting, incurable ones that grab headlines from time to time. But in fact, many of these types of diseases don’t rank in the top 10 causes of worldwide deaths. An estimated 56.4 million people passed away worldwide in 2015, and 68 percent of them were due to diseases that progressed slowly</p>
                <p style="font-size:16px">According to World Health Organization (WHO) statistics in 2016, following list of diseases is causing most deaths around world wide</p>
                <%@ include file="DeadliestDiseases.html" %>
                <div class="w3-panel w3-gray w3-leftbar w3-rightbar w3-border-black">
                <p style="font-size:16px"> Do you want the know what is the <a href="token"> <font color="red"> most Deadliest Disease </font></a> in Sir Lanaka as per todays statistic? </p>
                <br/>
                </div>
            <%
                        }
            } else if (subjectId != null && accessTokenResponseBean != null){

            %>

                <%
                // Creates an HTTP REST call to micro service
                // Create an instance of HttpClient.
                HttpClient client = new HttpClient();
                String microServiceURL = "http://localhost:8081/hello/";

                // Create a method instance.
                GetMethod method = new GetMethod(microServiceURL + subjectId);
                method.setRequestHeader("X-JWT-Assertion", accessTokenResponseBean.getAccessToken());


                try {
                    client.executeMethod(method);
                    byte[] responseBody = method.getResponseBody();
                    String responseString = new String(responseBody);
                %>
                    <div id="header-area">
                    <h2> <b> Deadliest Disease in Sri Lanka</b> </h2>
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
                <%
                    } catch (Exception e) {
                %>
                        <u><b>Error Occured</b></u>
                        <div style="text-indent: 50px">An error occurred while calling the micro service: <%=e.getMessage()%> <br/></div>
                <%
                    }

                }

                %>

            </div>
        </div>
    <div id="footer-area">
        <p>©2017 XYZ Pharmacy</p>
    </div>

    <script type="text/javascript">
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth()+1; //January is 0!

    var yyyy = today.getFullYear();
    if(dd<10){
        dd='0'+dd;
    }
    if(mm<10){
        mm='0'+mm;
    }
    var today = dd+'/'+mm+'/'+yyyy;
    document.getElementById("time").innerHTML=today;
    </script>

</body>
</html>