package com.example.Spring_Project.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class SalesDTO {
    private Integer sales_seq;
    private String id;
    private Integer pd_seq;
    private Integer stock;
    private Integer price;
    private String pdOption;
    private Timestamp salesDate;
    private String DeliYN; //배송 여부
}
