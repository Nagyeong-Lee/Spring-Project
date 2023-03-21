package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.CommentDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface CommentMapper {

    void insert(CommentDTO commentDTO);  //댓글 insert
    List<CommentDTO> getComment(@Param("b_seq") Integer b_seq); //댓글 출력
    void reply(@Param("writer")String writer, @Param("content")String content,@Param("b_seq")Integer b_seq,
               @Param("parent_cmt_seq") Integer parent_cmt_seq);  //대댓글 insert

    void deleteCmt(@Param("cmt_seq") Integer cmt_seq); //댓글 삭제
    void updateCmt(@Param("content") String content,
                   @Param("b_seq") Integer b_seq,
                   @Param("cmt_seq") Integer cmt_seq); //댓글 수정

    Integer getParentSeq(@Param("cmt_seq") Integer cmt_seq);
}
