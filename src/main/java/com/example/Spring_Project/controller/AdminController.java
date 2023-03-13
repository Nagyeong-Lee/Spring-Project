package com.example.Spring_Project.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @RequestMapping("/main")
    public String tomemberChart() throws Exception{
        return "/admin/memberChart";
    }

}
