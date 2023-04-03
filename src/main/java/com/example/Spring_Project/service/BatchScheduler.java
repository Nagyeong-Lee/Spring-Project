package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.InfectionDTO;
import org.apache.ibatis.type.BaseTypeHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class BatchScheduler {
    @Autowired
    private BatchService batchService;


    @Scheduled(cron = "0 0 0 * * *")
    //매일 12시 정각
    public void memberActive() throws Exception {
        batchService.updateActiveN();
    }



}
