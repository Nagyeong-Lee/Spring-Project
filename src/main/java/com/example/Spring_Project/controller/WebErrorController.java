package com.example.Spring_Project.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

@Controller
public class WebErrorController implements ErrorController {

    @GetMapping("/error")
    public String HandleError(HttpServletRequest request) throws Exception {
        String result = "";
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        if (status != null) {
            Integer errorCode = Integer.parseInt(status.toString());

            if (errorCode == HttpStatus.NOT_FOUND.value()) {
                result = "/error/404error";
            } else {
                result = "/error/error";
            }
        }
        return result;
    }
}
