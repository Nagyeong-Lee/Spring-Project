package com.example.Spring_Project.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class BatchScheduler {
    @Autowired
    private BatchService batchService;

    @Autowired
    private ApiService apiService;

    @Scheduled(cron = "0 0 0 * * *") //매일 12시 정각
    public void memberActive() throws Exception {
        batchService.updateActiveN();
    }

    @Scheduled(cron = "0 0 22 * * *") //매일 22시
    public void runScheduler() throws Exception{
        apiService.scheduler(); //api data insert
    }

}
