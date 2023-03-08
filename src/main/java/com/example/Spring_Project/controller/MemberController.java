package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.encryption.SHA256;
import com.example.Spring_Project.mailSender.MailDTO;
import com.example.Spring_Project.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;

@Controller
public class MemberController {

    @Autowired
    private MemberService service;

    @GetMapping("/")  //메인페이지로 이동
    public String toMainPage() throws Exception {
        return "/member/index";
    }

    @GetMapping("/toSignUpForm")  // 회원가입폼으로 이동
    public String toSignUpForm() throws Exception {
        return "/member/signUpForm";
    }

    @PostMapping("/signUp")  //회원가입
    public String signUp(MemberDTO memberDTO , MailDTO mailDTO,
                         MultipartFile file , MultipartHttpServletRequest request) throws Exception {

        System.out.println("id : "+ memberDTO.getId());
        System.out.println("pw : "+memberDTO.getPw());
        System.out.println("email : "+memberDTO.getEmail());
        System.out.println("name : "+memberDTO.getName());
        System.out.println("postcode : "+memberDTO.getPostcode());
        System.out.println("road : "+memberDTO.getRoadAddress());
        System.out.println("jibun : "+memberDTO.getJibunAddress());
        System.out.println("상세주소 : "+memberDTO.getDetailAddress());
        System.out.println("ori : "+memberDTO.getOriname());
        System.out.println("sys : "+memberDTO.getSysname());
        System.out.println("savePath : "+memberDTO.getSavePath());
        service.signUp(memberDTO,mailDTO,file,request);

        return "redirect:/";
    }

    @ResponseBody
    @PostMapping("/idDupleCheck")   //아이디 중복 체크
    public void idDupleCheck(String id) throws Exception{
        service.idDupleCheck(id);
    }


}