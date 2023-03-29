package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.LogDTO;
import com.example.Spring_Project.mapper.LogMapper;
import lombok.extern.java.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Service
public class LogService {

    @Autowired
    private LogMapper logMapper;

    public void insertLog(LogDTO logDTO) throws Exception{
        logMapper.insertLog(logDTO);
    }

    public Integer isIdExist(@RequestParam String id) throws Exception{
        return logMapper.isIdExist(id);
    }

    public Integer loginCheck(@RequestParam String id, @RequestParam String pw) throws Exception {
        return logMapper.loginCheck(id, pw); //log
    }
}
