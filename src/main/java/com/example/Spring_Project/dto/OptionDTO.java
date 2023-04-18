package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class OptionDTO {
    private Integer option_seq;
    private String category;
    private String name;
    private Integer stock;
    private String status;
    private Integer pd_seq;

}
