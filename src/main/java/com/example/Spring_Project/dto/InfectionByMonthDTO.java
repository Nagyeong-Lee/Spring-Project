package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class InfectionByMonthDTO {

    private Integer infectionByMonth_seq;

    private String mmdd;

    private String cnt;

    private String MONTH;
    private String YEAR;

}
