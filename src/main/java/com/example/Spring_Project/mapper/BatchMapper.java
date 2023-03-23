package com.example.Spring_Project.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

@Repository
@Mapper
public interface BatchMapper {
    void insertLoginDate(@Param("id") String id);

    Integer isIdExist(@Param("id") String id);

    void updateLoginDate(@Param("id") String id);

    void updateActiveN();
}
