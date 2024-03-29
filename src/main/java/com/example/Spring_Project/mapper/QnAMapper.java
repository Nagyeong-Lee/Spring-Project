package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.AnswerDTO;
import com.example.Spring_Project.dto.ProductDTO;
import com.example.Spring_Project.dto.QuestionDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Mapper
@Repository

public interface QnAMapper {
    void insertQuestion(Map<String, Object> param);

    List<QuestionDTO> getQuestions(@Param("pd_seq") Integer pd_seq);

    @Select("select count(*) from answer where q_seq = #{q_seq} and status = 'Y'")
    Integer isAnswerExist(@Param("q_seq") Integer q_seq);

    AnswerDTO getAnswer(@Param("q_seq") Integer q_seq);

    List<QuestionDTO> getMyQnAs(@Param("start") Integer start,@Param("end") Integer end,@Param("id") String id);

    @Update("update question set status = 'N' where q_seq = #{q_seq}")
    void deleteQuestion(@Param("q_seq") Integer q_seq);

    @Update("update answer set status = 'N' where q_seq = #{q_seq}")
    void deleteAnswer(@Param("q_seq") Integer q_seq);

    QuestionDTO getQuestion(@Param("q_seq") Integer q_seq);
    void updQuestion(@Param("q_seq")Integer q_seq,@Param("content") String content);
    List<QuestionDTO> qNaList(@Param("start") Integer start,@Param("end") Integer end);
    void insertAns(Map<String,Object> param);
    void updAns(Map<String,Object> param);
    void deleteAns(@Param("q_seq") Integer q_seq);
    ProductDTO pdInfo(@Param("pd_seq")Integer pd_seq);

    @Select("select count(*) from question where status = 'Y'")
    Integer countQuestion();
    @Select("select count(*) from question where id = #{id} and status = 'Y'")
    Integer countMyQuestion(@Param("id") String id);

    Integer filteredReviewCnt(@Param("pcArr") List<String> pcArr, @Param("chCArr") List<String> chCArr, @Param("starArr") List<String> starArr
            , @Param("type") String selectType, @Param("keyword") String keyword);
}
