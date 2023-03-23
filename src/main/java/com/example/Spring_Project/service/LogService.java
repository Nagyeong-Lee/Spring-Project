package com.example.Spring_Project.service;

import com.example.Spring_Project.mapper.LogMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

@Service
public class LogService {

    @Autowired
    private LogMapper logMapper;

    public void insertLog(@RequestParam String id) throws Exception{
        logMapper.insertLog(id);
    }

    public Integer isIdExist(@RequestParam String id) throws Exception{
        return logMapper.isIdExist(id);
    }

}
