package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.FileDTO;
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

    public List<FileDTO> getFile(@RequestParam Integer b_seq) throws Exception{
        return mapper.getFile(b_seq);
    }

    public FileDTO getFileInfo(@RequestParam Integer f_seq) throws Exception{
        return mapper.getFileInfo(f_seq);
    }
}
