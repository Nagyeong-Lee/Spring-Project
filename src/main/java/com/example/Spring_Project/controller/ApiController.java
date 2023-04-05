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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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


    @GetMapping("/hospital")
    public String hospitalInfo(Model model, @RequestParam Integer currentPage,
                               @RequestParam Integer count,
                               @RequestParam(required = false) String searchType,
                               @RequestParam(required = false) String keyword) throws Exception {
        Integer start = currentPage * count - (count - 1); //시작 글 번호
        Integer end = currentPage * count; // 끝 글 번호
        List<HospitalDTO> list = apiService.getHospitalInfo(searchType, keyword,start,end);
        String paging=apiService.getHospitalPageNavi(currentPage, count, searchType, keyword);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("list", list);
        model.addAttribute("paging", paging);
        model.addAttribute("count", count); //개수 선택
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        return "/api/hospitalInfo";
    }

    @RequestMapping("/detail")
    public String map(Model model, Integer hospital_seq,Integer currentPage,Integer count,String searchType,String keyword) throws Exception {
        HospitalDTO hospitalDTO = apiService.getInfo(hospital_seq); //병원 한 개 정보
        model.addAttribute("hospitalDTO", hospitalDTO);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("count", count);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        return "/api/detail";
    }
}
