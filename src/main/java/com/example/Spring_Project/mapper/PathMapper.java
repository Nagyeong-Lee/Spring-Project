package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.PathDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
@Mapper
public interface PathMapper {

    String getCommunityPath();

    String getLogoutPath();

    String getDeletePath();

    String getUpdateFormPath();
    String getHospitalPath();
    String getDaily();
    String getMonthly();
    List<PathDTO> getPathList();
    List<PathDTO> getNewsPathList();
}
