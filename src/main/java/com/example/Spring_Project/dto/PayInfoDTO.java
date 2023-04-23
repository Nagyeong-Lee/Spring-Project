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
    private Integer payInfo_seq;
    private String id;
    private Integer price;
    private Timestamp pay_time;
}
