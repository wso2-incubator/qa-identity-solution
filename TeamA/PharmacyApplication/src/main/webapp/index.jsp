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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/redmond/jquery-ui.css" rel="stylesheet" type="text/css"/>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
    <link rel="stylesheet" type="text/css" href="css/cart-styles.css">
    <link href="https://fonts.googleapis.com/css?family=Fenix" rel="stylesheet">
      <script type="text/javascript">
              $(document).ready(function () {
                  $("#fidp-sample").click(function () {
                      $( "#fidp-dialog" ).dialog({
                            resizable: false,
                            height: "auto",
                            width: 400,
                            modal: true,
                            buttons: {
                              "OK": function() {
                                window.location.href = "samlsso?SAML2.HTTPBinding=HTTP-Redirect";
                              },
                              Cancel: function() {
                                        $( this ).dialog( "close" );
                              }
                            }
                      });
                  });
              });
          </script>
    <title>XYZ Pharmacy</title>
</head>
<body>
<div id="container">
    <div id="content-area">
        <div id="header-area">
            <h1>Welcome to XYZ Pharmacy</h1>
        </div>
        <div class="product-box">
            <h2>
            <a id="fidp-sample" href="#">
            <img src="images/medecinestock.png" title="Click to view deadliset diseases" width="128" height="128" border="0"/>
            <span> Deadliest Diseases</span>
            </a>
            </h2>
        </div>
        <div class="product-box">
                    <h2>
                    <a href="#">
                    <img src="images/nurse.png" title="Authoiry User Login" width="128" height="128" border="0"/>
                    <span> Login as Authority User</span>
                    </a>
                    </h2>
        </div>
    </div>
</div>
<div id="fidp-dialog" title="Login via FIDP">
<p>You need to authenticated via Google to view medicine stock. If you wish to proceed, please select the 'OK' button</p>
</div>
    <div id="footer-area">
        <p>©2017 XYZ Pharmacy</p>
    </div>
</body>
</html>