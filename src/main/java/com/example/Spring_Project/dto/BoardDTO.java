package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class BoardDTO {
    private Integer b_seq;
    private String title;
    private String writer;
    private String content;
    private Timestamp write_date;
    private String category;
    private Integer count;
    private String status;
    private Integer parent_seq;
    private Timestamp update_date;

}
