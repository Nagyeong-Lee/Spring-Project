package com.example.Spring_Project;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

import java.util.logging.Logger;

@Slf4j
@Aspect
@Component
public class LogAspect {

 
    @Around("within(com.example.Spring_Project..*)")
    public Object logging(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
        Object result = proceedingJoinPoint.proceed();
        log.info("==> LogAspect Root:: " + proceedingJoinPoint.getSignature().getDeclaringTypeName());
        log.info("==> LogAspect Method:: " + proceedingJoinPoint.getSignature().getName());
        return result;
    }
}
