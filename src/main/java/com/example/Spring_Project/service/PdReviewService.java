package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.ImgDTO;
import com.example.Spring_Project.dto.ReviewDTO;
import com.example.Spring_Project.mapper.PdReviewMapper;
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

    public void imgInsert(List<MultipartFile> file, HttpServletRequest request,Integer review_seq) throws Exception{

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        if (file != null) {  //파일 인서트
            String path = "/resources/img/products/pdReview";
//            String realPath=session.getServletContext().getRealPath("/resources/img/pdReview");
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
    public void updReviewDetail(Map<String,Object>param) throws Exception{
        pdReviewMapper.updReviewDetail(param);
    }

    //이미지 삭제
    public void deleteImg(List<Integer>deleteSeq) throws Exception{
        pdReviewMapper.deleteImg(deleteSeq);
    }
}
