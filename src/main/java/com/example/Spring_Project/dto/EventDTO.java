package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.sql.Timestamp;
import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor

public class EventDTO {
    private Integer event_seq;
    private String id;
    private String title;
    private String startDate;
    private String startTime;
    private String endDate;
    private String endTime;
    private String content;
    private String status;
}
