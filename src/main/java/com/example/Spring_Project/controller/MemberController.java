package com.example.Spring_Project.controller;

import com.example.Spring_Project.SecurityConfig;
import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.mailSender.MailDTO;
import com.example.Spring_Project.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.UUID;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    private MemberService service;

    @Autowired
    private HttpSession session;

    @GetMapping("/toSignUpForm")  // 회원가입폼으로 이동
    public String toSignUpForm() throws Exception {
        return "/member/signUpForm";
    }

    @PostMapping("/signUp")  //회원가입
    public String signUp(MemberDTO memberDTO, MailDTO mailDTO,
                         @RequestParam("file") MultipartFile file, MultipartHttpServletRequest request) throws Exception {

        System.out.println("fileName: " + file.getOriginalFilename());
        System.out.println("id : " + memberDTO.getId());
        System.out.println("pw : " + memberDTO.getPw());
        System.out.println("email : " + memberDTO.getEmail());
        System.out.println("name : " + memberDTO.getName());
        System.out.println("postcode : " + memberDTO.getPostcode());
        System.out.println("road : " + memberDTO.getRoadAddress());
        System.out.println("jibun : " + memberDTO.getJibunAddress());
        System.out.println("상세주소 : " + memberDTO.getDetailAddress());

        String path = "C:/PROFILE/";  //파일이 저장될 경로 설정
        File dir = new File(path);
        if (!dir.isDirectory()) {
            dir.mkdirs();
        }

        String oriname = file.getOriginalFilename();

        // 파일 이름 변경
        UUID uuid = UUID.randomUUID();
        String sysname = uuid + "_" + oriname; //서버상의 파일이름이 겹치는것을 방지

        String savePath = path + sysname; //저장될 파일 경로
        System.out.println("savePath : " + savePath);
        System.out.println("oriname : " + oriname);
        System.out.println("sysname: " + sysname);

        memberDTO.setSavePath(savePath);
        memberDTO.setOriname(oriname);
        memberDTO.setSysname(sysname);

        //파일 저장
        file.transferTo(new File(savePath));
        service.signUp(memberDTO, mailDTO, file, request);

        return"/member/index";

}

    @ResponseBody
    @PostMapping("/idDupleCheck")   //아이디 중복 체크
    public Integer idDupleCheck(String id) throws Exception {
        return service.idDupleCheck(id);
    }

    @ResponseBody
    @PostMapping("/emailDupleCheck")   //이메일 중복 체크
    public Integer emailDupleCheck(@RequestParam String email) throws Exception {
        return service.emailDupleCheck(email);
    }

    @PostMapping("/login")  //로그인 (성공->마이페이지 / 실패->메인페이지로 이동)
    public String login(Model model, @RequestParam String id, @RequestParam String pw) throws Exception {
        System.out.println("id : " + id);
        String encodedPw = bCryptPasswordEncoder.encode(pw);
        System.out.println("encodedPw : " + encodedPw);
        String result = "";

        MemberDTO memberDTO = service.selectById(id);

        if (memberDTO == null) {
            System.out.println("로그인 실패");
            result = "redirect:/";
        } else if (bCryptPasswordEncoder.matches(pw, memberDTO.getPw()) && id.equals("admin123")) {
            System.out.println("관리자 로그인");
            session.setAttribute("admin", id); //관리자 세션 부여
            result = "redirect:/admin/main";
        } else if (bCryptPasswordEncoder.matches(pw, memberDTO.getPw()) && !id.equals("admin123")) {
            session.setAttribute("id", id);  //아이디 세션 부여
            System.out.println("로그인 성공");
            model.addAttribute("session", session.getAttribute("id"));
            result = "/member/myPage";
        } else {
            System.out.println("로그인 실패");
            result = "redirect:/";
        }
        return result;
    }

    @GetMapping("/logout")  //로그아웃
    public String logout(@RequestParam String id) throws Exception {
        session.invalidate();
        return "/member/index";
    }

    @GetMapping("/delete")   //탈퇴하기
    public String delete(@RequestParam String id) throws Exception {
        session.invalidate();
        service.delete(id);
        return "/member/index";
    }

    @GetMapping("/toUpdateForm")    //회원 정보 수정 페이지로 이동 (회원정보 뿌리기)
    public String toUpdateForm(Model model, @RequestParam String id) throws Exception {
        MemberDTO memberDTO = service.memberInfo(id);//회원 정보 가져오기
        model.addAttribute("memberDTO", memberDTO);
        System.out.println("update id : " + id);
        System.out.println("id : " + memberDTO.getId());
        System.out.println("pw : " + memberDTO.getPw());
        System.out.println("name : " + memberDTO.getName());
        System.out.println("emil : " + memberDTO.getEmail());
        System.out.println("postcode : " + memberDTO.getPostcode());
        System.out.println("roadAddress : " + memberDTO.getRoadAddress());
        System.out.println("jibunAddress : " + memberDTO.getJibunAddress());
        System.out.println("detailAddress : " + memberDTO.getDetailAddress());
        return "/member/updateForm";
    }

//    @PostMapping("/update")
//    public String update(@RequestParam MemberDTO memberDTO) throws Exception{
//
//    }

    @GetMapping("/toSearchIdForm")  //id 찾기 페이지로 이동
    public String toSearchIdForm() throws Exception {
        return "/member/searchId";
    }


    //id 찾기
    @ResponseBody
    @PostMapping("/searchId")
    public String searchId(@RequestParam String email) throws Exception {
        String id = service.searchId(email);
        if (id == null) {
            id = "NONE";
        }
        System.out.println("id찾기 : " + id);
        return id;
    }

    //pw 찾기 페이지로 이동
    @GetMapping("/toSearchPwForm")
    public String toSearchPwForm() throws Exception {
        return "/member/searchPw";
    }

    //pw 찾기


    @ResponseBody
    @PostMapping("/searchPw")
    public String searchPw(@RequestParam String email, @RequestParam String pw) throws Exception {
        MemberDTO memberDTO = service.selectByEmail(email);
        service.tempPw(email, pw);
        return pw;
    }
}
