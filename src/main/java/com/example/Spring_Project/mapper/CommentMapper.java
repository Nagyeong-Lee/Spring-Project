package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.CommentDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommentMapper {

    void insert(CommentDTO commentDTO);  //댓글 insert
    List<CommentDTO> getComment(@Param("b_seq") Integer b_seq); //댓글 출력
}
