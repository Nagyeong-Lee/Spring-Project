package com.example.Spring_Project.dto;

import lombok.Data;

@Data
public class RefundDTO {
   private Integer refund_seq;
    private String id;
    private Integer payPd_seq;
    private String content;
    private Integer deli_seq;
    private String status;
    private String applyDate; //환불 신청일
}
