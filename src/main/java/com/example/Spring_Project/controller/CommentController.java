package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.CommentDTO;
import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.mapper.MemberMapper;
import com.example.Spring_Project.service.CommentService;
import com.example.Spring_Project.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.sound.midi.Soundbank;

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

    @ResponseBody
    @PostMapping("/reply")
    public String reply(@RequestParam String writer, @RequestParam String content, @RequestParam Integer b_seq,
                        @RequestParam Integer parent_cmt_seq) throws Exception{

        System.out.println("writer : "+writer);
        System.out.println("content : "+content);
        System.out.println("b_seq : "+b_seq);
        System.out.println("parent_cmt_seq : "+parent_cmt_seq);
        service.reply(writer,content,b_seq,parent_cmt_seq);
        return "완";
    }

//    @RequestMapping("/deleteCmt") //댓글 삭제되면 대댓글 까지 모두 삭제
//    public String deleteComment(@RequestParam Integer cmt_seq) throws Exception{
//        System.out.println("cmt_seq : "+cmt_seq);
//        service.deleteCommnet(cmt_seq);
//        return 'd';
//    }
}
