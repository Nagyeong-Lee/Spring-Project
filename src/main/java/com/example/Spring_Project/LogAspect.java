package com.example.Spring_Project;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.service.LogService;
import com.example.Spring_Project.service.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
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

//    @Around("within(com.example.Spring_Project.service.MemberService*.doLogin(String,String)) && args())")
//    public Object logging(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
//        Object result = proceedingJoinPoint.proceed();
//        log.info("==> LogAspect Root:: " + proceedingJoinPoint.getSignature().getDeclaringTypeName());
//        log.info("==> LogAspect Method:: " + proceedingJoinPoint.getSignature().getName());
//
//        if (proceedingJoinPoint.getSignature().getName().equals("login")) {
//            String id = memberService.memberInfo(proceedingJoinPoint.getSignature().);
//        }
//        return result;
//    }

    @Around("within(com.example.Spring_Project.service.MemberService) && args(id,pw)")
    public Object logging(ProceedingJoinPoint proceedingJoinPoint, String id, String pw) throws Throwable {
        Object result = proceedingJoinPoint.proceed();
        log.info("==> LogAspect Root:: " + proceedingJoinPoint.getSignature().getDeclaringTypeName());
        log.info("==> LogAspect Method:: " + proceedingJoinPoint.getSignature().getName());

        System.out.println("ID : " + id);
        System.out.println("PW : " + pw);

        if (proceedingJoinPoint.getSignature().getName().equals("login")) {

            MemberDTO dto = memberService.memberInfo(id);
            Integer count = logService.isIdExist(dto.getId());
            if (count != 1) {
                logService.insertLog(dto.getId());
            }
        }
        return result;
    }
}