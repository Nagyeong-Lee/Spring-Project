package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.HospitalDTO;
import com.example.Spring_Project.dto.InfectionByMonthDTO2;
import com.example.Spring_Project.dto.InfectionDTO;
import com.example.Spring_Project.service.ApiService;
import lombok.extern.slf4j.Slf4j;
import org.apache.xmlbeans.soap.SOAPArrayType;
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

    @RequestMapping("/hospital") //처음 들어갈때
    public String hospitalInfo(HttpServletRequest request, Model model, @RequestParam Map<String, Object> map) throws Exception {

        System.out.println("MAP : "+map);
        System.out.println("currentPage : "+Integer.parseInt(map.get("currentPage").toString()));
        Integer currentPage = Integer.parseInt(map.get("currentPage").toString());
        Integer count = Integer.parseInt(map.get("count").toString());
        String searchType = map.get("searchType").toString();
        String keyword = map.get("keyword").toString();

        Integer start = currentPage * count - (count - 1); //시작 글 번호
        Integer end = currentPage * count; // 끝 글 번호

        List<HospitalDTO> test = apiService.test(searchType, keyword, start, end); //처음에 병원 list 가져오기
//      String paging = apiService.getHospitalPageNavi(currentPage, count, searchType, keyword);
        Map<String, Object> paging = apiService.getHospitalPageNavi2(currentPage, count, searchType, keyword);
        System.out.println("paging : " + paging);
        model.addAttribute("currentPage", currentPage);
//      model.addAttribute("list", list);
        model.addAttribute("paging", paging);
        model.addAttribute("count", count); //개수 선택
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("test", test);
        model.addAttribute("startNavi", Integer.parseInt(paging.get("startNavi").toString()));
        model.addAttribute("endNavi", Integer.parseInt(paging.get("endNavi").toString()));
        model.addAttribute("needPrev", Boolean.parseBoolean(paging.get("needPrev").toString()));
        model.addAttribute("needNext", Boolean.parseBoolean(paging.get("needNext").toString()));

        String cityOption = "";
        String weekOpenOption = "";
        String weekCloseOption = "";
        String satOpenOption = "";
        String satCloseOption = "";
        String holidayYNOption = "";
        String holidayOpenOption = "";
        String holidayCloseOption = "";
        //옵션 정보 가져오기
        if (map.get("city") == null) {
            cityOption = "ALL";
        }else{
            cityOption = map.get("city").toString();
        }

        if (map.get("weekOpenOption") == null) {
            weekOpenOption = "09:00";
        }else{
            weekOpenOption=map.get("weekOpenOption").toString();
        }

        if (map.get("weekCloseOption") == null) {
            weekCloseOption = "22:00";
        }else{
            weekCloseOption=map.get("weekCloseOption").toString();
        }

        if (map.get("satOpenOption") == null) {
            satOpenOption = "09:00";
        }else{
            satOpenOption=map.get("satOpenOption").toString();
        }

        if (map.get("satCloseOption") == null) {
            satCloseOption = "22:00";
        }else{
            satCloseOption=map.get("satCloseOption").toString();
        }

        if (map.get("holidayYNOption") == null) {
            holidayYNOption = "미진료";
        }else{
            holidayYNOption = "미진료";
        }

        if (map.get("holidayOpenNOption") == null) {
            holidayOpenOption = "09:00";
        }else{
            holidayOpenOption=map.get("holidayOpenNOption").toString();
        }

        if (map.get("holidayCloseOption") == null) {
            holidayCloseOption = "19:00";
        }else{
            holidayCloseOption=map.get("holidayCloseOption").toString();
        }

        List<String> city = apiService.getCity(); //지역명
        List<String> weekOpen = apiService.getWeekOpen(); //평일 진료 시작 시간
        List<String> weekClose = apiService.getWeekClose(); //평일 진료 마감 시간
        List<String> satOpen = apiService.getSatOpen(); //토요일 진료 시작 시간
        List<String> satClose = apiService.getSatClose(); //토요일 진료 마감 시간
        List<String> holidayYN = apiService.getHolidayYN(); //일요일,공휴일 진료 여부
        List<String> holidayOpen = apiService.getHolidayOpen(); //일요일,공휴일 진료 시작 시간
        List<String> holidayClose = apiService.getHolidayClose(); //일요일,공휴일 진료 마감 시간

        System.out.println("city : " + city);
        System.out.println("cityOption : " + cityOption);
        System.out.println("weekOpen : " + weekOpen);
        System.out.println("weekClose : " + weekClose);
        System.out.println("satOpen : " + satOpen);
        System.out.println("satClose : " + satClose);
        System.out.println("holidayYN : " + holidayYN);

        model.addAttribute("city", city);
        model.addAttribute("weekOpen", weekOpen);
        model.addAttribute("weekClose", weekClose);
        model.addAttribute("satOpen", satOpen);
        model.addAttribute("satClose", satClose);
        model.addAttribute("holidayYN", holidayYN);
        model.addAttribute("holidayOpen", holidayOpen);
        model.addAttribute("holidayClose", holidayClose);

        model.addAttribute("cityOption", cityOption);
        model.addAttribute("weekOpenOption", weekOpenOption);
        model.addAttribute("weekCloseOption", weekCloseOption);
        model.addAttribute("satOpenOption", satOpenOption);
        model.addAttribute("satCloseOption", satCloseOption);
        model.addAttribute("holidayYNOption", holidayYNOption);
        model.addAttribute("holidayOpenOption", holidayOpenOption);
        model.addAttribute("holidayCloseOption", holidayCloseOption);

        return "/api/hospitalInfo";
    }

    @ResponseBody
    @RequestMapping("/hospital/list") //옵션 수정할때
    public Map<String, Object> hospitalItems(HttpServletRequest request, Model model, @RequestParam Map<String, Object> map) throws Exception {

        Map<String, Object> reMap = new HashMap<>();

        //option 값
        Integer currentPage = Integer.parseInt(map.get("currentPage").toString());
        Integer count = Integer.parseInt(map.get("count").toString());
        String searchType = map.get("searchType").toString();
        String keyword = map.get("keyword").toString();
        String city = "";
        String weekOpen = "";
        String weekClose = "";
        String satOpen = "";
        String satClose = "";
        String holidayYN = "";
        String holidayOpen = "";
        String holidayClose = "";

        if (map.get("city") != null) {
            city = map.get("city").toString();
        }
        if (map.get("weekOpen") != null) {
            weekOpen = map.get("weekOpen").toString();
        }
        if (map.get("weekClose") != null) {
            weekClose = map.get("weekClose").toString();
        }
        if (map.get("satOpen") != null) {
            satOpen = map.get("satOpen").toString();
        }
        if (map.get("satClose") != null) {
            satClose = map.get("satClose").toString();
        }
        if (map.get("holidayYN") != null) {
            holidayYN = map.get("holidayYN").toString();
        }
        if (map.get("holidayOpen") != null) {
            holidayOpen = map.get("holidayOpen").toString();
        }
        if (map.get("holidayClose") != null) {
            holidayClose = map.get("holidayClose").toString();
        }

        Integer start = currentPage * count - (count - 1); //시작 글 번호
        Integer end = currentPage * count; // 끝 글 번호

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("currentPage", currentPage);
        paramMap.put("count", count);
        paramMap.put("searchType", searchType);
        paramMap.put("keyword", keyword);
        paramMap.put("city", city);
        paramMap.put("weekOpen", weekOpen);
        paramMap.put("weekClose", weekClose);
        paramMap.put("satOpen", satOpen);
        paramMap.put("satClose", satClose);
        paramMap.put("holidayYN", holidayYN);
        paramMap.put("holidayOpen", holidayOpen);
        paramMap.put("holidayClose", holidayClose);
        paramMap.put("start", start);
        paramMap.put("end", end);

        System.out.println(city);
        System.out.println(weekOpen);
        System.out.println(weekClose);
        System.out.println(satOpen);
        System.out.println(satClose);
        System.out.println(holidayYN);
        System.out.println(holidayOpen);
        System.out.println(holidayClose);
        System.out.println("currentPage : "+currentPage);
        System.out.println("count : "+count);
//      List<HospitalDTO> list = apiService.getHospitalInfo(searchType, keyword, start, end, city);
//      String paging = apiService.getHospitalPageNavi(currentPage, count, searchType, keyword);
        List<HospitalDTO> list = apiService.test2(paramMap);
        Map<String, Object> paging = apiService.getHospitalPageNavi2(currentPage, count, searchType, keyword);
        reMap.put("items", list);
        reMap.put("paging", paging);
        reMap.put("currentPage", currentPage);
        reMap.put("count", count);
        reMap.put("searchType", searchType);
        reMap.put("keyword", keyword);
        return reMap;
    }

    @PostMapping("/detail")
    public String map(Model model, @RequestParam Map<String, Object> map) throws Exception {
        Integer hospital_seq = Integer.parseInt(map.get("hospital_seq").toString());
        Integer currentPage = Integer.parseInt(map.get("currentPage").toString());
        Integer count = Integer.parseInt(map.get("count").toString());
        String searchType = map.get("searchType").toString();
        String keyword = map.get("keyword").toString();
//        String city=map.get("city").toString();

        HospitalDTO hospitalDTO = apiService.getInfo(hospital_seq); //병원 한 개 정보
        model.addAttribute("hospitalDTO", hospitalDTO);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("count", count);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
//        model.addAttribute("city", city);
        return "/api/detail";
    }
}
