package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DeliDTO {

    private Integer deli_seq;
    private String id;
    private String defaultAddress;
    private String additionalAddress1;
    private String additionalAddress2;
}
