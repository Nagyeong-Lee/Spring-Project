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
public class NewsDTO {
    private Integer news_seq;
    private String link;
    private String title;
    private String keyword;
    private String description;
    private Timestamp checkDate;
    private Timestamp lastUpdateDate;
}
