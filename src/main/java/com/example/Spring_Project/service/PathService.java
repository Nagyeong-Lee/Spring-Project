package com.example.Spring_Project.service;

import com.example.Spring_Project.mapper.PathMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;

@Service
public class PathService {

    @Autowired
    private PathMapper mapper;

    public String getCommunityPath() throws Exception {
        return mapper.getCommunityPath();
    }

    public String getLogoutPath() throws Exception {
        return mapper.getLogoutPath();
    }

    public String getDeletePath() throws Exception {
        return mapper.getDeletePath();
    }

    public String getUpdateFormPath() throws Exception {
        return mapper.getUpdateFormPath();
    }

}
