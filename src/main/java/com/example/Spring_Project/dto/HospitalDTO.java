package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class HospitalDTO {
    private Integer hospital_seq;
    private String postcode;
    private String city;
    private String hospital_name;
    private String roadAddress;
    private String jibunAddress;
    private String weekOpen;
    private String weekClose;
    private String satOpen;
    private String satClose;
    private String holidayOpen;
    private String holidayClose;
    private String phone;
    private String latitude;
    private String longitude;
    private String flag;
}
