//package com.example.Spring_Project;
//
//import lombok.RequiredArgsConstructor;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.Lifecycle;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
//import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
//
//@Configuration
//@RequiredArgsConstructor
//public class WebConfig implements WebMvcConfigurer {
//
//    @Autowired
//    private LoginInterceptor loginInterceptor;
//
//    public void addInterceptors(InterceptorRegistry registry) {
//        registry.addInterceptor(loginInterceptor)
//                .addPathPatterns("/**")
//                .addPathPatterns("/resources/img/**")
//                .excludePathPatterns("/")
//                .excludePathPatterns("/member/toSignUpForm")
//                .excludePathPatterns("/member/login")
//                .excludePathPatterns("/member/logout")
//                .excludePathPatterns("/member/toSearchIdForm")
//                .excludePathPatterns("/member/toSearchPwForm")
//                .excludePathPatterns("/member/searchId")
//                .excludePathPatterns("/member/searchPw")
//                .excludePathPatterns("/member/signUp")
//        ;
//    }
//}
