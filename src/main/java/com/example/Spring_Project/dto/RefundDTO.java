package com.example.Spring_Project.dto;

import lombok.Data;

@Data
public class RefundDTO {
   private Integer refund_seq;
    private String id;
    private Integer payPd_seq;
    private String reason;
    private Integer deli_seq;
    private String status;
}
