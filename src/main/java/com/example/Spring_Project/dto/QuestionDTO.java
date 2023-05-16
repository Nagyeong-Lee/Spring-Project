package com.example.Spring_Project.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class QuestionDTO {
    private Integer q_seq;
    private String id;
    private Integer pd_seq;
    private String content;
    private String status;
    private String writeDate;
    private String ansYN; //답변 여부
}
