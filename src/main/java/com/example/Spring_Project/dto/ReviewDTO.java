package com.example.Spring_Project.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class ReviewDTO {
    private Integer review_seq;
    private String id;
    private Integer payPd_seq;
    private Integer pd_seq;
    private Timestamp writeDate;
    private String status;
    private Integer img_seq;
    private Integer star; //별점
}
