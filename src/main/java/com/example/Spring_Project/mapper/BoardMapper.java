package com.example.Spring_Project.mapper;


import com.example.Spring_Project.dto.BoardDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.data.relational.core.sql.In;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Mapper
public interface BoardMapper {

    List<BoardDTO> select(@Param("start") Integer start, @Param("end") Integer end,
                          @Param("searchType") String searchType, @Param("keyword") String keyword);
    void insert(BoardDTO boardDTO);   //게시글 insert

    BoardDTO getBoardDetail(@Param("b_seq") Integer b_seq); //게시글 상세정보 출력

    void count(@Param("b_seq") Integer b_seq);  //조회수 증가

    void delete(@Param("b_seq")Integer b_seq);  //게시글 삭제
    void update(@Param("title") String title, @Param("content") String content, @Param("b_seq") Integer b_seq); //게시글 수정
    Integer countPost();  //게시글 총 개수
    Integer countBySearchType(@Param("searchType") String searchType, @Param("keyword") String keyword);  // 검색 조건별 게시글 개수

}
