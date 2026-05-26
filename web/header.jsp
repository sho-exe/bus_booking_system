<%-- header.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    /* Header Specific CSS */
    .top-header {
        background-color: #cc2525; /* Sani Express Red */
        color: white;
        padding: 15px 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    .header-branding h1 {
        margin: 0;
        font-size: 22px;
        font-weight: bold;
    }
    .header-branding p {
        margin: 2px 0 0 0;
        font-size: 13px;
        font-weight: 300;
    }
    .header-action-btn {
        background-color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 6px;
        cursor: pointer;
    }
</style>

<header class="top-header">
    <div class="header-branding">
        <h1>Sani Express</h1>
        
        <p>Welcome, ${username} </p> </div>
    <div class="header-actions">
        <a style="text-decoration: none; color: black; font-weight: bold" href="login.html" class="header-action-btn" style="font-weight:bold">LOG OUT</a>
    </div>
</header>