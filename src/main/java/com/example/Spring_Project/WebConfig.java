package com.example.Spring_Project;

import com.example.Spring_Project.service.BatchScheduler;
import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@RequiredArgsConstructor
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private LoginInterceptor loginInterceptor;

    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                .excludePathPatterns("/")
                .excludePathPatterns("/api/dataByMonth")
                .excludePathPatterns("/api/data")
                .excludePathPatterns("/api/hospital")
                .excludePathPatterns("/member/index")
                .excludePathPatterns("/member/signUp")
                .excludePathPatterns("/member/active")
                .excludePathPatterns("/member/login")
                .excludePathPatterns("/resources/**")
                .excludePathPatterns("/member/toSignUpForm")
                .excludePathPatterns("/member/toSearchIdForm")
                .excludePathPatterns("/member/toSearchPwForm")
                .excludePathPatterns("/member/searchId")
                .excludePathPatterns("/member/searchPw")
                .excludePathPatterns("/member/idDupleCheck")
                .excludePathPatterns("/member/emailDupleCheck")
                .excludePathPatterns("/mail")
                .excludePathPatterns("/member/emailExist") //인터셉터가 동작하지않을 url 패턴
                .addPathPatterns("/**"); //인터셉터가 동작할 url 패턴
    }
}
