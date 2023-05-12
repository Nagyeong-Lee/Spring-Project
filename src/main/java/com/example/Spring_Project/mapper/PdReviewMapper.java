package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.ImgDTO;
import com.example.Spring_Project.dto.ReviewDTO;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper public interface PdReviewMapper {
    void reviewInsert(Map<String, Object> param); //review insert
    void insertReviewImg(List<Map<String,Object>> param);  //reviewImg insert
    @Select("select review_seq.currval from dual")
    Integer currRevSeq();

    ReviewDTO reviewInfo(@Param("payPd_seq") Integer payPd_seq);
    ReviewDTO reviewDetail(@Param("review_seq") Integer review_seq);
    @Select("SELECT count(*) FROM img WHERE review_seq = #{review_seq}")
    Integer checkImgExist(@Param("review_seq") Integer review_seq);
    List<ImgDTO> getReviewImg(@Param("review_seq") Integer review_seq);
    @Update("update review set status = 'N' where review_seq = #{review_seq}")
    void deleteReview(@Param("review_seq") Integer review_seq);
    void updReviewDetail(Map<String,Object>param);
    void deleteImg(List<Integer>deleteSeq);
}
