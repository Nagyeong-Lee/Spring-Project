package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProductDTO {
    private Integer pd_seq;
    private String name;
    private String description;
    private Integer price;
    private Integer stock;
    private String status;
    private String img;
    private Integer category;
    private Double point; //포인트 적립될 퍼센티지
}
