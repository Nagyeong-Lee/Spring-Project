package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.HospitalDTO;
import com.example.Spring_Project.dto.InfectionByMonthDTO2;
import com.example.Spring_Project.dto.InfectionDTO;
import com.example.Spring_Project.mapper.ApiMapper;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class ApiService {

    @Autowired
    private ApiMapper apiMapper;

    @Transactional
    public void scheduler() throws Exception {
        Integer nextVal = this.getNextVal();
        List<String> list = new ArrayList<>();
        StringBuilder urlBuilder = new StringBuilder("https://apis.data.go.kr/1790387/covid19CurrentStatusConfirmations/covid19CurrentStatusConfirmationsJson"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=LKJBg0TUTr8u6PxqJPp2gTaRuOl9vzlXSGB%2FutNU7s765%2F8gb9ahOaNDyYYDpJuo%2BLiDSes3a%2BC70w5APfDzGg%3D%3D"); /*Service Key*/
        urlBuilder.append("&type=json");
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
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
                InfectionDTO data1 = new Gson().fromJson(jsonObject1, InfectionDTO.class);
                InfectionDTO infectionDTO = InfectionDTO.builder()
                        .infection_seq(nextVal)
                        .resultCode(data1.getResultCode())
                        .resultMsg(data1.getResultMsg())
                        .resultCnt(data1.getResultCnt())
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
                String mmdd = infectionDTO.getMmdd6();
                String cnt = infectionDTO.getCnt6();
                String month = mmdd.substring(0, 2);
                String year = this.getYear();//현재 년도 가져오기
                this.insertInfectionByMonth(mmdd, cnt, month, year);
                Integer currVal = this.getCurrVal();
                this.updateStatus(currVal);
            }
        }
    }

    public void insertInfectionInfo(InfectionDTO infectionDTO) throws Exception {
        apiMapper.insertInfectionInfo(infectionDTO);
    }

    public InfectionDTO getInfectionInfo() throws Exception {
        return apiMapper.getInfectionInfo();
    }

    public Integer getCurrVal() throws Exception {
        return apiMapper.getCurrVal();
    }

    public Integer getNextVal() throws Exception {
        return apiMapper.getNextVal();
    }

    public void updateStatus(Integer infection_seq) throws Exception {
        apiMapper.updateStatus(infection_seq);
    }

    public void insertInfectionByMonth(@RequestParam String mmdd, @RequestParam String cnt, @RequestParam String month, @RequestParam String year) throws Exception {
        apiMapper.insertInfectionByMonth(mmdd, cnt, month, year);
    }

    public String getYear() throws Exception {
        return apiMapper.getYear();
    }

    public List<InfectionByMonthDTO2> getInfectionByMonthInfo() throws Exception {
        return apiMapper.getInfectionByMonthInfo();
    }

    public List<HospitalDTO> getHospitalInfo(String searchType, String keyword, Integer start, Integer end, String city) throws Exception {
        return apiMapper.getHospitalInfo(searchType, keyword, start, end, city);
    }

    public List<HospitalDTO> test(String searchType, String keyword, Integer start, Integer end, String city) throws Exception {
        return apiMapper.test(searchType, keyword, start, end, city);
    }

    public HospitalDTO getInfo(Integer hospital_seq) throws Exception {
        return apiMapper.getInfo(hospital_seq);
    }

    public Integer countPost(String searchType, String keyword, String city) throws Exception {
        return apiMapper.countPost(searchType, keyword, city);
    }

    //옵션 선택
    public List<String> getCity() throws Exception {
        return apiMapper.getCity();
    }

    public List<String> getWeekOpen() throws Exception {
        return apiMapper.getWeekOpen();
    }

    public List<String> getWeekClose() throws Exception {
        return apiMapper.getWeekClose();
    }

    public List<String> getSatOpen() throws Exception {
        return apiMapper.getSatOpen();
    }

    public List<String> getSatClose() throws Exception {
        return apiMapper.getSatClose();
    }

    public List<String> getHolidayYN() throws Exception {
        return apiMapper.getHolidayYN();
    }

    public List<String> getHolidayOpen() throws Exception {
        return apiMapper.getHolidayOpen();
    }

    public List<String> getHolidayClose() throws Exception {
        return apiMapper.getHolidayClose();
    }

    //페이징 처리
    public String getHospitalPageNavi(Integer currentPage, Integer count, String searchType, String keyword, String city) throws Exception {
        int postTotalCount = this.countPost(searchType, keyword, city);

        int recordCountPerPage = count; // 페이지 당 게시글 개수
        int naviCountPerPage = 10; // 내비 개수

        int pageTotalCount = 0; // 전체 내비 수
        if (postTotalCount % recordCountPerPage > 0) {
            pageTotalCount = postTotalCount / recordCountPerPage + 1;
        } else {
            pageTotalCount = postTotalCount / recordCountPerPage;
        }

        if (currentPage < 1) {
            currentPage = 1;
        } else if (currentPage > pageTotalCount) {
            currentPage = pageTotalCount;
        }

        int startNavi = (currentPage - 1) / naviCountPerPage * naviCountPerPage + 1; // 페이지 시작 내비 값
        int endNavi = startNavi + naviCountPerPage - 1; // 페이지 마지막 내비 값

        if (endNavi > pageTotalCount) {
            endNavi = pageTotalCount;
        }
        boolean needPrev = true;
        boolean needNext = true;

        if (startNavi == 1) {
            needPrev = false;
        }
        if (endNavi == pageTotalCount) {
            needNext = false;
        }

        StringBuilder sb = new StringBuilder();

        if (needPrev) {
            if (searchType == null && keyword == null) {
                sb.append("<a href='/api/hospital?currentPage=" + (startNavi - 1) + "&count=" + count + "&searchType=&keyword=" + "'><</a> ");
            } else {
                sb.append("<a href='/api/hospital?currentPage=" + (startNavi - 1) + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'><</a> ");
            }
        }
        for (int i = startNavi; i <= endNavi; i++) {
            if (currentPage == i) {
                if (searchType == null && keyword == null) {
                    sb.append("<a href='/api/hospital?currentPage=" + i + "&count=" + count + "&searchType=" + "&keyword=" + "'><b>" + i + "</b></a> ");
                } else {
                    sb.append("<a href='/api/hospital?currentPage=" + i + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'><b>" + i + "</b></a> ");
                }
            } else {
                if (searchType == null && keyword == null) {
                    sb.append("<a href='/api/hospital?currentPage=" + i + "&count=" + count + "&searchType=" + "&keyword=" + "'>" + i + "</a> ");
                } else {
                    sb.append("<a href='/api/hospital?currentPage=" + i + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'>" + i + "</a> ");
                }
            }
        }
        if (needNext) {
            if (searchType == null && keyword == null) {
                sb.append("<a href='/api/hospital?currentPage=" + (endNavi + 1) + "&count=" + count + "&searchType=" + "&keyword=" + "'>></a> ");
            } else {
                sb.append("<a href='/api/hospital?currentPage=" + (endNavi + 1) + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'>></a> ");
            }
        }
        return sb.toString();
    }

    public List<HospitalDTO> test2(Map<String, Object> paramMap) {
        return apiMapper.test2(paramMap);
    }
}
