package com.example.Spring_Project.service;

import org.apache.ibatis.type.BaseTypeHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class BatchScheduler {
    @Autowired
    private BatchService batchService;

    @Scheduled(cron = "0 0 0 1 * *")
    //매달 1일 자정
    public void memberActive() throws Exception {
        batchService.updateActiveN();
    }
}
