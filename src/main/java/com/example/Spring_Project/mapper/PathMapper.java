package com.example.Spring_Project.mapper;

import com.example.Spring_Project.service.PathService;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface PathMapper {

    String getCommunityPath();

    String getLogoutPath();

    String getDeletePath();

    String getUpdateFormPath();
}
