package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.encryption.AES256;
import com.example.Spring_Project.mailSender.MailDTO;
import com.example.Spring_Project.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private AES256 aes256;

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
                         MultipartFile file, MultipartHttpServletRequest request) throws Exception {

        System.out.println("id : " + memberDTO.getId());
        System.out.println("pw : " + memberDTO.getPw());
        System.out.println("email : " + memberDTO.getEmail());
        System.out.println("name : " + memberDTO.getName());
        System.out.println("postcode : " + memberDTO.getPostcode());
        System.out.println("road : " + memberDTO.getRoadAddress());
        System.out.println("jibun : " + memberDTO.getJibunAddress());
        System.out.println("상세주소 : " + memberDTO.getDetailAddress());
        System.out.println("ori : " + memberDTO.getOriname());
        System.out.println("sys : " + memberDTO.getSysname());
        System.out.println("savePath : " + memberDTO.getSavePath());
        service.signUp(memberDTO, mailDTO, file, request);

        return "redirect:/member/main";
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
        System.out.println("pw : " + pw);
        String result = "";

        session.setAttribute("id", id);  //아이디 세션 부여

        Integer login = service.login(id, pw);
        if (login == 1) {
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
        return "redirect:/member/main";
    }

    @GetMapping("/delete")   //탈퇴하기
    public String delete(@RequestParam String id) throws Exception {
        session.invalidate();
        service.delete(id);
        return "redirect:/member/main";
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
    public String searchPw(@RequestParam String id) throws Exception {
        String result = "";
        String pw = service.searchPw(id);
        if (pw == null) {
            result = "NONE";
        }
        result = aes256.decrypt(pw);
        return result;
    }

}