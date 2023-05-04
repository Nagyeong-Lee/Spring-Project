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

    private Integer seq;
    private String id;
    private String name;
    private String phone;
    private String address;
    private String nickname;
    private String status; //기본 배송지인지
    private String flag; //삭제 여부

}
