package com.example.Spring_Project.dto;

import lombok.Data;

@Data
public class ShopRefundDTO {
    private Integer sr_seq;
    private Integer refund_seq;
    private String status;
    private Integer code;
    private String postNum;
    private Integer payPd_seq;
    private String deliStatus;
}
