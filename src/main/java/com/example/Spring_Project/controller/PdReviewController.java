package com.example.Spring_Project.controller;

import com.example.Spring_Project.service.PdReviewService;
import org.apache.logging.log4j.util.PerformanceSensitive;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/pdReview")
public class PdReviewController {

    @Autowired
    private PdReviewService pdReviewService;
    @PostMapping("/toWriteForm")  //상품 리뷰 작성 폼으로
    public String insertReview(Model model, @RequestParam Map<String,Object> param) throws Exception{
        System.out.println("param = " + param);
        Integer pd_seq = Integer.parseInt(param.get("pd_seq").toString());
        Integer payPd_seq = Integer.parseInt(param.get("payPd_seq").toString());
        model.addAttribute("pd_seq",pd_seq);
        model.addAttribute("payPd_seq",payPd_seq);
        return "/product/review/writeForm";
    }

    @ResponseBody
    @PostMapping("/insertReview") //상품 리뷰 작성
    public void insertReview(@RequestParam Map<String,Object>param , @RequestParam (required = false) List<MultipartFile>file) throws Exception{
        //review insert
        //file insert
        pdReviewService.insertReview(param,file);
    }
}
