package com.example.Spring_Project.dto;

import lombok.Data;

@Data
public class RefundDetailDTO {
    private Integer originalPdPrice;
    private Integer pay_seq;
    private Integer payTotalPrice;
    private Integer payTotalSum;
    private Integer usedPoint;
    private Integer pd_seq;
    private String options;
    private Integer refundPdCount;
}
