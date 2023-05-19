package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.ImgDTO;
import com.example.Spring_Project.dto.ParsedReviewDTO2;
import com.example.Spring_Project.dto.ProductDTO;
import com.example.Spring_Project.dto.ReviewDTO;
import com.example.Spring_Project.mapper.PdReviewMapper;
import com.google.gson.*;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.server.Jsp;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.Reader;
import java.util.*;

@Service
public class PdReviewService {
    @Autowired
    private PdReviewMapper pdReviewMapper;

    @Autowired
    private QnAService qnAService;


    //review insert
    public void reviewInsert(Map<String, Object> param) throws Exception {
        pdReviewMapper.reviewInsert(param);
    }

    //현재 reviewSeq
    public Integer currRevSeq() throws Exception {
        return pdReviewMapper.currRevSeq();
    }

    public void imgInsert(List<MultipartFile> file, HttpServletRequest request, Integer review_seq) throws Exception {

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        if (file != null) {  //파일 인서트
            String path = "/resources/img/products/pdReview";
            String realPath = request.getServletContext().getRealPath(path); //webapp 폴더
            File filePath = new File(realPath);

            if (!filePath.exists()) {
                filePath.mkdir(); //파일업로드 폴더가 없다면 생성
            }

            for (MultipartFile f : file) {
                Map<String, Object> map = new HashMap<>();
                String oriname = f.getOriginalFilename();
                UUID uuid = UUID.randomUUID();
                String sysname = uuid + "_" + oriname;
                String imgSavePath = filePath + "/" + sysname;

                f.transferTo(new File(imgSavePath));
                map.put("review_seq", review_seq);
                map.put("oriname", oriname);
                map.put("sysname", sysname);
                map.put("imgSavePath", imgSavePath);
                list.add(map);
            }
            insertReviewImg(list);
        }
    }

    //img insert
    public void insertReviewImg(List<Map<String, Object>> param) throws Exception {
        pdReviewMapper.insertReviewImg(param);
    }


    public ReviewDTO reviewInfo(Integer payPd_seq) throws Exception {
        return pdReviewMapper.reviewInfo(payPd_seq);
    }

    //review detail
    public ReviewDTO reviewDetail(Integer review_seq) throws Exception {
        return pdReviewMapper.reviewDetail(review_seq);
    }

    //이미지 여부 체크
    public Integer checkImgExist(Integer review_seq) throws Exception {
        return pdReviewMapper.checkImgExist(review_seq);
    }

    public List<ImgDTO> getReviewImg(Integer review_seq) throws Exception {
        return pdReviewMapper.getReviewImg(review_seq);
    }

    //이미지 정보
    public List<ImgDTO> imgList(Integer review_seq) throws Exception {
        List<ImgDTO> imgDTOList = getReviewImg(review_seq);
        return imgDTOList;
    }

    //delete review

    @Transactional
    public void deleteReview(Integer review_seq) throws Exception {
        pdReviewMapper.deleteReview(review_seq); //리뷰 삭제
        Integer isRevImgExist = pdReviewMapper.isImgExist(review_seq);
        if (isRevImgExist != 0) { //img있으면 img삭제
            List<Integer> deleteSeq = pdReviewMapper.reviewImgs(review_seq);
            pdReviewMapper.deleteImg(deleteSeq);
        }
    }

    //review detail 수정
    public void updReviewDetail(Map<String, Object> param) throws Exception {
        pdReviewMapper.updReviewDetail(param);
    }

    //이미지 삭제
    public void deleteImg(List<Integer> deleteSeq) throws Exception {
        pdReviewMapper.deleteImg(deleteSeq);
    }

    //상품 별점평균
    public Double starAvg(Integer pd_seq) throws Exception {
        return pdReviewMapper.starAvg(pd_seq);
    }

    //상품 리뷰 개수
    public Integer reviewCnt(Integer pd_seq) throws Exception {
        return pdReviewMapper.reviewCnt(pd_seq);
    }

    //상품 리뷰들 가져오기
    public List<ReviewDTO> getReviewByPd_seq(Integer pd_seq) throws Exception {
        return pdReviewMapper.getReviewByPd_seq(pd_seq);
    }

    //리뷰에 이미지 있는지
    public Integer isImgExist(Integer review_seq) throws Exception {
        return pdReviewMapper.isImgExist(review_seq);
    }

    public Map<String, Object> reviewInPdDetail(Integer pd_seq, Integer payPd_seq) throws Exception {
        return pdReviewMapper.reviewInPdDetail(pd_seq, payPd_seq);
    }

    public List<String> reviewImgsByPd_seq(Integer pd_seq) throws Exception {
        return pdReviewMapper.reviewImgsByPd_seq(pd_seq);
    }

    public List<Map<String, Object>> reviewInfoList(List<ReviewDTO> reviewDTO, Integer pd_seq) throws Exception {
        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject = new JsonObject();
        JsonArray jsonArray = new JsonArray();
        List<Map<String, Object>> reviewInfoList = new ArrayList<>();
        List<Map<String, Object>> optionMapList = null;
        for (ReviewDTO dto : reviewDTO) {
            Map<String, Object> map = new HashMap<>();
            Integer review_seq = dto.getReview_seq();
            Integer isImgExist = isImgExist(review_seq);
            Map<String, Object> reviewInPdDetail = reviewInPdDetail(pd_seq, dto.getPayPd_seq()); //join해서 detailReview에 필요한 데이터
            if (reviewInPdDetail.get("PDOPTION") != null) {
                Object object = jsonParser.parse(reviewInPdDetail.get("PDOPTION").toString());
                jsonObject = (JsonObject) object;
                jsonArray = (JsonArray) jsonObject.get("name");
                optionMapList = new ArrayList<>();
                Map<String, Object> optionMap = null;
                for (int i = 0; i < jsonArray.size(); i++) {
                    optionMap = new HashMap<>();
                    //size = s
                    String optName = jsonArray.get(i).toString().replace("\"", "");
                    String optCategory = optionCategory(pd_seq, optName); //옵션 카테고리 이름 가져오기 (size)
                    optionMap.put(optCategory, optName);
                    optionMapList.add(optionMap);
                }
            }
            map.put("reviewInPdDetail", reviewInPdDetail);
            map.put("optionMapList", optionMapList);
            List<String> imgSysname = null;
            //review img
            if (isImgExist != 0) { //img 있으면 map put
                List<ImgDTO> imgDTOList = getReviewImg(review_seq);
                imgSysname = new ArrayList<>();
                for (ImgDTO imgDTO : imgDTOList) {
                    imgSysname.add(imgDTO.getSysname());
                }
            }
            map.put("imgSysname", imgSysname);
            reviewInfoList.add(map);
        }
        return reviewInfoList;
    }

    public String optionCategory(Integer pd_seq, String optName) throws Exception {
        return pdReviewMapper.optionCategory(pd_seq, optName);
    }

    public List<Map<String, Object>> getReviews(List<Integer> pdSeqs, Integer star) throws Exception {
        return pdReviewMapper.getReviews(pdSeqs, star);
    }

    public ProductDTO pdInfo(Integer pd_seq) throws Exception {
        return pdReviewMapper.pdInfo(pd_seq);
    }

    public List<Map<String, Object>> reviewList(List<Map<String, Object>> reviewDTOS) throws Exception {
        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject = new JsonObject();
        JsonArray jsonArray = new JsonArray();
        List<Map<String, Object>> optionMapList = null;
        List<Map<String, Object>> reviewList = new ArrayList<>();
        Map<String, Object> option = new HashMap<>();
        Integer size = reviewDTOS.size();
        for (int i = 0; i < size; i++) {
            Map<String, Object> map = new HashMap<>();
            ProductDTO productDTO = pdInfo(Integer.parseInt(reviewDTOS.get(i).get("PD_SEQ").toString()));
            map.put("productDTO", productDTO);
            map.put("reviewDTOS", reviewDTOS.get(i));
            map.put("totalPrice", reviewDTOS.get(i).get("PRICE"));

            //리뷰 이미지 있으면
            List<String> revImg = new ArrayList<>(); //sysname
            if (reviewDTOS.get(i).get("REVIMG_SEQ") != null) {
                JsonObject jsonObject1 = (JsonObject) jsonParser.parse(reviewDTOS.get(i).get("REVIMG_SEQ").toString());
                JsonArray jsonArray1 = (JsonArray) jsonObject1.get("seq");
                for (int k = 0; k < jsonArray1.size(); k++) {
                    Integer imgSeq = Integer.parseInt(String.valueOf(jsonArray1.get(k)));
                    String revImgSysname = pdReviewMapper.getRevImgSysname(imgSeq);
                    revImg.add(revImgSysname);
                }
                map.put("revImgSysname", revImg);
            }

            //옵션 있으면
            if (reviewDTOS.get(i).get("PDOPTION")  != null) {   //옵션 있으면
                JsonObject jsonObject1 = (JsonObject) jsonParser.parse(reviewDTOS.get(i).get("PDOPTION").toString());
                JsonArray jsonArray1 = (JsonArray) jsonObject1.get("name");
                optionMapList = new ArrayList<>();
                Map<String, Object> optionMap = null;
                for (int k = 0; k < jsonArray1.size(); k++) {
                    optionMap = new HashMap<>();
//                    //size = s
                    String optName = jsonArray1.get(k).toString().replace("\"", "");
                    String optCategory = optionCategory(productDTO.getPd_seq(), optName); //옵션 카테고리 이름 가져오기 (size)
                    optionMap.put(optCategory, optName);
                    optionMapList.add(optionMap);
                }
                map.put("optionMapList", optionMapList);
            }
            reviewList.add(map);
        }
        return reviewList;
    }

    public List<Map<String, Object>> getReviewsByOption(Map<String, Object> data) throws Exception {
        return pdReviewMapper.getReviewsByOption(data);
    }

    public Map<String, Object> getReviewImgs(Integer review_seq) throws Exception {
        return pdReviewMapper.getReviewImgs(review_seq);
    }

    public List<Map<String, Object>> reviewListByOptions(List<ParsedReviewDTO2> objectList) throws Exception {

        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject = new JsonObject();
        JsonArray jsonArray = new JsonArray();
        List<Map<String, Object>> optionMapList = null;
        List<Map<String, Object>> reviewList = new ArrayList<>();
//        Map<String, Object> option = new HashMap<>();
        for (ParsedReviewDTO2 parsedReviewDTO2 : objectList) {
            Map<String, Object> map = new HashMap<>();
            ProductDTO productDTO = pdInfo(parsedReviewDTO2.getPd_seq());
            map.put("productDTO", productDTO);
            map.put("parsedReviewDTO2", parsedReviewDTO2);
            map.put("totalPrice", parsedReviewDTO2.getPrice() * parsedReviewDTO2.getStock());

            //리뷰 이미지 있으면
            List<String> revImg = new ArrayList<>(); //sysname
            if (parsedReviewDTO2.getRevImg_seq() != null) {
                JsonObject jsonObject1 = (JsonObject) jsonParser.parse(parsedReviewDTO2.getRevImg_seq());
                JsonArray jsonArray1 = (JsonArray) jsonObject1.get("seq");
                for (int k = 0; k < jsonArray1.size(); k++) {
                    Integer imgSeq = Integer.parseInt(String.valueOf(jsonArray1.get(k)));
                    String revImgSysname = pdReviewMapper.getRevImgSysname(imgSeq);
                    revImg.add(revImgSysname);
                }
                map.put("revImgSysname", revImg);
            }

            if (parsedReviewDTO2.getPdOption() != null) {   //옵션 있으면
                JsonObject jsonObject1 = (JsonObject) jsonParser.parse(parsedReviewDTO2.getPdOption());
                JsonArray jsonArray1 = (JsonArray) jsonObject1.get("name");
                optionMapList = new ArrayList<>();
                Map<String, Object> optionMap = null;
                for (int k = 0; k < jsonArray1.size(); k++) {
                    optionMap = new HashMap<>();
//                    //size = s
                    String optName = jsonArray1.get(k).toString().replace("\"", "");
                    String optCategory = optionCategory(parsedReviewDTO2.getPd_seq(), optName); //옵션 카테고리 이름 가져오기 (size)
                    optionMap.put(optCategory, optName);
                    optionMapList.add(optionMap);
                }
                map.put("optionMapList", optionMapList);
            }
            reviewList.add(map);
        }
        return reviewList;
    }

}
