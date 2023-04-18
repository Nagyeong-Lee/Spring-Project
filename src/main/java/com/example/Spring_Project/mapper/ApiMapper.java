package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface ApiMapper {

    void insertInfectionInfo(InfectionDTO infectionDTO); //일별 감염 현황

    InfectionDTO getInfectionInfo();

    Integer getCurrVal();

    Integer getNextVal();

    void updateStatus(@Param("infection_seq") Integer infection_seq); //insert한 데이터 빼고 나머지 status=N으로

    void insertInfectionByMonth(@Param("mmdd") String mmdd, @Param("cnt") String cnt, @Param("month") String month, @Param("year") String year);

    String getYear();

    List<InfectionByMonthDTO2> getInfectionByMonthInfo();

    //병원
    List<HospitalDTO> getHospitalInfo(@Param("searchType") String searchType, @Param("keyword") String keyword
            , @Param("start") Integer start, @Param("end") Integer end,
                                      @Param("city") String city
    );
//    List<HospitalDTO> test(@Param("searchType") String searchType,@Param("keyword") String keyword
//                                    ,@Param("start") Integer start, @Param("end") Integer end
//    );

    List<HospitalDTO> test(Map<String, Object> paramMap);

    HospitalDTO getInfo(Integer hospital_seq);

    //    Integer countPost(@Param("searchType") String searchType, @Param("keyword") String keyword);
    Integer countPost(@Param("searchType") String searchType, @Param("keyword") String keyword
            , @Param("city") String cityOption
            , @Param("weekOpen") String weekOpenOption
            , @Param("weekClose") String weekCloseOption
            , @Param("satOpen") String satOpenOption
            , @Param("satClose") String satCloseOption
            , @Param("holidayYN") String holidayYNOption
            , @Param("holidayY") String holidayY
            , @Param("holidayN") String holidayN
            , @Param("holidayOpen") String holidayOpenOption
            , @Param("holidayClose") String holidayCloseOption
    );


    List<String> getCity();

    List<String> getWeekOpen();

    List<String> getWeekClose();

    List<String> getSatOpen();

    List<String> getSatClose();

    List<String> getHolidayYN();

    List<String> getHolidayOpen();

    List<String> getHolidayClose();

    List<HospitalDTO> test2(Map<String, Object> paramMap);

    List<CodeInfoDTO> getCode_Info();

    void insertNews(List<Map<String, Object>> list);

    List<NewsDTO> getCovidNews(String keyword);

    Integer isLinkEmpty(String link, String keyword);

    void updateLink(Map<String, Object> map);

    void updateNewsStatus(String link, String keyword);

    List<NewsDTO> getStatusN(String keyword);


    //키워드별 뉴스 가져오기
    List<NewsDTO> getNewsByKeyword(@Param("start") Integer start,@Param("end") Integer end,@Param("keyword") String keyword);

    //마지막에 상태 n
    void updateStatusToN(String keyword);

    //전체 뉴스 가져오기
    List<NewsDTO> getNewsList(@Param("start") Integer start,@Param("end") Integer end);



    //merge into
    void upd(List<Map<String, Object>> news);
    void upd2(Map<String, Object> map);

   Integer countNews(String keyword);
   Integer countWholeNews();
}