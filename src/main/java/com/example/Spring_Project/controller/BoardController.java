package com.example.Spring_Project.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/board")
public class BoardController {

    @RequestMapping("/toBoard") // 커뮤니티로 이동
    public String toBoard() throws Exception{
        return "/board/main";
    }

    @RequestMapping("/toWriteForm")  //글 작성 폼으로 이동
    public String toWriteForm() throws Exception{
        return "/board/writeForm";
    }
}

