package com.zy.crm.filter;

import com.zy.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        //Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws ServletException, IOException {
        //chain.doFilter(req, res);
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String contextPath = request.getContextPath();
        String servletPath = request.getServletPath();
        if (servletPath.contains("login")) {
            chain.doFilter(req, res);
        } else {

            User user = (User) request.getSession().getAttribute("user");
            if (user != null) {
                chain.doFilter(req, res);
            } else {
                response.sendRedirect(contextPath + "/login.jsp");
            }


        }
    }
}
