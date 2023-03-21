package com.example.Spring_Project.controller;

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

        String path = "C:/PROFILE/";
        File dir = new File(path);
        if (!dir.isDirectory()) {
            dir.mkdirs();
        }

        String oriname = file.getOriginalFilename();

        UUID uuid = UUID.randomUUID();
        String sysname = uuid + "_" + oriname;

        String savePath = path + sysname; //저장될 파일 경로
        file.transferTo(new File(savePath));

        memberDTO.setSavePath(savePath);
        memberDTO.setOriname(oriname);
        memberDTO.setSysname(sysname);
        memberDTO.setPw(bCryptPasswordEncoder.encode(memberDTO.getPw())); //pw 암호화

        service.signUp(memberDTO, mailDTO, file, request);

        return "/member/index";

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
        String result = "";

        MemberDTO memberDTO = service.selectById(id);
        String type = memberDTO.getType();

        if (memberDTO == null) {
            result = "redirect:/";
        } else if (bCryptPasswordEncoder.matches(pw, memberDTO.getPw()) && type.equals("ROLE_ADMIN")) {  //ADMIN일때 타입일때
            session.setAttribute("id", id); //관리자 세션 부여
            session.setAttribute("admin" , true);
            System.out.println("memberController : " + session.getAttribute("admin"));
            result = "redirect:/admin/main";
        } else if (bCryptPasswordEncoder.matches(pw, memberDTO.getPw()) && !type.equals("ROLE_ADMIN")) {
            if (service.login(memberDTO.getId(), memberDTO.getPw()) == 1) { //로그인 성공
                session.setAttribute("id", id);  //아이디 세션 부여
                session.setAttribute("admin" , false);
                model.addAttribute("id", session.getAttribute("id"));
                result = "/member/myPage";
            } else {
                result = "redirect:/";
            }
        } else {
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

    @GetMapping("/toUpdateForm")    //회원 정보 수정 페이지로 이동
    public String toUpdateForm(Model model, @RequestParam String id) throws Exception {
        MemberDTO memberDTO = service.memberInfo(id);//회원 정보 가져오기
        model.addAttribute("memberDTO", memberDTO);
        return "/member/updateForm";
    }

    @PostMapping("/update")  //정보수정
    public String update(MemberDTO memberDTO, @RequestParam("file") MultipartFile file) throws Exception {

        String path = "C:/PROFILE/";
        File dir = new File(path);
        if (!dir.isDirectory()) {
            dir.mkdirs();
        }
        String oriname = file.getOriginalFilename();
        UUID uuid = UUID.randomUUID();
        String sysname = uuid + "_" + oriname;

        String savePath = path + sysname; //저장될 파일 경로
        file.transferTo(new File(savePath));

        memberDTO.setSavePath(savePath);
        memberDTO.setOriname(oriname);
        memberDTO.setSysname(sysname);

        memberDTO.setPw(bCryptPasswordEncoder.encode(memberDTO.getPw()));
        service.update(memberDTO);
        return "redirect:/";
    }

    @GetMapping("/toSearchIdForm")  //id 찾기 페이지로 이동
    public String toSearchIdForm() throws Exception {
        return "/member/searchId";
    }

    @ResponseBody
    @PostMapping("/searchId") //id 찾기
    public String searchId(@RequestParam String email) throws Exception {
        String id = service.searchId(email);
        if (id == null) {
            id = "NONE";
        }
        return id;
    }

    @GetMapping("/toSearchPwForm") //pw 찾기 페이지로 이동
    public String toSearchPwForm() throws Exception {
        return "/member/searchPw";
    }

    @ResponseBody
    @PostMapping("/emailExist") //이메일 존재 여부
    public String emailExist(@RequestParam String email) throws Exception {
        Integer cnt = service.isEmailExist(email);
        if (cnt == 1) {
            return "exist";
        } else {
            return "none";
        }
    }

    @ResponseBody
    @PostMapping("/searchPw")   //pw 찾기
    public String searchPw(@RequestParam String email, @RequestParam String pw) throws Exception {
        MemberDTO memberDTO = service.selectByEmail(email);
        service.tempPw(email, bCryptPasswordEncoder.encode(pw));
        return pw;
    }

    @RequestMapping("/myPage")
    public String toMyPage() throws Exception {
        return "/member/myPage";
    }

}
