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
    <script>
    $('.message a').click(function(){
       $('form').animate({height: "toggle", opacity: "toggle"}, "slow");
    });
    </script>
</head>
<body>
<div id="container">
<div class="login-page">
<h1 style="text-align:center">Insurance App</h1>
  <div class="form">
    <form class="login-form" method="post" action="samlsso?SAML2.HTTPBinding=HTTP-POST">
      <input type="text" placeholder="username" name="username" value="username">
      <input type="password" placeholder="password" name="password" value="password">
      <input type="submit" value="Log In">
    </form>
  </div>
</div>
</div>
</body>
</html>