package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.LogDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Repository
@Mapper
public interface LogMapper {
    void insertLog(LogDTO logDTO);

    Integer isIdExist(@Param("id") String id);

    Integer loginCheck(@Param("id") String id, @Param("pw") String pw); //aop log

}
