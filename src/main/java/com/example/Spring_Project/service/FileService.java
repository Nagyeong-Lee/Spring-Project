package com.example.Spring_Project.service;

import com.example.Spring_Project.mapper.FileMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Service
public class FileService {

    @Autowired
    private FileMapper mapper;
    public void insert(List<Map<String, Object>> list) throws Exception {
        mapper.insert(list);
    }

    public void insertMap(Map<String, Object> map) throws Exception {
        mapper.insertMap(map);
    }
}
