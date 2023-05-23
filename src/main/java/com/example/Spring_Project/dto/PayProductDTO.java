package com.example.Spring_Project.dto;

import lombok.Data;

@Data
public class PayProductDTO {
    private Integer payPd_seq; //pk
    private Integer pay_seq; //결제 테이블 seq
    private Integer pd_seq;
    private String options;
    private String deliYN;
    private Integer code;

}
