package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.BatchDTO;
import com.example.Spring_Project.dto.LogDTO;
import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.mailSender.MailDTO;
import com.example.Spring_Project.service.BatchService;
import com.example.Spring_Project.service.LogService;
import com.example.Spring_Project.service.MemberService;
import com.example.Spring_Project.service.PathService;
import lombok.extern.slf4j.Slf4j;
import oracle.ucp.proxy.annotation.Post;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;


@Slf4j
@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    private MemberService service;

    @Autowired
    private HttpSession session;

    @Autowired
    private PathService pathService;

    @Autowired
    private BatchService batchService;

    @Autowired
    private LogService logService;

    @GetMapping("/toSignUpForm")  // 회원가입폼으로 이동
    public String toSignUpForm() throws Exception {
        return "/member/signUpForm";
    }

    @PostMapping("/signUp")  //회원가입
    public String signUp(MemberDTO memberDTO, MailDTO mailDTO,
                         @RequestParam("file") MultipartFile file, MultipartHttpServletRequest request) throws Exception {

        String path = "/resources/img/profile/";

        String savePath = request.getServletContext().getRealPath(path); //webapp 폴더
        File fileSavePath = new File(savePath);

        if (!fileSavePath.exists()) {
            fileSavePath.mkdir();
        }

        String oriname = file.getOriginalFilename();
        String sysname = UUID.randomUUID() + "_" + file.getOriginalFilename();

        file.transferTo(new File(fileSavePath + "/" + sysname));

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
    public String emailDupleCheck(@RequestParam String email) throws Exception {
        String str = "";
        Integer result = service.emailDupleCheck(email);
        if (result == 1) {
            str = "exist";
        } else {
            str = "none";
        }
        return str;
    }

    @PostMapping("/login")  //로그인 (성공->마이페이지 / 실패->메인페이지로 이동)
    public String login(Model model, @RequestParam String id, @RequestParam String pw) throws Exception {
        String result = "";

        MemberDTO memberDTO = service.selectById(id);

        if (memberDTO == null || service.login(id, memberDTO.getPw()) != 1) {
            String type = "Login Fail";
            String parameter = id + ", " + pw;
            String url = "/member/login";
            String description = id+" : 로그인에 실패했습니다.";
            LogDTO logDTO = new LogDTO();
            logDTO.setType(type);
            logDTO.setParameter(parameter);
            logDTO.setUrl(url);
            logDTO.setDescription(description);
//            logService.insertLog(logDTO); //에러 로그 저장
            log.info("==> ID 또는 PW가 일치하지 않습니다.");
            result = "redirect:/";
            return result;
        }

        String type = memberDTO.getType();
        if (bCryptPasswordEncoder.matches(pw, memberDTO.getPw()) && type.equals("ROLE_ADMIN")) {  //ADMIN 타입일때
            if (service.login(memberDTO.getId(), memberDTO.getPw()) == 1) { //로그인 성공
                session.setAttribute("id", id); //아이디 세션 부여
                session.setAttribute("admin", true);  //관리자 세션 부여
            }
            result = "redirect:/admin/main";
        } else if (bCryptPasswordEncoder.matches(pw, memberDTO.getPw()) && !type.equals("ROLE_ADMIN")) {
            Integer nonActiveId = service.diffDate(id);   // 로그인한지 60일 이상
            if (nonActiveId == 1) {
                service.changeStatus(id);   // member lastLoginDate => null (로그인 안할수도 있으니까)
                batchService.updateLoginDateNull(id); // batch lastLoginDate => null (로그인 안할수도 있으니까)
                model.addAttribute("nonActiveID", id);
                return "/member/activeMemberPage";
            } else {
                if (service.login(memberDTO.getId(), memberDTO.getPw()) == 1) { //로그인 성공
                    service.modifyLastLoginDate(id); //로그인 했을 때 마지막 update lastLoginDate
                    Integer count = batchService.isIdExist(memberDTO.getId());
                    //휴면처리
                    if (count != 1) {
                        batchService.insertLoginDate(memberDTO.getId());
                    } else {
                        batchService.updateLoginDate(memberDTO.getId());
                    }

                    session.setAttribute("id", id);
                    session.setAttribute("admin", false);
                    model.addAttribute("admin", session.getAttribute("admin"));
                    String communityPath = pathService.getCommunityPath();
                    String deletePath = pathService.getDeletePath();
                    String updateFormPath = pathService.getUpdateFormPath();
                    String logoutPath = pathService.getLogoutPath();
                    model.addAttribute("updateFormPath", updateFormPath);
                    model.addAttribute("deletePath", deletePath);
                    model.addAttribute("logoutPath", logoutPath);
                    model.addAttribute("communityPath", communityPath);
                    result = "/member/myPage";
                } else {
                    result = "redirect:/";
                }
            }
        } else {
            result = "redirect:/";
        }
        return result;
    }

    @GetMapping("/logout")  //로그아웃
    public String logout(@RequestParam String id) throws Exception {
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping("/delete")   //탈퇴하기
    public String delete(Model model, @RequestParam String id) throws Exception {
        session.invalidate();
        service.delete(id);
        return "redirect:/";
    }

    @GetMapping("/toUpdateForm")    //회원 정보 수정 페이지로 이동
    public String toUpdateForm(Model model, @RequestParam String id) throws Exception {
        MemberDTO memberDTO = service.memberInfo(id);//회원 정보 가져오기
        model.addAttribute("memberDTO", memberDTO);
        return "/member/updateForm";
    }

    @PostMapping("/update")  //정보수정
    public String update(MemberDTO memberDTO, @RequestParam("file") MultipartFile file, MultipartHttpServletRequest request) throws Exception {

        String path = "/resources/img/profile/";

//        MemberDTO imgDTO = service.getImgInfo(memberDTO.getM_seq());

        String savePath = request.getServletContext().getRealPath(path); //webapp 폴더
        File fileSavePath = new File(savePath);

        if (!fileSavePath.exists()) {
            fileSavePath.mkdir();
        }

        String oriname = file.getOriginalFilename();
        String sysname = UUID.randomUUID() + "_" + file.getOriginalFilename();

        if (file.isEmpty()) {
            //없을떄
            memberDTO.setFileIsEmpty("N");
        } else {
            //있을때
            file.transferTo(new File(fileSavePath + "/" + sysname));
            memberDTO.setFileIsEmpty("Y");
            memberDTO.setSavePath(savePath);
            memberDTO.setOriname(oriname);
            memberDTO.setSysname(sysname);
        }

//      memberDTO.setPw(bCryptPasswordEncoder.encode(memberDTO.getPw()));
        service.update(memberDTO);
        return "redirect:/member/myPage";
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
    public String toMyPage(Model model) throws Exception {
        String communityPath = pathService.getCommunityPath();
        String deletePath = pathService.getDeletePath();
        String updateFormPath = pathService.getUpdateFormPath();
        String logoutPath = pathService.getLogoutPath();
        model.addAttribute("updateFormPath", updateFormPath);
        model.addAttribute("deletePath", deletePath);
        model.addAttribute("logoutPath", logoutPath);
        model.addAttribute("communityPath", communityPath);
        return "/member/myPage";
    }

    @ResponseBody
    @PostMapping("/active")
    public String activeMember(@RequestParam String email, @RequestParam String id, @RequestParam String pw) throws Exception {
        MemberDTO memberDTO = service.getNonActiveMember(id); //상태 N인 회원 정보 가져오기
        if (memberDTO == null) {
            return "none";
        }
        if (bCryptPasswordEncoder.matches(pw, memberDTO.getPw()) == true && service.isMemberExist(id, email) == 1) {
            service.activeMember(id, email); // 멤버 status Y로
            return "success";
        } else {
            return "recheck";
        }
    }

    @GetMapping("/toActiveMemberPage")
    public String toActiveMemberPage() throws Exception {
        return "/member/activeMemberPage";
    }
}
