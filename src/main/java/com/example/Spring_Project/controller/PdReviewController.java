package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.ImgDTO;
import com.example.Spring_Project.dto.ReviewDTO;
import com.example.Spring_Project.service.PdReviewService;
import org.apache.coyote.Request;
import org.apache.logging.log4j.util.PerformanceSensitive;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.relational.core.sql.In;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/pdReview")
public class PdReviewController {

    @Autowired
    private PdReviewService pdReviewService;

    @PostMapping("/toWriteForm")  //상품 리뷰 작성 폼으로
    public String insertReview(Model model, @RequestParam Map<String, Object> param) throws Exception {
        Integer pd_seq = Integer.parseInt(param.get("pd_seq").toString());
        Integer payPd_seq = Integer.parseInt(param.get("payPd_seq").toString());
        model.addAttribute("pd_seq", pd_seq);
        model.addAttribute("payPd_seq", payPd_seq);
        return "/product/review/writeForm";
    }

    @ResponseBody
    @PostMapping("/insertReview") //상품 리뷰 작성
    public void insertReview(@RequestParam Map<String, Object> param, @RequestParam(value = "file", required = false) List<MultipartFile> file, HttpServletRequest request) throws Exception {
        pdReviewService.reviewInsert(param); //review insert
        Integer review_seq = pdReviewService.currRevSeq();//현재 review_seq 가져오기
        pdReviewService.imgInsert(file,request,review_seq);//img insert

    }

    @PostMapping("/updReview")
    public String updReview(Model model, @RequestParam Integer review_seq) throws Exception {
        ReviewDTO reviewDTO = pdReviewService.reviewDetail(review_seq);  //리뷰 디테일
        Integer isImgExist = pdReviewService.checkImgExist(review_seq); //리뷰 이미지 여부 체크
        if (isImgExist != 0) {
            List<ImgDTO> imgDTOList = pdReviewService.imgList(review_seq);
            model.addAttribute("imgDTOList", imgDTOList);
        }
        model.addAttribute("reviewDTO", reviewDTO);
        return "/product/review/detail";
    }


    @ResponseBody
    @PostMapping("/deleteReview")  //리뷰 삭제
    public String deleteReview(@RequestParam Integer review_seq) throws Exception{
        pdReviewService.deleteReview(review_seq);
        return "success";
    }

    @ResponseBody
    @PostMapping("/updReviewDetail")
    public String updReviewDetail(@RequestParam Map<String,Object>param, @RequestParam(value = "file", required = false) List<MultipartFile>file,@RequestParam(value = "deleteSeq",required = false) List<Integer>deleteSeq,HttpServletRequest request) throws Exception{
        Integer review_seq = Integer.parseInt(param.get("review_seq").toString());
        pdReviewService.updReviewDetail(param); //리뷰 디테일 수정
        if(file != null && file.size()!=0)pdReviewService.imgInsert(file,request,review_seq);  //파일 추가
        if(deleteSeq != null && deleteSeq.size() !=0)pdReviewService.deleteImg(deleteSeq); //파일 삭제
        return "success";
    }


}
