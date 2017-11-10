
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.bean.LoggedInSessionBean" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.bean.SSOAgentConfig" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.SSOAgentConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>insuranceapp</title>

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
        <script>
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
            <script>
                location.href = "index.jsp";
            </script>
<%
            return;
        }
    } else {
%>
        <script>
            location.href = "index.jsp";
        </script>
<%
        return;
    }
%>

<body bgcolor="#00FF00">

<!-- webpage content goes here in the body -->

	<div id="page">
		<div id="logo">
			<h1><a href="#" id="logoLink">Welcome to Insurance App</a></h1>
		</div>
		<div id="nav">
			<ul>
				<li><a href="#/home.html">Home</a></li>
				<li><a href="#/about.html">About</a></li>
				<li><a href="#/contact.html">Contact</a></li>
			</ul>
		</div>
		<div id="content">
			<h2>Home</h2>
			<p>
				You can view all your insurance details from here
			</p>

		</div>
		<div id="footer">
			<h1>
				Direct to Doctors App <a href="http://192.168.48.131:8080/doctorsapp.com/index.jsp" target="_blank">[Doctors App]</a>
			</h1>
		</div>
	</div>
</body>














































