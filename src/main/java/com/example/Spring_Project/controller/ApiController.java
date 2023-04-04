package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.HospitalDTO;
import com.example.Spring_Project.dto.InfectionByMonthDTO2;
import com.example.Spring_Project.dto.InfectionDTO;
import com.example.Spring_Project.service.ApiService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Component
@Slf4j
@RequestMapping("/api")
public class ApiController {
    @Autowired
    private ApiService apiService;

    @GetMapping("/data")
    public String api(Model model) throws Exception {
        InfectionDTO infectionDTO = apiService.getInfectionInfo();
        model.addAttribute("infectionDTO", infectionDTO);
        return "/api/infectionChart";
    }

    @GetMapping("/dataByMonth")
    public String dataByMonth(Model model) throws Exception {
        List<InfectionByMonthDTO2> list = apiService.getInfectionByMonthInfo(); //2023년 월,감염자 수
        List<Map<String, Object>> mapList = new ArrayList<>();
        Integer size = list.size();
        for (Integer i = 0; i < size; i++) {
            Map<String, Object> map = new HashMap<>();
            map.put("month", list.get(i).getMONTH());
            map.put("sum", list.get(i).getSum());
            mapList.add(map);
        }
        model.addAttribute("mapList", mapList);
        return "/api/infectionChartByMonth";
    }


    @RequestMapping("/hospital")
    public String hospitalInfo(Model model) throws Exception {
        List<HospitalDTO>list = apiService.getHospitalInfo();
        model.addAttribute("list",list);
        return "/api/hospitalInfo";
    }

    @GetMapping("/detail")
    public String map(Model model,Integer hospital_seq,String latitude, String longitude) throws Exception{
        HospitalDTO hospitalDTO = apiService.getInfo(hospital_seq); //병원 한 개 정보
        model.addAttribute("latitude",latitude);
        model.addAttribute("longitude",longitude);
        model.addAttribute("hospitalDTO",hospitalDTO);
        return "/api/detail";
    }
}
