package com.example.Spring_Project;

import com.example.Spring_Project.dto.LogDTO;
import com.example.Spring_Project.service.LogService;
import com.example.Spring_Project.service.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Method;
import java.util.Arrays;

@Slf4j
@Aspect
@Component
public class LogAspect {
    @Autowired
    private MemberService memberService;

    @Autowired
    private LogService logService;

    @Autowired
    private HttpServletRequest request;

    @AfterThrowing(pointcut = "execution(* com.example.Spring_Project.service.*.*(..))", throwing = "Exception")
    public void afterThrowing(JoinPoint joinPoint, Throwable Exception) throws Exception {
        log.info("==> LogAspect Root:: " + joinPoint.getSignature().getDeclaringTypeName());
        log.info("==> LogAspect Method:: " + joinPoint.getSignature().getName());
        String type = "Exception";
        String parameter=joinPoint.getSignature().getName();
        String description = parameter + " Exception";
        LogDTO logDTO = new LogDTO();
        logDTO.setId(parameter);
        logDTO.setType(type);
        logDTO.setParameter(parameter);
        logDTO.setUrl(request.getRequestURI());
        logDTO.setDescription(description);
//        logService.insertLog(logDTO); //에러 로그 저장
    }


    @AfterReturning(value = "execution(* com.example.Spring_Project.*.*(..))", returning = "returnValue")
    public void writeSuccessLog(JoinPoint joinPoint, Object returnValue) throws RuntimeException {
//        System.out.println("TEST");
    }


}


