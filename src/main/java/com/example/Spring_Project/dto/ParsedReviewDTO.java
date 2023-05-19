package com.example.Spring_Project.dto;

import lombok.Data;

@Data
public class ParsedReviewDTO {

    private Integer review_seq;
    private String revImg_seq;
    private String id;
    private Integer pd_seq;
    private Integer payPd_seq;
    private Integer stock;
    private Integer price;
    private String pdOption;
    private Integer star;
    private String content;
    private String writeDate;
    private String pdName;
    private String PdImg;
}
