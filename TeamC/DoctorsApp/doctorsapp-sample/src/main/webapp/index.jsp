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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.wso2.carbon.identity.sso.agent.bean.SSOAgentConfig" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.SSOAgentConstants" %>
<!DOCTYPE HTML>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/login-styles.css">
    </style>
</head>
<body>
<div id="container">
    <div id="content-area">
  <div id="wrapper">
	<div class="join">Medicare Doctors App</div>
	        <div class="clr"></div>
    	    	<div class="login-options">Choose one of the following Login methods.</div>
                	<a class="yahoo" href="openid?OpenId.ClaimedId=<%=((SSOAgentConfig)getServletContext().getAttribute(SSOAgentConstants.CONFIG_BEAN_NAME)).getOpenId().getProviderURL()%>">Yahoo</a>
                    <a class="facebook" href="samlsso?SAML2.HTTPBinding=HTTP-Redirect">Facebook</a>
                    <a class="google" href="samlsso?SAML2.HTTPBinding=HTTP-Redirect">Google+</a>
                    <div class="clr"><hr /></div>
                    		<div class="mail-text">Or sign up using your email address.</div>
                            		<div class="forms">
                                    <form method="post" action="samlsso?SAML2.HTTPBinding=HTTP-POST">
                                    <input name="email" type="text" value="Enter your email address..." size="60" onClick="border: 1px solid #30a8da;" id="mail" placeholder="Enter your username"/>
                                    <input name="password" type="password" value="Enter a password..." size="60" onClick="border: 1px solid #30a8da;" id="password" placeholder="Enter your password"/>
                                    </form>
                                    </div>
						<a class="create-acc" href="#">Login My Account</a>
                        <div class="clr"><hr /></div>
						<center><a class="create-acc" href="http://192.168.48.131:8080/insurance.com" style="background-color:#C0C0C0; display:inline-block;width:400px;">Insurance app</a></center>

</div>

</body>
</html>