package com.example.Spring_Project.controller;


import com.example.Spring_Project.dto.BoardDTO;
import com.example.Spring_Project.service.BoardService;
import lombok.Getter;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired
    private BoardService service;

    @RequestMapping("/toBoard") // 메인 , 게시글 리스트
    public String toBoard(Model model) throws Exception{
        List <BoardDTO> list=service.select();
        model.addAttribute("list",list);
        return "/board/main";
    }

    @RequestMapping("/toWriteForm")  //글 작성 폼으로 이동
    public String toWriteForm() throws Exception{
        return "/board/writeForm";
    }

    @PostMapping("/insert")  //글 작성
    public String insert(@RequestParam BoardDTO boardDTO) throws Exception{
        service.insert(boardDTO);
        return "redirect:/board/toBoard";
    }

    @GetMapping("/detail")   //게시글 상세페이지
    public String detail(Model model, @RequestParam Integer b_seq) throws Exception{
        BoardDTO boardDTO = service.getBoardDetail(b_seq);   //게시글 상세 정보 가져오기
        model.addAttribute("boardDTO",boardDTO);
        return "/board/detailPost";
    }
}

