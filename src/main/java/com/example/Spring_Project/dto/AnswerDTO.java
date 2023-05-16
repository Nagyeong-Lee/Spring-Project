package com.example.Spring_Project.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class AnswerDTO {
    private Integer ans_seq;
    private Integer q_seq;
    private String writer;
    private String answer;
    private String writeDate;
    private String status;
    private String ansYN; //답변 여부
}


