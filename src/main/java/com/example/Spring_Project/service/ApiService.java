package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.InfectionDTO;
import com.example.Spring_Project.mapper.ApiMapper;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

@Service
public class ApiService {

    @Autowired
    private ApiMapper apiMapper;

    public void insertInfectionInfo(InfectionDTO infectionDTO) throws Exception {
        apiMapper.insertInfectionInfo(infectionDTO);
    }

    public void scheduler() throws Exception {
        List<String> list = new ArrayList<>();
        StringBuilder urlBuilder = new StringBuilder("https://apis.data.go.kr/1790387/covid19CurrentStatusConfirmations/covid19CurrentStatusConfirmationsJson"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=LKJBg0TUTr8u6PxqJPp2gTaRuOl9vzlXSGB%2FutNU7s765%2F8gb9ahOaNDyYYDpJuo%2BLiDSes3a%2BC70w5APfDzGg%3D%3D"); /*Service Key*/
        urlBuilder.append("&type=json");
        URL url = new URL(urlBuilder.toString());
        System.out.println(url);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
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
        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject;
        JsonObject jsonObject1;
        JsonArray jsonArray;
        JsonObject jsonObject2 = new JsonObject();
        while ((line = rd.readLine()) != null) {
            if (line.contains("response")) {
                jsonObject = (JsonObject) jsonParser.parse(line);
                jsonObject1 = (JsonObject) jsonObject.get("response");
                jsonArray = (JsonArray) jsonObject1.get("result");
                jsonObject2 = (JsonObject) jsonArray.get(0);
                System.out.println(jsonObject2.get("resultCode"));
                InfectionDTO data = new Gson().fromJson(jsonObject2, InfectionDTO.class);

                InfectionDTO infectionDTO = InfectionDTO.builder()
                        .resultCode(data.getResultCode())
                        .resultMsg(data.getResultMsg())
                        .resultCnt(data.getResultCnt())
                        .mmddhh(data.getMmddhh())
                        .mmdd1(data.getMmdd1())
                        .cnt1(data.getCnt1())
                        .rate1(data.getRate1())
                        .mmdd2(data.getMmdd2())
                        .cnt2(data.getCnt2())
                        .rate2(data.getRate2())
                        .mmdd3(data.getMmdd3())
                        .cnt3(data.getCnt3())
                        .rate3(data.getRate3())


                        .mmdd4(data.getMmdd4())
                        .cnt4(data.getCnt4())
                        .rate4(data.getRate4())

                        .mmdd5(data.getMmdd5())
                        .cnt5(data.getCnt5())
                        .rate5(data.getRate5())

                        .mmdd6(data.getMmdd6())
                        .cnt6(data.getCnt6())
                        .rate6(data.getRate6())

                        .mmdd7(data.getMmdd7())
                        .cnt7(data.getCnt7())
                        .rate7(data.getRate7())

                        .mmdd8(data.getMmdd8())
                        .cnt8(data.getCnt8())
                        .rate8(data.getRate8())
                        .status("Y").build();
                this.insertInfectionInfo(infectionDTO);
            }
        }
    }
}
