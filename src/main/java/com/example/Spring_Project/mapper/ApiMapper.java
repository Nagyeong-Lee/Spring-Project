package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.InfectionDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface ApiMapper {

    void insertInfectionInfo(InfectionDTO infectionDTO);
    InfectionDTO getInfectionInfo();
    void updateStatus(@Param("infection_seq") Integer infection_seq);
}
