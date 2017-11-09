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
    <link rel="stylesheet" type="text/css" href="css/cart-styles.css">
    <title>User Logged out</title>
</head>
<body>
<div id="container">
    <div id="header-area" style="width:125%">
        <img src="images/Hospital_banner.png" alt="Logo" />
    </div>
    <div id="content-area">

        <table cellpadding="0" cellspacing="0" border="0" class="cart-expbox">
            <tr>
                <td></td>
                <td class="cart-expbox-02">&nbsp</td>
                <td></td>
            </tr>
            <tr>
                <td class="cart-expbox-08"></td>
                <td class="cart-expbox-09">
                    <!--all content for cart and links goes here-->
                </td>
                <td class="cart-expbox-04"></td>
            </tr>
            <tr>
                <td></td>
                <td class="cart-expbox-06">&nbsp</td>
                <td></td>
            </tr>

        </table>
        <h1 cellspacing='10px'>Hospital Management System</h1>
        <hr />
        <div class="product-box">
        <table cellpadding="0" cellspacing="0" border="0">
            <tr height="15px">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</tr>
            <tr>
                <td width="420px" >&nbsp</td>
                <td class="admitted">
                    <a href="index.jsp">
                         <img src="images/landing_admitted.jpg" alt="Logo" width="410px"/>
                    </a>

                </td>
                <td width="150px" >&nbsp</td>
                <td class="opd"><img src="images/landing_OPD.jpg" alt="Logo" width="410px" /></td>
            </tr>
            <tr height="45px">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</tr>


        </table>




        </div>
    </div>
    <div id="footer-area">
        <p>©2017 Solutions Test Lab</p>
    </div>
</div>
</body>
</html>