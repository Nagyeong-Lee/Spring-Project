package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Date;
import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class MemberDTO {

    private Integer m_seq;
    private String id;
    private String pw;
    private String name;
    private String email;
    private String phone;
    private String postcode;
    private String roadAddress;
    private String jibunAddress;
    private String detailAddress;
    private Timestamp signup_date;
    private String oriname;
    private String sysname;
    private String savePath;
    private String status;
    private String type;
    private String fileIsEmpty;
    private Date lastLoginDate;
    private Integer point;
}