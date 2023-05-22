package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.ImgDTO;
import com.example.Spring_Project.dto.ParsedReviewDTO;
import com.example.Spring_Project.dto.ProductDTO;
import com.example.Spring_Project.dto.ReviewDTO;
import org.apache.ibatis.annotations.*;
import org.springframework.data.relational.core.sql.In;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper public interface PdReviewMapper {
    void reviewInsert(Map<String, Object> param); //review insert
    void insertReviewImg(List<Map<String,Object>> param);  //reviewImg insert
    @Select("select review_seq.currval from dual")
    Integer currRevSeq();

    @Update("update member set point = point + 100 where id = #{id}")
    void updMemPoint(@Param("id") String id);
    ReviewDTO reviewInfo(@Param("payPd_seq") Integer payPd_seq);
    ReviewDTO reviewDetail(@Param("review_seq") Integer review_seq);

    @Select("SELECT count(*) FROM img WHERE review_seq = #{review_seq}")
    Integer checkImgExist(@Param("review_seq") Integer review_seq);
    List<ImgDTO> getReviewImg(@Param("review_seq") Integer review_seq);
    @Update("update review set status = 'N' where review_seq = #{review_seq}")
    void deleteReview(@Param("review_seq") Integer review_seq);
    void updReviewDetail(Map<String,Object>param);
    void deleteImg(List<Integer>deleteSeq);
    @Select("select round(avg(star)) from review where pd_seq = #{pd_seq}")
    Double starAvg(@Param("pd_seq") Integer pd_seq);
    @Select("select count(*) from review where pd_seq = #{pd_seq}")
    Integer reviewCnt(@Param("pd_seq") Integer pd_seq);

    List<ReviewDTO> getReviewByPd_seq(@Param("pd_seq") Integer pd_seq);

    @Select("select count(*) from img where review_seq = #{review_seq}")
    Integer isImgExist(@Param("review_seq") Integer review_seq);

    @Select("select count(*) from revImg WHERE review_seq = #{review_seq}")
    Integer chkInsert(@Param("review_seq") Integer review_seq);

    Map<String,Object> reviewInPdDetail(@Param("pd_seq") Integer pd_seq, @Param("payPd_seq") Integer payPd_seq);
    List<String> reviewImgsByPd_seq(@Param("pd_seq") Integer pd_seq);
    String optionCategory(@Param("pd_seq") Integer pd_seq, @Param("optName") String optName);
    List<ParsedReviewDTO> getReviews(@Param("start") Integer start, @Param("end") Integer end);
//    List<Map<String,Object>> getReviews(@Param("list")List<Integer>list,@Param("star") Integer star,@Param("start") Integer start,@Param("end") Integer end);
    ProductDTO pdInfo(@Param("pd_seq")Integer pd_seq);

    List<Map<String,Object>> getReviewsByOption(Map<String,Object> data);
    List<Integer> reviewImgs(@Param("seq") Integer review_seq);
    Map<String,Object> getReviewImgs(@Param("seq") Integer review_seq);
    List<Integer> getImgSeqs(@Param("review_seq") Integer review_seq);
    void insertRevSeq(@Param("review_seq") Integer review_seq,@Param("imgSeqMap") String imgSeqMap);
    String getRevImgSysname(@Param("imgSeq") Integer imgSeq);
    String getRevImg(@Param("review_seq") Integer review_seq);
}
