package com.example.Spring_Project.exception;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class Exception {

    @ExceptionHandler(java.lang.Exception.class)
    public String Exception(java.lang.Exception e){
        System.out.println("권한 없음");
        return "/errorPage";
    }

}
