package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.HospitalDTO;
import com.example.Spring_Project.dto.InfectionByMonthDTO2;
import com.example.Spring_Project.dto.InfectionDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

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
    List<HospitalDTO> getHospitalInfo(@Param("searchType") String searchType,@Param("keyword") String keyword
                                    ,@Param("start") Integer start, @Param("end") Integer end
    );
    HospitalDTO getInfo(Integer hospital_seq);
    Integer countPost(@Param("searchType") String searchType, @Param("keyword") String keyword);
    List<String> getCity();
    List<String> getWeekOpen();
    List<String> getWeekClose();
    List<String> getSatOpen();
    List<String> getSatClose();
    List<String> getHolidayYN();
    List<String> getHolidayOpen();
    List<String> getHolidayClose();
}
