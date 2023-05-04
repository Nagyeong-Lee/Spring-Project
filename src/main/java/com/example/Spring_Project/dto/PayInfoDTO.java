package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PayInfoDTO {

    private Integer pay_seq;
    private String id;
    private Integer price;
    private Integer deli_seq;
    private String successYN;
    private Timestamp payDate;
    private String status;
    private String payMethod;

}
