package com.example.Spring_Project.controller;

import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Controller
@RequestMapping("/QnA")
public class QnAController {
    
    @PostMapping("") //QnA 작성 팝업
    public String openPopup(@RequestParam Map<String,Object> param) throws Exception{
        System.out.println("param = " + param);
        //question insert

       return "/product/QnA/QnApopup";
    }
}
