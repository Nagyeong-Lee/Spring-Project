package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FileDTO {

    private Integer f_seq;
    private String oriname;
    private String sysname;
    private String status;
    private Integer b_seq;

}
