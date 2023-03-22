package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.relational.core.sql.In;

import java.sql.Timestamp;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ReplyDTO {

    private String content;
    private Integer b_seq;
    private String writer;
    private Timestamp write_date;
    private Integer parent_cmt_seq;
    private Integer cmt_seq;
    private Integer level;
    private String status;

}
