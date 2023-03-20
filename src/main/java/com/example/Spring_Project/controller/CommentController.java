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

import javax.servlet.http.HttpSession;
import javax.sound.midi.Soundbank;

@Controller
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private CommentService service;

    @Autowired
    private HttpSession session;

    @ResponseBody     //댓글 insert
    @PostMapping("/insert")
    public CommentDTO insert(@RequestParam String content, @RequestParam String writer, @RequestParam Integer b_seq) throws Exception {

        CommentDTO commentDTO = new CommentDTO();
        commentDTO.setContent(content);
        commentDTO.setWriter(writer);
        commentDTO.setB_seq(b_seq);

        service.insert(commentDTO);

        session.setAttribute("cmtID", writer);
        return commentDTO;
    }

    @ResponseBody
    @PostMapping("/reply")
    public String reply(@RequestParam String writer, @RequestParam String content, @RequestParam Integer b_seq,
                        @RequestParam Integer parent_cmt_seq) throws Exception {

        System.out.println("writer : " + writer);
        System.out.println("content : " + content);
        System.out.println("b_seq : " + b_seq);
        System.out.println("parent_cmt_seq : " + parent_cmt_seq);
        service.reply(writer, content, b_seq, parent_cmt_seq);
        return "완";
    }


    @ResponseBody
    @PostMapping("/deleteCmt") //댓글 삭제
    public String deleteComment(@RequestParam Integer cmt_seq) throws Exception {
        System.out.println("cmt_seq : " + cmt_seq);
        Integer parent_cmt_seq = service.getParentSeq(cmt_seq);
        service.deleteCmt(cmt_seq); // status = n으로
//        if (parent_cmt_seq != 0) {
//            Integer nextCmtSeq = service.getNextCmtSeq();
//            boolean isCmtSeqExist=service.isCmtSeqExist();
//            while(nextCmtSeq ){
//                service.deleteCmt(cmt_seq);
//            }
//        } else if (parent_cmt_seq == 0) {
//            service.deleteCmt(cmt_seq);
//            service.deleteAllCmt(cmt_seq);
//        }
        return "댓글 삭제 완료";
    }

    @ResponseBody
    @PostMapping("/updCmt")
    public String updateComment(@RequestParam String content, @RequestParam Integer b_seq, @RequestParam Integer cmt_seq) throws Exception {
        System.out.println("cmt_seq : " + cmt_seq);
        System.out.println("content : " + content);
        System.out.println("b_seq : " + b_seq);
        service.updateCmt(content, b_seq, cmt_seq);
        return "댓글 수정 완료";
    }
}
