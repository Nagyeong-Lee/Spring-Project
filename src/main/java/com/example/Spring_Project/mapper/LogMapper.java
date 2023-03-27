package com.example.Spring_Project.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

@Repository
@Mapper
public interface LogMapper {
    void insertLog(@Param("id") String id);
    Integer isIdExist(@Param("id") String id);

    Integer loginCheck(@Param("id") String id, @Param("pw") String pw); //aop log

}
