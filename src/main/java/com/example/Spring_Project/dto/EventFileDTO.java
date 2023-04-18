package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class EventFileDTO {
    private Integer file_seq;
    private Integer event_seq;
    private String oriname;
    private String sysname;
    private String status;
}
