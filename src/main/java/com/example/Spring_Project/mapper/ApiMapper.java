package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.InfectionDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface ApiMapper {

    void insertInfectionInfo(InfectionDTO infectionDTO); //일별 감염 현황
    InfectionDTO getInfectionInfo();
    Integer getCurrVal();
    Integer getNextVal();
    void updateStatus(@Param("infection_seq") Integer infection_seq);
}
