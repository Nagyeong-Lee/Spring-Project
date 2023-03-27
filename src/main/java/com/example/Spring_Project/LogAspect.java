package com.example.Spring_Project;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.service.LogService;
import com.example.Spring_Project.service.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;


@Slf4j
@Aspect
@Component
public class LogAspect {
    @Autowired
    private MemberService memberService;

    @Autowired
    private LogService logService;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Around("execution(* com.example.Spring_Project.service.MemberService.*(String,String)) && args(id,pw)")
    public Object logging(ProceedingJoinPoint proceedingJoinPoint, String id, String pw) throws Throwable {
        Object result = proceedingJoinPoint.proceed();
        log.info("==> LogAspect Root:: " + proceedingJoinPoint.getSignature().getDeclaringTypeName());
        log.info("==> LogAspect Method:: " + proceedingJoinPoint.getSignature().getName());
        MemberDTO memberDTO = memberService.memberInfo(id);
        if (!bCryptPasswordEncoder.matches(pw,memberDTO.getPw()) || logService.loginCheck(id, memberDTO.getPw())!=1) {
            logService.insertLog(id); //에러 로그 저장
            log.info("==> ID 또는 PW가 일치하지 않습니다.");
        }
        return result;
    }

}