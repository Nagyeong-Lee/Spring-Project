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
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
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

    @PostMapping("/data")
    public String api(Model model) throws Exception {
        InfectionDTO infectionDTO = apiService.getInfectionInfo();
        model.addAttribute("infectionDTO", infectionDTO);
        return "/api/infectionChart";
    }

    @PostMapping("/dataByMonth")
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
    public String hospitalInfo(HttpServletRequest request, Model model, @RequestParam Map<String, Object> map) throws Exception {

        Integer currentPage = Integer.parseInt(map.get("currentPage").toString());
        Integer count = Integer.parseInt(map.get("count").toString());
        String searchType = map.get("searchType").toString();
        String keyword = map.get("keyword").toString();

        Integer start = currentPage * count - (count - 1); //시작 글 번호
        Integer end = currentPage * count; // 끝 글 번호
        List<HospitalDTO> list = apiService.getHospitalInfo(searchType, keyword, start, end);
        String paging = apiService.getHospitalPageNavi(currentPage, count, searchType, keyword);


        model.addAttribute("currentPage", currentPage);
        model.addAttribute("list", list);
        model.addAttribute("paging", paging);
        model.addAttribute("count", count); //개수 선택
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);

        //옵션
        List<String>city=apiService.getCity(); //지역명
        List<String>weekOpen=apiService.getWeekOpen(); //평일 진료 시작 시간
        List<String>weekClose=apiService.getWeekClose(); //평일 진료 마감 시간
        List<String>satOpen=apiService.getSatOpen(); //토요일 진료 시작 시간
        List<String>satClose=apiService.getSatClose(); //토요일 진료 마감 시간
        List<String>holidayYN=apiService.getHolidayYN(); //일요일,공휴일 진료 여부
        List<String>holidayOpen=apiService.getHolidayOpen(); //일요일,공휴일 진료 시작 시간
        List<String>holidayClose=apiService.getHolidayClose(); //일요일,공휴일 진료 마감 시간
        model.addAttribute("city",city);
        model.addAttribute("weekOpen",weekOpen);
        model.addAttribute("weekClose",weekClose);
        model.addAttribute("satOpen",satOpen);
        model.addAttribute("satClose",satClose);
        model.addAttribute("holidayYN",holidayYN);
        model.addAttribute("holidayOpen",holidayOpen);
        model.addAttribute("holidayClose",holidayClose);
        return "/api/hospitalInfo";
    }

    @PostMapping("/detail")
    public String map(Model model, @RequestParam Map<String, Object> map) throws Exception {
        Integer hospital_seq = Integer.parseInt(map.get("hospital_seq").toString());
        Integer currentPage = Integer.parseInt(map.get("currentPage").toString());
        Integer count = Integer.parseInt(map.get("count").toString());
        String searchType = map.get("searchType").toString();
        String keyword = map.get("keyword").toString();

        HospitalDTO hospitalDTO = apiService.getInfo(hospital_seq); //병원 한 개 정보
        model.addAttribute("hospitalDTO", hospitalDTO);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("count", count);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        return "/api/detail";
    }
}
