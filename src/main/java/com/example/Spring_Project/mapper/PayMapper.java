package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.PayInfoDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Mapper
@Repository
public interface PayMapper {
    void insertPayInfo(Map<String,Object>param);
    PayInfoDTO getPayInfo(@Param("pay_seq") Integer pay_seq);
}
