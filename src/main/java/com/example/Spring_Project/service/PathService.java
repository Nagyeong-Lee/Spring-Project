package com.example.Spring_Project.service;

import com.example.Spring_Project.mapper.PathMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;

@Service
public class PathService {

    @Autowired
    private PathMapper mapper;
    public String getRole(String session) throws Exception{
        return mapper.getRole(session);
    }
}
