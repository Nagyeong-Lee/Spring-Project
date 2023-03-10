package com.example.Spring_Project.controller;


import com.example.Spring_Project.dto.BoardDTO;
import com.example.Spring_Project.dto.CommentDTO;
import com.example.Spring_Project.service.BoardService;
import com.example.Spring_Project.service.CommentService;
import lombok.Getter;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.relational.core.sql.In;
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

    @Autowired
    private CommentService commentService;

    @RequestMapping("/list") // 메인 , 게시글 리스트
    public String toBoard(Model model,@RequestParam Integer currentPage,
                         @RequestParam Integer count) throws Exception{
        if(currentPage==null){
            currentPage=1;
        }

        //게시글 개수 기본 10
        if(count==null){
            count=10;
        }
        Integer boardListCount = service.countPost(); // 전체 글 개수
        Integer start = currentPage * count - 9; //시작 글 번호
        Integer end = currentPage * count; // 끝 글 번호

        List <BoardDTO> list=service.select(start,end);
        String paging=service.getBoardPageNavi(currentPage,count);

        model.addAttribute("list",list);
        model.addAttribute("paging",paging);
        return "/board/main";
    }

    @RequestMapping("/toWriteForm")  //글 작성 폼으로 이동
    public String toWriteForm() throws Exception{
        return "/board/writeForm";
    }

    @PostMapping("/insert")  //글 작성
    public String insert(BoardDTO boardDTO) throws Exception{
        service.insert(boardDTO);
        return "redirect:/board/list?currentPage=1&count=10";
    }

    @GetMapping("/detail")   //게시글 상세페이지
    public String detail(Model model, @RequestParam Integer b_seq) throws Exception{
        service.count(b_seq);   //조회수 증가
        BoardDTO boardDTO = service.getBoardDetail(b_seq);   //게시글 상세 정보 가져오기
        List<CommentDTO> commentList=commentService.getComment(b_seq);

        if(!commentList.get(0).getContent().isEmpty()) {
            System.out.println(commentList.get(0).getContent());
        }else {
            System.out.println("빈값");
        }
        
        model.addAttribute("boardDTO",boardDTO);
        model.addAttribute("commentList",commentList); //댓글 가져오기
        return "/board/detailPost";
    }

    @GetMapping("/delete")   //게시글 삭제
    public String delete(@RequestParam Integer b_seq) throws Exception{
        service.delete(b_seq);
        return "redirect:/board/list?currentPage=1&count=10";
    }

    @PostMapping("/update")  //게시글 수정
    public String update(@RequestParam String title, @RequestParam String content, @RequestParam Integer b_seq) throws Exception{
        service.update(title,content,b_seq);
        return "redirect:/board/list?currentPage=1&count=10";
    }
}

