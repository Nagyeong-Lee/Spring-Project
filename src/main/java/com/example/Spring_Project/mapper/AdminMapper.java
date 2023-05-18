package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.dto.ParsedReviewDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;


@Repository
@Mapper
public interface AdminMapper {

    List<MemberDTO>selectMemberList(); //회원 리스트 출력
    Integer select1(); //1-3
    Integer select2(); //4-6
    Integer select3(); //7-9
    Integer select4(); //10-12
    void insertExcel(Map<String, Object> excelContent); //엑셀 insert
    List<Integer> pdSeqsByCategory(@Param("seq")  Integer pdCategorySeq);
    @Update("update review set status = 'N' where review_seq = #{r_seq}")
    void delReview(@Param("r_seq") Integer r_seq);
    List<ParsedReviewDTO> reviewsByOptions(@Param("pcArr") List<String> pcArr, @Param("chCArr") List<String> chCArr, @Param("starArr") List<String> starArr
            , @Param("type") String selectType, @Param("keyword") String keyword, @Param("time") String time);


    Map<String,Object> getChildCtg(@Param("pd_seq")Integer pd_seq);
    String getParentCtg(@Param("seq") Integer parent_category_seq);
}
