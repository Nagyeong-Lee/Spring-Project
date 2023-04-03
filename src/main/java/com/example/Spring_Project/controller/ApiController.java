package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.InfectionDTO;
import com.example.Spring_Project.service.ApiService;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

@Controller
@Component
@RequestMapping("/api")
public class ApiController {
    @Autowired
    private ApiService apiService;

    @GetMapping("/data")
    public String api(Model model) throws Exception {
        InfectionDTO infectionDTO = apiService.getInfectionInfo();
        model.addAttribute("infectionDTO",infectionDTO);
        return"/api/infectionChart";
}

    @PostMapping("/hospital")
    public String hospitalInfo(Model model) throws Exception {
        List<List<String>> lists = new ArrayList<>();
        StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/4050000/mdclinst/getMdclinst"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=LKJBg0TUTr8u6PxqJPp2gTaRuOl9vzlXSGB%2FutNU7s765%2F8gb9ahOaNDyYYDpJuo%2BLiDSes3a%2BC70w5APfDzGg%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("5", "UTF-8")); /*페이지 번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("type", "UTF-8") + "=" + URLEncoder.encode("병/의원", "UTF-8")); /*관내 의료기관의 유형 (병/의원, 치과의원, 한의원, 약국, 의료기기업소, 안경업소, 안마시술소, 소독업체,한약방, 치과기공소, 의약품도소매업소, 산후조리원)*/
        URL url = new URL(urlBuilder.toString());
        System.out.println(url);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-type", "application/json");
        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            System.out.println("line : " + line);
            sb.append(line);
        }
        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject = (JsonObject) jsonParser.parse(String.valueOf(sb));
        JsonArray jsonArray = (JsonArray) jsonObject.get("items");
        for (Integer i = 0; i < jsonArray.size(); i++) {
            List<String> list = new ArrayList<>();
            JsonObject jsonObject1 = (JsonObject) jsonArray.get(i);
            list.add(String.valueOf(jsonObject1.get("no")));
            list.add(String.valueOf(jsonObject1.get("type")));
            list.add(String.valueOf(jsonObject1.get("inst_nm")));
            list.add(String.valueOf(jsonObject1.get("lctn")));
            list.add(String.valueOf(jsonObject1.get("telno")));
            lists.add(list);
        }
//        rd.close();
//        conn.disconnect();
//        System.out.println(sb.toString());
        model.addAttribute("lists", lists);
        return "/api/hospitalInfo";
    }
}
