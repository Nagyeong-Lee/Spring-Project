package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.CommentDTO;
import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.mapper.MemberMapper;
import com.example.Spring_Project.service.CommentService;
import com.example.Spring_Project.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private CommentService service;

    @ResponseBody     //댓글 insert
    @PostMapping("/insert")
    public CommentDTO insert(@RequestParam String content, @RequestParam String writer, @RequestParam Integer b_seq) throws Exception {

        CommentDTO commentDTO = new CommentDTO();
        commentDTO.setContent(content);
        commentDTO.setWriter(writer);
        commentDTO.setB_seq(b_seq);

        service.insert(commentDTO);
        return commentDTO;
    }
}
