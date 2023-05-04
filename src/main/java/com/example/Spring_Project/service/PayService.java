package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.PayInfoDTO;
import com.example.Spring_Project.mapper.PayMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class PayService {
    @Autowired
    private PayMapper payMapper;
    public void insertPayInfo(Map<String,Object>param)throws Exception{
            payMapper.insertPayInfo(param);
    }

    public PayInfoDTO getPayInfo(Integer pay_seq) throws Exception{
        return payMapper.getPayInfo(pay_seq);
    }
}
