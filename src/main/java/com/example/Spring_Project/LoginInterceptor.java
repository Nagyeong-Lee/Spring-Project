//package com.example.Spring_Project;
//
//import com.example.Spring_Project.service.MemberService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//import org.springframework.web.servlet.HandlerInterceptor;
//import org.springframework.web.servlet.ModelAndView;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//@Component
//public class LoginInterceptor implements HandlerInterceptor {
////    @Autowired
////    private HttpSession session;
//    @Autowired
//    private MemberService service;
//
//    @Override
//    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
//        HttpSession session = request.getSession();
//        String uri = request.getRequestURI();
//        String id = (String) session.getAttribute("id");
//        HttpSession sessionIn = request.getSession();
//        String id2 = (String) sessionIn.getAttribute("id");
//        String type = String.valueOf(service.getUserType(id));
//        String type2 = String.valueOf(service.getUserType(id2));
//        boolean result = true;
//        if (type == null) {
//            if (uri.equals("/member/logout")
//                    || uri.equals("/member/delete")
//                    || uri.equals("/member/update")
//                    || uri.equals("/member/searchId")
//                    || uri.equals("/member/searchIdForm")
//                    || uri.startsWith("/board")
//                    || uri.startsWith("/admin")
//                    || uri.startsWith("/comment")
//                    || uri.startsWith("/file")
//            ) {
//                response.sendRedirect("/");
//                result = false;
//            }
//        } else if (type.equals("ROLE_MEMBER")) { // 회원
//            if (uri.startsWith("/admin")) {
//                response.sendRedirect("/");
//                result = false;
//            }
//        } else if (type.equals("ROLE_ADMIN")) {
//            result = true;
//        }
//        return result;
//    }
//
//    @Override
//    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
//        HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
//    }
//
//    @Override
//    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
//        HandlerInterceptor.super.postHandle(request, response, handler, modelAndView);
//    }
//}