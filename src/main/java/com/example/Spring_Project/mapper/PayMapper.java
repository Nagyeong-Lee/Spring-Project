package com.example.Spring_Project.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Mapper
@Repository
public interface PayMapper {
    void insertPayInfo(Map<String,Object>param);
}
