<%-- header.jsp --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>

        <% String _username=(String) session.getAttribute("username"); %>

            <header class="top-header">
                <div class="header-branding">
                    <h1><i class="fa-solid fa-bus"></i> <i>Sani Express</i></h1>
                    <% if (_username !=null) { %>
                        <p>Welcome, <%= _username %>
                        </p>
                        <% } %>
                </div>
                <div class="header-actions">
                    <% if (_username !=null) { %>
                        <a href="logout.jsp" class="header-action-btn">LOG OUT</a>
                        <% } else { %>
                            <a href="login.html" class="header-action-btn" style="font: weight 1000px;">LOGIN</a>
                            <% } %>
                </div>
            </header>