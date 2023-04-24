package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.*;
import com.example.Spring_Project.mapper.ApiMapper;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
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

    public  void  covid() throws Exception {
        //        String encode = Base64.getEncoder().encodeToString(query.getBytes(StandardCharsets.UTF_8));

        String keyword="코로나";
        URI uri = UriComponentsBuilder.fromUriString("https://openapi.naver.com/")
                .path("v1/search/news.json")
                .queryParam("query", keyword)
                .queryParam("display", 100)
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
            String parsedTitle = jsonObject2.get("title").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("title").toString().length() - 1);
            String parsedLink = jsonObject2.get("link").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("link").toString().length() - 1);
            String parsedDescription = jsonObject2.get("description").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("description").toString().length() - 1);
            map.put("title", parsedTitle);
            map.put("link", parsedLink);
            map.put("keyword", keyword);
            map.put("description", parsedDescription);
            apiMapper.upd2(map);
        }
    }

    public void quarantine() throws Exception {
        String keyword="자가격리";
        URI uri = UriComponentsBuilder.fromUriString("https://openapi.naver.com/")
                .path("v1/search/news.json")
                .queryParam("query", keyword)
                .queryParam("display", 100)
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
            String parsedTitle = jsonObject2.get("title").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("title").toString().length() - 1);
            String parsedLink = jsonObject2.get("link").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("link").toString().length() - 1);
            String parsedDescription = jsonObject2.get("description").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("description").toString().length() - 1);
            map.put("title", parsedTitle);
            map.put("link", parsedLink);
            map.put("keyword", keyword);
            map.put("description", parsedDescription);
            apiMapper.upd2(map);
        }
    }

    public void distancing() throws Exception {
        //        String encode = Base64.getEncoder().encodeToString(query.getBytes(StandardCharsets.UTF_8));
        String keyword = "거리두기";
        URI uri = UriComponentsBuilder.fromUriString("https://openapi.naver.com/")
                .path("v1/search/news.json")
                .queryParam("query", keyword)
                .queryParam("display", 100)
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
            String parsedTitle = jsonObject2.get("title").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("title").toString().length() - 1);
            String parsedLink = jsonObject2.get("link").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("link").toString().length() - 1);
            String parsedDescription = jsonObject2.get("description").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("description").toString().length() - 1);
            map.put("title", parsedTitle);
            map.put("link", parsedLink);
            map.put("keyword", keyword);
            map.put("description", parsedDescription);
            apiMapper.upd2(map);
        }
    }

    public void mask() throws Exception {
        //        String encode = Base64.getEncoder().encodeToString(query.getBytes(StandardCharsets.UTF_8));
        String keyword="마스크";
        URI uri = UriComponentsBuilder.fromUriString("https://openapi.naver.com/")
                .path("v1/search/news.json")
                .queryParam("query", keyword)
                .queryParam("display", 100)
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
            String parsedTitle = jsonObject2.get("title").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("title").toString().length() - 1);
            String parsedLink = jsonObject2.get("link").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("link").toString().length() - 1);
            String parsedDescription = jsonObject2.get("description").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("description").toString().length() - 1);
            map.put("title", parsedTitle);
            map.put("link", parsedLink);
            map.put("keyword", keyword);
            map.put("description", parsedDescription);
            apiMapper.upd2(map);
        }
    }

    public void vaccine() throws Exception {
        String keyword="백신";
        URI uri = UriComponentsBuilder.fromUriString("https://openapi.naver.com/")
                .path("v1/search/news.json")
                .queryParam("query", keyword)
                .queryParam("display", 100)
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
            String parsedTitle = jsonObject2.get("title").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("title").toString().length() - 1);
            String parsedLink = jsonObject2.get("link").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("link").toString().length() - 1);
            String parsedDescription = jsonObject2.get("description").toString().substring(1, ((JsonObject) jsonArray.get(i)).get("description").toString().length() - 1);
            map.put("title", parsedTitle);
            map.put("link", parsedLink);
            map.put("keyword", keyword);
            map.put("description", parsedDescription);
            apiMapper.upd2(map);
        }
    }

    //뉴스 db 업데이트 함수
    @Transactional
    public void commonUpdate(List<Map<String, Object>> news, List<NewsDTO> list, String keyword, List<Map<String, Object>> newLinks, Integer isLinkEmpty) throws Exception {
        for (Integer i = 0; i < news.size(); i++) {
            for (Integer k = 0; k < list.size(); k++) {
                isLinkEmpty = this.isLinkEmpty(news.get(i).get("link").toString(), keyword);
                if (isLinkEmpty != 0) {
                    this.updateNewsStatus(news.get(i).get("link").toString(), keyword); //있으면 Y로
                } else {
                    Map<String, Object> newLinksMap = new HashMap<>(); //없으면 list에 저장
                    newLinksMap.put("link", news.get(i).get("link").toString());
                    newLinksMap.put("title", news.get(i).get("title").toString());
                    newLinksMap.put("description", news.get(i).get("description").toString());
                    newLinks.add(newLinksMap);
                    break;
                }
            }
        }
        List<NewsDTO> link = this.getStatusN(keyword);
        for (Integer i = 0; i < link.size(); i++) {
            Map<String, Object> map = new HashMap<>();
            map.put("keyword", keyword);
            map.put("link", link.get(i).getLink());
            map.put("title", link.get(i).getTitle());
            map.put("description", link.get(i).getDescription());
            //나중거로 변경
            map.put("updLink", newLinks.get(i).get("link").toString());
            map.put("updTitle", newLinks.get(i).get("title").toString());
            map.put("updDescription", newLinks.get(i).get("description").toString());
            this.updateLink(map);
        }
        this.updStatusToN(keyword);
    }


    //코로나 뉴스
    public synchronized void getNewsCovid() throws Exception {
//      this.insertNews(this.covid()); //처음에 인서트
        String keyword = "코로나";
        Integer isLinkEmpty = 0;
        //List<NewsDTO> list = this.getCovidNews(keyword); //저장된 코로나 뉴스

//        List<Map<String, Object>> news = this.covid(); //실시간 코로나 뉴스
//        System.out.println("코로나  : "+news);
//        apiMapper.upd(news);

        //List<Map<String, Object>> newLinks = new ArrayList<>();
        //this.commonUpdate(news, list, keyword, newLinks, isLinkEmpty);
    }

    //merge into
    public synchronized void upd(List<Map<String, Object>> news) throws Exception{
        System.out.println("upd : "+news);
        apiMapper.upd(news);
    }

    //자가격리 뉴스
    public synchronized void getNewsQuarantine() throws Exception {
//        this.insertNews(this.quarantine());
        String keyword = "자가격리";
        //Integer isLinkEmpty = 0;
        //List<NewsDTO> list = this.getCovidNews(keyword); //저장된 자가격리 뉴스
//        List<Map<String, Object>> news = this.quarantine(); //실시간 자가격리 뉴스
//        System.out.println("자가격리  : "+news);
//        apiMapper.upd(news);
        //this.upd(news);
        //List<Map<String, Object>> newLinks = new ArrayList<>();
        //this.commonUpdate(news, list, keyword, newLinks, isLinkEmpty);
    }

    //거리두기 뉴스
//    public void getNewsDistance() throws Exception {
////        this.insertNews(this.distancing());
//        String keyword = "거리두기";
//        Integer isLinkEmpty = 0;
//        List<NewsDTO> list = this.getCovidNews(keyword); //저장된 거리두기 뉴스
//        List<Map<String, Object>> news = this.distancing(); //실시간 거리두기 뉴스
//        List<Map<String, Object>> newLinks = new ArrayList<>();
//        this.commonUpdate(news, list, keyword, newLinks, isLinkEmpty);
//    }

    //마스크 뉴스
//    public void getNewsMask() throws Exception {
////        this.insertNews(this.mask());
//        String keyword = "마스크";
//        Integer isLinkEmpty = 0;
//        List<NewsDTO> list = this.getCovidNews(keyword); //저장된 거리두기 뉴스
//        List<Map<String, Object>> news = this.mask(); //실시간 거리두기 뉴스
//        List<Map<String, Object>> newLinks = new ArrayList<>();
//        this.commonUpdate(news, list, keyword, newLinks, isLinkEmpty);
//    }

    //백신 뉴스
//    public void getNewsVaccine() throws Exception {
////        this.insertNews(this.vaccine());
//        String keyword = "백신";
//        Integer isLinkEmpty = 0;
//        List<NewsDTO> list = this.getCovidNews(keyword); //저장된 거리두기 뉴스
//        List<Map<String, Object>> news = this.vaccine(); //실시간 거리두기 뉴스
//        List<Map<String, Object>> newLinks = new ArrayList<>();
//        this.commonUpdate(news, list, keyword, newLinks, isLinkEmpty);
//    }

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

    public void insertInfectionByMonth(@RequestParam String mmdd, @RequestParam String cnt, @RequestParam String
            month, @RequestParam String year) throws Exception {
        apiMapper.insertInfectionByMonth(mmdd, cnt, month, year);
    }

    public String getYear() throws Exception {
        return apiMapper.getYear();
    }

    public List<InfectionByMonthDTO2> getInfectionByMonthInfo() throws Exception {
        return apiMapper.getInfectionByMonthInfo();
    }

    public List<HospitalDTO> getHospitalInfo(String searchType, String keyword, Integer start, Integer end, String
            city) throws Exception {
        return apiMapper.getHospitalInfo(searchType, keyword, start, end, city);
    }

//    public List<HospitalDTO> test(String searchType, String keyword, Integer start, Integer end) throws Exception {
//        return apiMapper.test(searchType, keyword, start, end);
//    }

    public List<HospitalDTO> test(Map<String, Object> paramMap) {
        return apiMapper.test(paramMap);
    }

    public HospitalDTO getInfo(Integer hospital_seq) throws Exception {
        return apiMapper.getInfo(hospital_seq);
    }

    //    public Integer countPost(String searchType, String keyword) throws Exception {
//        return apiMapper.countPost(searchType, keyword);
//    }
    public Integer countPost(String searchType, String keyword, String cityOption, String weekOpenOption,
                             String weekCloseOption, String satOpenOption, String satCloseOption, String holidayYNOption, String
                                     holidayY, String holidayN, String holidayOpenOption, String holidayCloseOption) throws Exception {
        return apiMapper.countPost(searchType, keyword, cityOption, weekOpenOption, weekCloseOption, satOpenOption, satCloseOption, holidayYNOption, holidayY, holidayN, holidayOpenOption, holidayCloseOption);
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
//    public String getHospitalPageNavi(Integer currentPage, Integer count, String searchType, String keyword) throws Exception {
//        int postTotalCount = this.countPost(searchType, keyword);
//
//        int recordCountPerPage = count; // 페이지 당 게시글 개수
//        int naviCountPerPage = 10; // 내비 개수
//
//        int pageTotalCount = 0; // 전체 내비 수
//        if (postTotalCount % recordCountPerPage > 0) {
//            pageTotalCount = postTotalCount / recordCountPerPage + 1;
//        } else {
//            pageTotalCount = postTotalCount / recordCountPerPage;
//        }
//
//        if (currentPage < 1) {
//            currentPage = 1;
//        } else if (currentPage > pageTotalCount) {
//            currentPage = pageTotalCount;
//        }
//
//        int startNavi = (currentPage - 1) / naviCountPerPage * naviCountPerPage + 1; // 페이지 시작 내비 값
//        int endNavi = startNavi + naviCountPerPage - 1; // 페이지 마지막 내비 값
//
//        if (endNavi > pageTotalCount) {
//            endNavi = pageTotalCount;
//        }
//        boolean needPrev = true;
//        boolean needNext = true;
//
//        if (startNavi == 1) {
//            needPrev = false;
//        }
//        if (endNavi == pageTotalCount) {
//            needNext = false;
//        }
//
//        StringBuilder sb = new StringBuilder();
//        System.out.println("startNavi : " + startNavi);
//        System.out.println("endNavi : " + endNavi);
//        if (needPrev) {
//            if (searchType == null && keyword == null) {
//                sb.append("<a href='/api/hospital?currentPage=" + (startNavi - 1) + "&count=" + count + "&searchType=&keyword=" + "'><</a> ");
//            } else {
//                sb.append("<a href='/api/hospital?currentPage=" + (startNavi - 1) + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'><</a> ");
//            }
//        }
//        for (int i = startNavi; i <= endNavi; i++) {
//                        if (currentPage == i) {
//                            if (searchType == null && keyword == null) {
//                                sb.append("<a href='/api/hospital?currentPage=" + i + "&count=" + count + "&searchType=" + "&keyword=" + "'><b>" + i + "</b></a> ");
//                            } else {
//                                sb.append("<a href='/api/hospital?currentPage=" + i + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'><b>" + i + "</b></a> ");
//                            }
//                        } else {
//                            if (searchType == null && keyword == null) {
//                                sb.append("<a href='/api/hospital?currentPage=" + i + "&count=" + count + "&searchType=" + "&keyword=" + "'>" + i + "</a> ");
//                            } else {
//                                sb.append("<a href='/api/hospital?currentPage=" + i + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'>" + i + "</a> ");
//                }
//            }
//        }
//        if (needNext) {
//            if (searchType == null && keyword == null) {
//                sb.append("<a href='/api/hospital?currentPage=" + (endNavi + 1) + "&count=" + count + "&searchType=" + "&keyword=" + "'>></a> ");
//            } else {
//                sb.append("<a href='/api/hospital?currentPage=" + (endNavi + 1) + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'>></a> ");
//            }
//        }
//        return sb.toString();
//    }


    //페이징 처리
//    public Map<String,Object> getHospitalPageNavi2(Integer currentPage, Integer count, String searchType, String keyword) throws Exception {
    public Map<String, Object> getHospitalPageNavi2(Integer currentPage, Integer count, String searchType, String
            keyword, String cityOption, String weekOpenOption,
                                                    String weekCloseOption, String satOpenOption, String satCloseOption, String holidayYNOption, String
                                                            holidayY, String holidayN, String holidayOpenOption, String holidayCloseOption) throws Exception {
        Map<String, Object> reMap = new HashMap<>();
//        int postTotalCount = this.countPost(searchType, keyword);
        int postTotalCount = this.countPost(searchType, keyword
                , cityOption, weekOpenOption, weekCloseOption, satOpenOption, satCloseOption, holidayYNOption, holidayY, holidayN, holidayOpenOption, holidayCloseOption);

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

        System.out.println("startNavi : " + startNavi);
        System.out.println("endNavi : " + endNavi);
        System.out.println("전체 글 개수 : " + pageTotalCount);

        reMap.put("pageTotalCount", pageTotalCount);
        reMap.put("startNavi", startNavi);
        reMap.put("endNavi", endNavi);
        reMap.put("needPrev", needPrev);
        reMap.put("needNext", needNext);
        return reMap;
    }


    //뉴스 커뮤니티 페이징1
    public Map<String, Object> newsPaging1(Integer currentPage, Integer count) throws Exception {
        Map<String, Object> reMap = new HashMap<>();
        int postTotalCount = this.countWholeNews();

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

        System.out.println("startNavi : " + startNavi);
        System.out.println("endNavi : " + endNavi);
        System.out.println("전체 글 개수 : " + pageTotalCount);

        reMap.put("pageTotalCount", pageTotalCount);
        reMap.put("startNavi", startNavi);
        reMap.put("endNavi", endNavi);
        reMap.put("needPrev", needPrev);
        reMap.put("needNext", needNext);
        return reMap;
    }

    //뉴스 커뮤니티 페이징2
    public Map<String, Object> newsPaging2(Integer currentPage, Integer count,String keyword) throws Exception {
        System.out.println("APIService : " + keyword);
        if(keyword == null || keyword == "" || keyword.length() != 0){
            System.out.println("key  변경");
            keyword="all";
        }
        Map<String, Object> reMap = new HashMap<>();
        int postTotalCount = this.countNews(keyword);

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

        System.out.println("startNavi : " + startNavi);
        System.out.println("endNavi : " + endNavi);
        System.out.println("전체 글 개수 : " + pageTotalCount);

        reMap.put("pageTotalCount", pageTotalCount);
        reMap.put("startNavi", startNavi);
        reMap.put("endNavi", endNavi);
        reMap.put("needPrev", needPrev);
        reMap.put("needNext", needNext);
        return reMap;
    }

    public List<HospitalDTO> test2(Map<String, Object> paramMap) {
        return apiMapper.test2(paramMap);
    }

    public List<CodeInfoDTO> getCode_info() throws Exception {
        return apiMapper.getCode_Info();
    }

    public void insertNews(List<Map<String, Object>> list) throws Exception {
        apiMapper.insertNews(list);
    }

    //키워드로 뉴스 가져오기
    public List<NewsDTO> getCovidNews(String keyword) throws Exception {
        return apiMapper.getCovidNews(keyword);
    }

    //실시간 뉴스랑 비교
    public Integer isLinkEmpty(String link, String keyword) throws Exception {
        return apiMapper.isLinkEmpty(link, keyword);
    }

    //뉴스 업데이트
    public void updateLink(Map<String, Object> map) throws Exception {
        apiMapper.updateLink(map);
    }

    public void updateNewsStatus(String link, String keyword) throws Exception {
        apiMapper.updateNewsStatus(link, keyword);
    }

    public List<NewsDTO> getStatusN(String keyword) throws Exception {
        return apiMapper.getStatusN(keyword);
    }

    //키워드별 뉴스 가져오기
    public List<NewsDTO> getNewsByKeyword(Integer start,Integer end,String keyword) throws Exception {
        return apiMapper.getNewsByKeyword(start,end,keyword);
    }

    //마지막에 상태 n으로
    public void updStatusToN(String keyword) throws Exception {
        apiMapper.updateStatusToN(keyword);
    }

    //전체 뉴스 가져오기
    public List<NewsDTO> getNewsList(Integer start,Integer end) throws Exception {
        return apiMapper.getNewsList(start,end);
    }

    public Integer countNews(String keyword) throws Exception{
        return apiMapper.countNews(keyword);
    }

    public Integer countWholeNews() throws Exception{
        return apiMapper.countWholeNews();
    }
}

