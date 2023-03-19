package com.example.Spring_Project.interceptor;

import com.example.Spring_Project.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Component
public class LoginInterceptor implements HandlerInterceptor {

    @Autowired
    private HttpSession session;

    @Autowired
    private MemberService service;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        String uri = request.getRequestURI();
        String idSession = (String) session.getAttribute("id");
        String type = String.valueOf(service.getUserType(idSession));


        if (type == null) {
            if (uri.startsWith("/member")
                    || uri.startsWith("/board")
                    || uri.startsWith("/admin")
                    || uri.startsWith("/comment")
                    || uri.startsWith("/file")
            ) {
                response.sendRedirect("/");
                return false;
            }
        } else if (type.equals("1")) { // 회원
            if (uri.startsWith("/admin")) {
                response.sendRedirect("/");
                return false;
            }
        }
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        HandlerInterceptor.super.postHandle(request, response, handler, modelAndView);
    }
}
