package com.example.Spring_Project;

import com.example.Spring_Project.dto.LogDTO;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;

@Slf4j
@Aspect
@Component
public class LogAspect {
//    @Autowired
//    private MemberService memberService;
//
//    @Autowired
//    private LogService logService;
//
//    @Autowired
//    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @AfterThrowing(value = "execution( * com.example.Spring_Project.*.*.*(..))", throwing = "ex")
    public void afterThrowing(JoinPoint joinPoint, Throwable ex) throws Exception {
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
//        logService.insertLog(logDTO); //에러 로그 저장
    }

    @AfterReturning(value = "execution(* com.example.Spring_Project.*.*(..))", returning = "returnValue")
    public void writeSuccessLog(JoinPoint joinPoint, Object returnValue) throws RuntimeException {
        //logging
        //returnValue 는 해당 메서드의 리턴객체를 그대로 가져올 수 있다.
        System.out.println("TEST");
    }

}

//    @Around("execution(* com.example.Spring_Project.service.MemberService.*(String,String)) && args(id,pw)")
//    public Object logging(ProceedingJoinPoint proceedingJoinPoint, String id, String pw) throws Throwable {
//        Object result = proceedingJoinPoint.proceed();
//        log.info("==> LogAspect Root:: " + proceedingJoinPoint.getSignature().getDeclaringTypeName());
//        log.info("==> LogAspect Method:: " + proceedingJoinPoint.getSignature().getName());
//        MemberDTO memberDTO = memberService.memberInfo(id);
//        if (!bCryptPasswordEncoder.matches(pw, memberDTO.getPw()) || logService.loginCheck(id, memberDTO.getPw()) != 1) {
//            String type = "Login Fail";
//            String parameter = id + ", " + pw;
//            String url = "/member/login";
//            String description = id+" : 로그인에 실패했습니다.";
//            LogDTO logDTO = new LogDTO();
//            logDTO.setType(type);
//            logDTO.setParameter(parameter);
//            logDTO.setUrl(url);
//            logDTO.setDescription(description);
//            logService.insertLog(logDTO); //에러 로그 저장
//            log.info("==> ID 또는 PW가 일치하지 않습니다.");
//        }


