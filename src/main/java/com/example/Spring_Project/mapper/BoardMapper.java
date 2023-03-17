package com.example.Spring_Project.mapper;


import com.example.Spring_Project.dto.BoardDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.data.relational.core.sql.In;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface BoardMapper {

    List<BoardDTO> select(@Param("start") Integer start, @Param("end") Integer end,
                          @Param("searchType") String searchType, @Param("keyword") String keyword);
    void insert(BoardDTO boardDTO);   //게시글 insert
    void updateFileStatus(@Param("status")Map<String,Object> status);

    void updateFile(@Param("b_seq") List<MultipartFile> file, @Param("deleteSeq") List<Integer> deleteSeq); //게시글 수정

    BoardDTO getBoardDetail(@Param("b_seq") Integer b_seq); //게시글 상세정보 출력

    void count(@Param("b_seq") Integer b_seq);  //조회수 증가

    void delete(@Param("b_seq")Integer b_seq);  //게시글 삭제
    void update(@Param("b_seq") Integer b_seq,@Param("title") String title, @Param("content") String content); //게시글 수정
    Integer countPost(@Param("searchType") String searchType, @Param("keyword") String keyword);  //게시글 총 개수
    Integer getNetVal();

    void updateStatus(Map<String,Object>arr);
}
