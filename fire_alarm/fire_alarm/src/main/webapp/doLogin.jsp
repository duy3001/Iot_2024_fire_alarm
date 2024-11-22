<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="feyd.tengen.fire_alarm.dao.userDAO" %>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    userDAO dao = new userDAO();
    HttpSession httpSession = request.getSession();
    try {
        Object user = dao.checkLogin(username, password);

        if (user != null) {
            session.setAttribute("user", user);
            response.sendRedirect("listDevice.jsp");
        } else {
            // Đưa ra thông báo lỗi nếu đăng nhập thất bại
            //out.print("<p>Username hoặc password không đúng. Vui lòng thử lại.</p>");
        }
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>
