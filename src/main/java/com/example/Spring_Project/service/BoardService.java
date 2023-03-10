package com.example.Spring_Project.service;


import com.example.Spring_Project.dto.BoardDTO;
import com.example.Spring_Project.mapper.BoardMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Service
public class BoardService {

    @Autowired
    private BoardMapper mapper;

    public void insert(BoardDTO boardDTO)throws Exception{  //게시글 insert
        mapper.insert(boardDTO);
    }

    public List<BoardDTO> select(Integer start, Integer end) throws Exception{   //게시글 리스트 출력
        return mapper.select(start,end);
    }

    public BoardDTO getBoardDetail(@RequestParam Integer b_seq) throws Exception{  //게시글 상세정보 출력
        return mapper.getBoardDetail(b_seq);
    }


    public void count(@RequestParam Integer b_seq) throws Exception{  //조회수 증가
        mapper.count(b_seq);
    }

    public void delete(@RequestParam Integer b_seq) throws Exception{  //게시글 삭제
         mapper.delete(b_seq);
    }

    public void update(@RequestParam String title, @RequestParam String content, @RequestParam Integer b_seq) throws Exception {  //게시글 수정
        mapper.update(title, content, b_seq);
    }

    public Integer countPost() throws Exception{
        return mapper.countPost();
    }


    //페이징 처리
    public String getBoardPageNavi(int currentPage, Integer count) throws Exception {
        int postTotalCount = this.countPost();

        int recordCountPerPage = count; // 페이지 당 게시글 개수
        int naviCountPerPage = 10; // 내비 개수

        int pageTotalCount = 0; // 전체 내비 수
        if(postTotalCount % recordCountPerPage > 0) {
            pageTotalCount = postTotalCount / recordCountPerPage + 1;
        }else {
            pageTotalCount = postTotalCount / recordCountPerPage;
        }

        if(currentPage < 1) {
            currentPage = 1;
        }else if(currentPage > pageTotalCount) {
            currentPage = pageTotalCount;
        }

        int startNavi = (currentPage-1) / naviCountPerPage * naviCountPerPage + 1; // 페이지 시작 내비 값
        int endNavi = startNavi + naviCountPerPage - 1; // 페이지 마지막 내비 값

        if(endNavi > pageTotalCount) {
            endNavi = pageTotalCount;
        }

        boolean needPrev = true;
        boolean needNext = true;

        if(startNavi == 1) {needPrev = false;}
        if(endNavi == pageTotalCount) {needNext = false;}

        StringBuilder sb = new StringBuilder();

        if(needPrev) {
            sb.append("<a href='/board/list?currentPage="+(startNavi-1)+"&count="+count+"'><</a> ");
        }

        for(int i = startNavi; i <= endNavi; i++) {
            if(currentPage == i){
                sb.append("<a href='/board/list?currentPage="+i+"&count="+count+"'><b>" + i + "</b></a> ");

            }else {
                sb.append("<a href='/board/list?currentPage="+i+"&count="+count+"'>" + i + "</a> ");

            }
        }
        if(needNext) {
            sb.append("<a href='/board/list?currentPage="+(endNavi+1)+"&count="+count+"'>></a> ");
        }
        return sb.toString();
    }

}
