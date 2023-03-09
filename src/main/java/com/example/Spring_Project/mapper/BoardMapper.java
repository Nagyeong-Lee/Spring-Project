package com.example.Spring_Project.mapper;


import com.example.Spring_Project.dto.BoardDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Mapper
public interface BoardMapper {

    void insert(@Param("boardDTO") BoardDTO boardDTO);   //게시글 insert
    List<BoardDTO> select(); // 게시글 리스트 출력

    BoardDTO getBoardDetail(@Param("b_seq") Integer b_seq); //게시글 상세정보 출력
}
