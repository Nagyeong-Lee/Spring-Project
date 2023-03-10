package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Component
public class CommentDTO {

    private Integer cmt_seq;
    private Integer b_seq;
    private String content;
    private String writer;
    private Timestamp write_date;
    private Timestamp update_date;
    private String status;
    private Integer parent_cmt_seq;
}
