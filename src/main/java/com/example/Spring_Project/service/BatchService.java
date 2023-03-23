package com.example.Spring_Project.service;

import com.example.Spring_Project.mapper.BatchMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

@Service
public class BatchService {

    @Autowired
    private BatchMapper batchMapper;

    public void insertLoginDate(@RequestParam String id) throws Exception{
        batchMapper.insertLoginDate(id);
    }

    public Integer isIdExist(@RequestParam String id) throws Exception{
        return batchMapper.isIdExist(id);
    }

    public void updateLoginDate(@RequestParam String id) throws Exception{ //마지막으로 로그인한 시간 저장
        batchMapper.updateLoginDate(id);
    }

    public void updateActiveN() throws Exception{
        batchMapper.updateActiveN();
    }

}
