package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.ImgDTO;
import com.example.Spring_Project.dto.ProductDTO;
import com.example.Spring_Project.dto.ReviewDTO;
import com.example.Spring_Project.mapper.PdReviewMapper;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.*;

@Service
public class PdReviewService {
    @Autowired
    private PdReviewMapper pdReviewMapper;


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
    public void deleteReview(Integer review_seq) throws Exception {
        pdReviewMapper.deleteReview(review_seq);
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
                System.out.println("jsonArray = " + jsonArray);
                System.out.println("jsonArray = " + jsonArray.size());
                for (int i = 0; i < jsonArray.size(); i++) {
                    optionMap = new HashMap<>();
                    //size = s
                    String optName = jsonArray.get(i).toString().replace("\"", "");
                    String optCategory = optionCategory(pd_seq, optName); //옵션 카테고리 이름 가져오기 (size)
                    System.out.println("optCategory = " + optCategory);
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

    public List<Map<String, Object>> getReviews() throws Exception {
        return pdReviewMapper.getReviews();
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
        System.out.println("reviewDTOS = " + reviewDTOS);
        Integer size = reviewDTOS.size();
        for (int i = 0; i < size; i++) {
            Map<String, Object> map = new HashMap<>();
            ProductDTO productDTO = pdInfo(Integer.parseInt(reviewDTOS.get(i).get("PD_SEQ").toString()));
            map.put("productDTO", productDTO);
            map.put("reviewDTOS", reviewDTOS.get(i));
            map.put("totalPrice", Integer.parseInt(reviewDTOS.get(i).get("PRICE").toString()) * Integer.parseInt(reviewDTOS.get(i).get("STOCK").toString()));
            //옵션 있으면
            if (reviewDTOS.get(i).get("OPTIONS") != null) {
                Object object = jsonParser.parse(reviewDTOS.get(i).get("OPTIONS").toString());
                jsonObject = (JsonObject) object;
                jsonArray = (JsonArray) jsonObject.get("name");
                optionMapList = new ArrayList<>();
                Map<String, Object> optionMap = null;
                System.out.println("jsonArray = " + jsonArray);
                System.out.println("jsonArray = " + jsonArray.size());
                for (int k = 0; k < jsonArray.size(); k++) {
                    optionMap = new HashMap<>();
                    //size = s
                    String optName = jsonArray.get(k).toString().replace("\"", "");
                    System.out.println("optName = " + optName);
//                    String optCategory = optionCategory(Integer.parseInt(reviewDTOS.get(k).get("PD_SEQ").toString()), optName); //옵션 카테고리 이름 가져오기 (size)
                    String optCategory = optionCategory(productDTO.getPd_seq(), optName); //옵션 카테고리 이름 가져오기 (size)
                    System.out.println("optCategory = " + optCategory);
                    optionMap.put(optCategory, optName);
                    optionMapList.add(optionMap);
                    option.put("optionMapList", optionMapList);
                }
            }
            map.put("option",option);
            reviewList.add(map);
        }
        return reviewList;
    }

}
