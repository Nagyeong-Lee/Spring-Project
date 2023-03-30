package com.example.Spring_Project;

import com.example.Spring_Project.dto.LogDTO;
import com.example.Spring_Project.service.LogService;
import com.example.Spring_Project.service.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Slf4j
@Aspect
@Component
public class LogAspect {
    @Autowired
    private MemberService memberService;

    @Autowired
    private LogService logService;

    @AfterThrowing(pointcut = "execution(* com.example.Spring_Project.service.*.*(..))", throwing = "Exception")
    public void afterThrowing(JoinPoint joinPoint, Throwable Exception) throws Exception {
        System.out.println("===========================aop=====================");
        log.info("==> LogAspect Root:: " + joinPoint.getSignature().getDeclaringTypeName());
        log.info("==> LogAspect Method:: " + joinPoint.getSignature().getName());
        String type = "Exception";
        String parameter = joinPoint.getSignature().getName();
        String url = parameter;
        String description = parameter + " Exception";
        LogDTO logDTO = new LogDTO();
        logDTO.setType(type);
        logDTO.setParameter(parameter);
        logDTO.setUrl(url);
        logDTO.setDescription(description);
        System.out.println(type);
        System.out.println(parameter);
        System.out.println(url);
        System.out.println(description);
        logService.insertLog(logDTO); //에러 로그 저장
    }


    @AfterReturning(value = "execution(* com.example.Spring_Project.*.*(..))", returning = "returnValue")
    public void writeSuccessLog(JoinPoint joinPoint, Object returnValue) throws RuntimeException {
//        System.out.println("TEST");
    }


}


