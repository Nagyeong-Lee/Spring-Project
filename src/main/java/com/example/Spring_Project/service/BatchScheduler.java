package com.example.Spring_Project.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Component
@Slf4j
public class BatchScheduler {
    @Autowired
    private BatchService batchService;

    @Autowired
    private ApiService apiService;


    @Scheduled(cron = "0 0 0 * * *") //매일 12시 정각
    public void memberActive() throws Exception {
        batchService.updateActiveN();
    }

    @Scheduled(cron = "0 54 09 * * *") //매일 10시로
    public void runScheduler() throws Exception {
        apiService.scheduler(); //api data insert
    }


}

