package com.example.Spring_Project.service;

import com.example.Spring_Project.mapper.AdminMapper;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminService {
    @Autowired
    private AdminMapper adminMapper;
    public Integer count() throws Exception{
        return adminMapper.count();
    }
}
