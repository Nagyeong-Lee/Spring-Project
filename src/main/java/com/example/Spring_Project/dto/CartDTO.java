package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import oracle.sql.CLOB;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CartDTO {
    private Integer cart_seq;
    private String id;
    private Integer count;
    private Integer pd_seq;
    private String options; //JSON
    private String status;
    private String name;
    private String description;
    private Integer price;
    private Integer stock;
    private String img;
    private String category;
    private String flag;

}
