package com.example.Spring_Project.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface FileMapper {
    void insert(List<Map<String, Object>> list);

    void insertMap(Map<String, Object> map);
}
