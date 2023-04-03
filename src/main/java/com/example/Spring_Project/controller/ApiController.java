package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.InfectionDTO;
import com.example.Spring_Project.service.ApiService;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.apache.xmlbeans.soap.SOAPArrayType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.relational.core.sql.In;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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

    @Scheduled(cron = "0 22 * * *") //매일 10시
    public void method() throws Exception{
        apiService.scheduler();
    }
//    @PostMapping("/data")
    //배치 돌려서
    //값이 동일하면 insert 안하고
    //값이 다르면 update
//    public String api(Model model) throws Exception {
//        List<String> list = new ArrayList<>();
//        StringBuilder urlBuilder = new StringBuilder("https://apis.data.go.kr/1790387/covid19CurrentStatusConfirmations/covid19CurrentStatusConfirmationsJson"); /*URL*/
//        urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=LKJBg0TUTr8u6PxqJPp2gTaRuOl9vzlXSGB%2FutNU7s765%2F8gb9ahOaNDyYYDpJuo%2BLiDSes3a%2BC70w5APfDzGg%3D%3D"); /*Service Key*/
//        urlBuilder.append("&type=json");
//        URL url = new URL(urlBuilder.toString());
//        System.out.println(url);
//        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//        conn.setRequestMethod("POST");
//        conn.setRequestProperty("Content-type", "application/json");
//        System.out.println("Response code: " + conn.getResponseCode());
//        BufferedReader rd;
//        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
//            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
//        } else {
//            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
//        }
//        StringBuilder sb = new StringBuilder();
//        String line;
//        JsonParser jsonParser = new JsonParser();
//        JsonObject jsonObject;
//        JsonObject jsonObject1;
//        JsonArray jsonArray;
//        JsonObject jsonObject2 = new JsonObject();
//        while ((line = rd.readLine()) != null) {
//            if (line.contains("response")) {
//                jsonObject = (JsonObject) jsonParser.parse(line);
//                jsonObject1 = (JsonObject) jsonObject.get("response");
//                jsonArray = (JsonArray) jsonObject1.get("result");
//                jsonObject2 = (JsonObject) jsonArray.get(0);
//                        System.out.println(jsonObject2.get("resultCode"));
//                InfectionDTO data = new Gson().fromJson(jsonObject2, InfectionDTO.class);
//
//                InfectionDTO infectionDTO = InfectionDTO.builder()
//                        .resultCode(data.getResultCode())
//                        .resultMsg(data.getResultMsg())
//                        .resultCnt(data.getResultCnt())
//                        .mmddhh(data.getMmddhh())
//                        .mmdd1(data.getMmdd1())
//                        .cnt1(data.getCnt1())
//                        .rate1(data.getRate1())
//                        .mmdd2(data.getMmdd2())
//                        .cnt2(data.getCnt2())
//                        .rate2(data.getRate2())
//                        .mmdd3(data.getMmdd3())
//                        .cnt3(data.getCnt3())
//                        .rate3(data.getRate3())
//
//
//                        .mmdd4(data.getMmdd4())
//                        .cnt4(data.getCnt4())
//                        .rate4(data.getRate4())
//
//                        .mmdd5(data.getMmdd5())
//                        .cnt5(data.getCnt5())
//                        .rate5(data.getRate5())
//
//                        .mmdd6(data.getMmdd6())
//                        .cnt6(data.getCnt6())
//                        .rate6(data.getRate6())
//
//                        .mmdd7(data.getMmdd7())
//                        .cnt7(data.getCnt7())
//                        .rate7(data.getRate7())
//
//                        .mmdd8(data.getMmdd8())
//                        .cnt8(data.getCnt8())
//                        .rate8(data.getRate8())
//                        .status("Y").build();
//            apiService.insertInfectionInfo(infectionDTO);
//            }
//                    sb.append(line);
//        }
////        } catch (Exception e) {
////            e.printStackTrace();
////        }
////        model.addAttribute("mmdd1", String.valueOf(jsonObject2.get("mmdd1")));
////        model.addAttribute("cnt1", String.valueOf(jsonObject2.get("cnt1")));
////        model.addAttribute("mmdd2", String.valueOf(jsonObject2.get("mmdd2")));
////        model.addAttribute("cnt2", String.valueOf(jsonObject2.get("cnt2")));
////        model.addAttribute("mmdd3", String.valueOf(jsonObject2.get("mmdd3")));
////        model.addAttribute("cnt3", String.valueOf(jsonObject2.get("cnt3")));
////        model.addAttribute("mmdd4", String.valueOf(jsonObject2.get("mmdd4")));
////        model.addAttribute("cnt4", String.valueOf(jsonObject2.get("cnt4")));
////        model.addAttribute("mmdd5", String.valueOf(jsonObject2.get("mmdd5")));
////        model.addAttribute("cnt5", String.valueOf(jsonObject2.get("cnt5")));
////        model.addAttribute("mmdd6", String.valueOf(jsonObject2.get("mmdd6")));
////        model.addAttribute("cnt6", String.valueOf(jsonObject2.get("cnt6")));
////        model.addAttribute("mmdd7", String.valueOf(jsonObject2.get("mmdd7")));
////        model.addAttribute("cnt7", String.valueOf(jsonObject2.get("cnt7")));
////        model.addAttribute("mmdd8", String.valueOf(jsonObject2.get("mmdd8")));
////        model.addAttribute("cnt8", String.valueOf(jsonObject2.get("cnt8")));
//        return"/api/infectionChart";
//}

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
