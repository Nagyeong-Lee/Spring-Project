package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.HospitalDTO;
import com.example.Spring_Project.dto.InfectionByMonthDTO2;
import com.example.Spring_Project.dto.InfectionDTO;
import com.example.Spring_Project.service.ApiService;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.http.HttpServletRequest;
import java.net.URI;
import java.util.*;

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

        System.out.println("MAP1 : " + map);
        Integer currentPage = Integer.parseInt(map.get("currentPage").toString());
        Integer count = Integer.parseInt(map.get("count").toString());
        String searchType = map.get("searchType").toString();
        String keyword = map.get("keyword").toString();
        Integer start = currentPage * count - (count - 1); //시작 글 번호
        Integer end = currentPage * count; // 끝 글 번호

        String cityOption = "";
        String weekOpenOption = "";
        String weekCloseOption = "";
        String satOpenOption = "";
        String satCloseOption = "";
        String holidayYNOption = "";
        String holidayY = "";
        String holidayN = "";
        String holidayOpenOption = "";
        String holidayCloseOption = "";

        //옵션 정보 가져오기
        if (map.get("city") == null) {
            cityOption = "ALL";
        } else {
            cityOption = map.get("city").toString();
        }
        if (map.get("weekOpen") == null) {
            weekOpenOption = "09:00";
        } else {
            weekOpenOption = map.get("weekOpen").toString();
        }
        if (map.get("weekClose") == null) {
            weekCloseOption = "22:00";
        } else {
            weekCloseOption = map.get("weekClose").toString();
        }
        if (map.get("satOpen") == null) {
            satOpenOption = "09:00";
        } else {
            satOpenOption = map.get("satOpen").toString();
        }
        if (map.get("satClose") == null) {
            satCloseOption = "22:00";
        } else {
            satCloseOption = map.get("satClose").toString();
        }

        if (map.get("holidayY") == null) {
            holidayY = "진료";
        }else{
            holidayY = map.get("holidayY").toString();
        }

        if (map.get("holidayN") == null) {
            holidayN = "미진료";
        }else{
            holidayN = map.get("holidayN").toString();
        }

        if (map.get("holidayOpen") == null) {
            holidayOpenOption = "09:00";
        } else {
            holidayOpenOption = map.get("holidayOpen").toString();
        }
        if (map.get("holidayClose") == null) {
            holidayCloseOption = "19:00";
        } else {
            holidayCloseOption = map.get("holidayClose").toString();
        }

        List<String> city = apiService.getCity(); //지역명
        List<String> weekOpen = apiService.getWeekOpen(); //평일 진료 시작 시간
        List<String> weekClose = apiService.getWeekClose(); //평일 진료 마감 시간
        List<String> satOpen = apiService.getSatOpen(); //토요일 진료 시작 시간
        List<String> satClose = apiService.getSatClose(); //토요일 진료 마감 시간
        List<String> holidayYN = apiService.getHolidayYN(); //일요일,공휴일 진료 여부
        List<String> holidayOpen = apiService.getHolidayOpen(); //일요일,공휴일 진료 시작 시간
        List<String> holidayClose = apiService.getHolidayClose(); //일요일,공휴일 진료 마감 시간

        model.addAttribute("city", city);
        model.addAttribute("weekOpen", weekOpen);
        model.addAttribute("weekClose", weekClose);
        model.addAttribute("satOpen", satOpen);
        model.addAttribute("satClose", satClose);
        model.addAttribute("holidayYN", holidayYN);
        model.addAttribute("holidayOpen", holidayOpen);
        model.addAttribute("holidayClose", holidayClose);
        model.addAttribute("holidayY", holidayY);
        model.addAttribute("holidayN", holidayN);

        model.addAttribute("cityOption", cityOption);
        model.addAttribute("weekOpenOption", weekOpenOption);
        model.addAttribute("weekCloseOption", weekCloseOption);
        model.addAttribute("satOpenOption", satOpenOption);
        model.addAttribute("satCloseOption", satCloseOption);
        model.addAttribute("holidayYNOption", holidayYNOption);
        model.addAttribute("holidayOpenOption", holidayOpenOption);
        model.addAttribute("holidayCloseOption", holidayCloseOption);

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("currentPage", currentPage);
        paramMap.put("count", count);
        paramMap.put("searchType", searchType);
        paramMap.put("keyword", keyword);
        paramMap.put("city", cityOption);
        paramMap.put("weekOpen", weekOpenOption);
        paramMap.put("weekClose", weekCloseOption);
        paramMap.put("satOpen", satOpenOption);
        paramMap.put("satClose", satCloseOption);
//        paramMap.put("holidayYN", holidayYNOption);
        paramMap.put("holidayY", holidayY);
        paramMap.put("holidayN", holidayN);
        paramMap.put("holidayOpen", holidayOpenOption);
        paramMap.put("holidayClose", holidayCloseOption);
        paramMap.put("start", start);
        paramMap.put("end", end);

        Map<String, Object> reMap = new HashMap<>();
        List<HospitalDTO> list = apiService.test(paramMap); //처음에 병원 list 가져오기
        Map<String, Object> paging = apiService.getHospitalPageNavi2(currentPage, count, searchType, keyword, cityOption, weekOpenOption,
                weekCloseOption, satOpenOption, satCloseOption, holidayYNOption,holidayY,holidayN, holidayOpenOption, holidayCloseOption);
        reMap.put("items", list);
        reMap.put("paging", paging);

        System.out.println("=====처음 끝 페이지====");
        System.out.println("paging needNext : "+Boolean.parseBoolean(paging.get("needNext").toString()));
        System.out.println("page totalCount : "+Integer.parseInt(paging.get("pageTotalCount").toString()));
        System.out.println("=====처음 끝 페이지====");

        model.addAttribute("currentPage", currentPage);
        model.addAttribute("count", count); //개수 선택
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("test", list);
        model.addAttribute("startNavi", Integer.parseInt(paging.get("startNavi").toString()));
        model.addAttribute("endNavi", Integer.parseInt(paging.get("endNavi").toString()));
        model.addAttribute("needPrev", Boolean.parseBoolean(paging.get("needPrev").toString()));
        model.addAttribute("needNext", Boolean.parseBoolean(paging.get("needNext").toString()));
        return "/api/hospitalInfo";
    }

    @ResponseBody
    @RequestMapping("/hospital/list") //옵션 수정할때
    public Map<String, Object> hospitalItems(HttpServletRequest request, Model model, @RequestParam Map<String, Object> map) throws Exception {

        System.out.println("/hospital/list map2 : " + map);
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
        String holidayY = "";
        String holidayN = "";
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
//        if (map.get("holidayYN").toString().equals("진료")) {
//            holidayYN = "진료";
//        }
        if (map.get("holidayOpen") != null) {
            holidayOpen = map.get("holidayOpen").toString();
        }
        if (map.get("holidayClose") != null) {
            holidayClose = map.get("holidayClose").toString();
        }
            holidayY = map.get("holidayY").toString();
            holidayN = map.get("holidayN").toString();

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
//        paramMap.put("holidayYN", holidayYN);
        paramMap.put("holidayY", holidayY);
        paramMap.put("holidayN", holidayN);
        paramMap.put("holidayOpen", holidayOpen);
        paramMap.put("holidayClose", holidayClose);
        paramMap.put("start", start);
        paramMap.put("end", end);


        List<HospitalDTO> list = apiService.test2(paramMap);
        Map<String, Object> paging = apiService.getHospitalPageNavi2(currentPage, count, searchType, keyword, city, weekOpen,
                weekClose, satOpen, satClose, holidayYN, holidayY,holidayN,holidayOpen, holidayClose);
        System.out.println("변경 후 전체 글 개수");
        System.out.println(paging.get("pageTotalCount"));

        reMap.put("items", list);

        reMap.put("cityOption", city);
        reMap.put("weekOpenOption", weekOpen);
        reMap.put("weekCloseOption", weekClose);
        reMap.put("satOpenOption", satOpen);
        reMap.put("satCloseOption", satClose);
        reMap.put("holidayYNOption", holidayYN);
        reMap.put("holidayOpenOption", holidayOpen);
        reMap.put("holidayCloseOption", holidayClose);
        reMap.put("holidayY", holidayY);
        reMap.put("holidayN", holidayN);

        reMap.put("currentPage", currentPage);
        reMap.put("count", count);
        reMap.put("searchType", searchType);
        reMap.put("keyword", keyword);

        reMap.put("paging", paging);

        System.out.println("====/list");
        System.out.println("holidayYN : " + holidayYN);
        System.out.println("holidayY : " + holidayY);
        System.out.println("holidayN : " + holidayN);


        return reMap;
    }

    @PostMapping("/detail")
    public String map(Model model, @RequestParam Map<String, Object> map) throws Exception {
        Integer hospital_seq = Integer.parseInt(map.get("hospital_seq").toString());
        Integer currentPage = Integer.parseInt(map.get("currentPage").toString());
        Integer count = Integer.parseInt(map.get("count").toString());
        String searchType = map.get("searchType").toString();
        String keyword = map.get("keyword").toString();
        String city = map.get("city").toString();
        String weekOpen = map.get("weekOpen").toString();
        String weekClose = map.get("weekClose").toString();
        String satOpen = map.get("satOpen").toString();
        String satClose = map.get("satClose").toString();
//        String holidayYN = map.get("holidayYN").toString();
        String holidayOpen = map.get("holidayOpen").toString();
        String holidayClose = map.get("holidayClose").toString();

        String holidayY = "";
        String holidayN = "";

        holidayY=map.get("holidayY").toString();
        holidayN=map.get("holidayN").toString();

        System.out.println("detail");
        System.out.println(holidayY);
        System.out.println(holidayN);
        HospitalDTO hospitalDTO = apiService.getInfo(hospital_seq); //병원 한 개 정보
        model.addAttribute("hospitalDTO", hospitalDTO);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("count", count);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("city", city);
        model.addAttribute("weekOpen", weekOpen);
        model.addAttribute("weekClose", weekClose);
        model.addAttribute("satOpen", satOpen);
        model.addAttribute("satClose", satClose);
//      model.addAttribute("holidayYN", holidayYN);
        model.addAttribute("holidayY", holidayY);
        model.addAttribute("holidayN", holidayN);
        model.addAttribute("holidayOpen", holidayOpen);
        model.addAttribute("holidayClose", holidayClose);
        return "/api/detail";
    }

    @GetMapping("/search")
    public String list(Model model) throws Exception {
//      String encode = Base64.getEncoder().encodeToString(query.getBytes(StandardCharsets.UTF_8));
        URI uri = UriComponentsBuilder.fromUriString("https://openapi.naver.com/")
                .path("v1/search/news.json")
                .queryParam("query", "코로나")
                .queryParam("display", 5)
                .queryParam("start", 1)
                .queryParam("sort", "sim")
                .encode()
                .build()
                .toUri();

        RestTemplate restTemplate = new RestTemplate();
        RequestEntity<Void> req = RequestEntity
                .get(uri)
                .header("X-Naver-Client-Id", "w59f0ilmFqCGefTg1E7_")
                .header("X-Naver-Client-Secret", "tHQhEtLMVk")
                .build();
        ResponseEntity<String> result = restTemplate.exchange(req, String.class);

        List<Map<String, Object>> list = new ArrayList<>();
        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject = (JsonObject) jsonParser.parse(result.getBody());
        JsonArray jsonArray = (JsonArray) jsonObject.get("items");

        for (Integer i = 0; i < jsonArray.size(); i++) {
            Map<String, Object> map = new HashMap<>();
            JsonObject jsonObject2 = (JsonObject) jsonArray.get(i);
            map.put("title", jsonObject2.get("title"));
            map.put("link", jsonObject2.get("link"));
            map.put("description", jsonObject2.get("description"));
            map.put("pubDate", jsonObject2.get("pubDate"));
            list.add(map);
        }
        System.out.println(list);
        model.addAttribute("list", list);
        return "/api/search";
    }
}
