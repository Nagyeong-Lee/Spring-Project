package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.BatchDTO;
import com.example.Spring_Project.mapper.ApiMapper;
import com.example.Spring_Project.mapper.BatchMapper;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BatchService {

    @Autowired
    private BatchMapper batchMapper;

    @Autowired
    private ApiMapper apiMapper;

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

    public BatchDTO getInfo(@RequestParam String id) throws Exception{
        return batchMapper.getInfo(id);
    }

    public void updateLoginDateNull(@RequestParam String id) throws Exception{
        batchMapper.updateLoginDateNull(id);
    }

}
