package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.CommentDTO;
import com.example.Spring_Project.service.CommentService;
import com.example.Spring_Project.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private CommentService service;

    @Autowired
    private HttpSession session;

    @ResponseBody
    @PostMapping("/insert") //댓글 insert
    public Integer insert(@RequestParam String content, @RequestParam String writer, @RequestParam Integer b_seq) throws Exception {

        CommentDTO commentDTO = new CommentDTO();
        commentDTO.setContent(content);
        commentDTO.setWriter(writer);
        commentDTO.setB_seq(b_seq);

        service.insert(commentDTO);

        session.setAttribute("cmtID", writer);

        Integer currVal=service.getCurrentVal();

        return currVal;
    }

    @ResponseBody
    @PostMapping("/reply") //대댓글 insert
    public String reply(@RequestParam String writer, @RequestParam String content, @RequestParam Integer b_seq,
                        @RequestParam Integer parent_cmt_seq) throws Exception {

        service.reply(writer, content, b_seq, parent_cmt_seq);
        return "대댓글 작성 완료";
    }


    @ResponseBody
    @PostMapping("/deleteCmt") //댓글 삭제
    public String deleteComment(@RequestParam Integer cmt_seq) throws Exception {
        Integer parent_cmt_seq = service.getParentSeq(cmt_seq);
        service.deleteCmt(cmt_seq); // status = N으로 변경
        return "댓글 삭제 완료";
    }

    @ResponseBody
    @PostMapping("/updCmt")
    public String updateComment(@RequestParam String content, @RequestParam Integer b_seq, @RequestParam Integer cmt_seq) throws Exception {
        service.updateCmt(content, b_seq, cmt_seq);
        return "댓글 수정 완료";
    }
}
