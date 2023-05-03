package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.*;
import com.example.Spring_Project.mailSender.MailDTO;
import com.example.Spring_Project.service.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.annotations.Delete;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.*;


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

    @Autowired
    private FileService fileService;

    @Autowired
    private ProductService productService;

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
        service.insertCoupon(memberDTO.getM_seq());


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
    public String login(Model model, @RequestParam String id, @RequestParam String pw) throws Throwable {
        String result = "";

        MemberDTO memberDTO = service.selectById(id);
        if (memberDTO == null) { //회원이 아닐때
            String type = "None Member";
            String logID = id;
            String parameter = id + ", " + pw;
            String url = "/member/login";
            String description = id + " : 회원이 아닙니다.";
            LogDTO logDTO = new LogDTO();
            logDTO.setType(type);
            logDTO.setId(logID);
            logDTO.setParameter(parameter);
            logDTO.setUrl(url);
            logDTO.setDescription(description);
            logService.insertLog(logDTO); //에러 로그 저장
            log.info("==> 회원 정보가 없습니다.");
            result = "redirect:/";
            return result;
        } else if (memberDTO != null) {
            boolean flag = bCryptPasswordEncoder.matches(pw, memberDTO.getPw());
            Integer cnt = 0;
            if (flag == true) {
                cnt = service.getMemberInfo(id, memberDTO.getPw());
            }
            if (cnt != 1) {
                String type = "None Member";
                String logID = id;
                String parameter = id + ", " + pw;
                String url = "/member/login";
                String description = id + " : 회원이 아닙니다.";
                LogDTO logDTO = new LogDTO();
                logDTO.setType(type);
                logDTO.setId(logID);
                logDTO.setParameter(parameter);
                logDTO.setUrl(url);
                logDTO.setDescription(description);
                logService.insertLog(logDTO); //에러 로그 저장
                log.info("==> 회원 정보가 없습니다.");
                result = "redirect:/";
                return result;
            }
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
//                service.changeStatus(id);   // member lastLoginDate => null (로그인 안할수도 있으니까)
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


                    /*로그인 했을 때 -> 쿠폰 만료 확인*/
                    Integer m_seq = productService.getMemberSeq(id);//m_seq 가져오기
                    List<CouponDTO> couponDTOList = productService.getCoupon(m_seq);//쿠폰 리스트 가져오기
                    for (int i = 0; i < couponDTOList.size(); i++) {  //status y인것만
                        List<CouponDTO> val = productService.checkCouponPr();
                        for (int k = 0; k < val.size(); k++) {
                            productService.updCoupon(val.get(k).getCp_seq()); //status n으로
                        }
                    }
                    result = "redirect:/member/myPage";
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
        String communityPath = pathService.getCommunityPath();
        String deletePath = pathService.getDeletePath();
        String updateFormPath = pathService.getUpdateFormPath();
        String logoutPath = pathService.getDaily();
        String daily = pathService.getMonthly();
        String monthly = pathService.getLogoutPath();
        String hospitalPath = pathService.getHospitalPath();

        List<PathDTO> pathList = pathService.getPathList();
        model.addAttribute("updateFormPath", updateFormPath);
        model.addAttribute("deletePath", deletePath);
        model.addAttribute("logoutPath", logoutPath);
        model.addAttribute("communityPath", communityPath);
        model.addAttribute("hospitalPath", hospitalPath);
        model.addAttribute("daily", daily);
        model.addAttribute("monthly", monthly);
        model.addAttribute("pathList", pathList);
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
        String logoutPath = pathService.getDaily();
        String daily = pathService.getMonthly();
        String monthly = pathService.getLogoutPath();
        String hospitalPath = pathService.getHospitalPath();

        List<PathDTO> pathList = pathService.getPathList();
        model.addAttribute("updateFormPath", updateFormPath);
        model.addAttribute("deletePath", deletePath);
        model.addAttribute("logoutPath", logoutPath);
        model.addAttribute("communityPath", communityPath);
        model.addAttribute("hospitalPath", hospitalPath);
        model.addAttribute("daily", daily);
        model.addAttribute("monthly", monthly);
        model.addAttribute("pathList", pathList);
        return "/member/myPage";
    }

    @ResponseBody
    @PostMapping("/active")
    public String activeMember(@RequestParam String email, @RequestParam String id, @RequestParam String pw) throws Exception {
//      MemberDTO memberDTO = service.getNonActiveMember(id); //상태 N인 회원 정보 가져오기
        MemberDTO memberDTO = service.memberInfo(id);
        if (memberDTO == null) {
            return "none";
        }
        Integer count = service.getMemberInfo(id, memberDTO.getPw());
//      if (bCryptPasswordEncoder.matches(pw, memberDTO.getPw()) == true && service.isMemberExist(id, email) == 1) {
//      service.activeMember(id, email); // 멤버 status Y로
        String password = memberDTO.getPw();
        if (count == 1 && service.isMemberExist(id, email, password) == 1) {
            service.modifyLastLoginDateNull(id, email);
            return "success";
        } else {
            return "recheck";
        }
    }

    @GetMapping("/toActiveMemberPage")
    public String toActiveMemberPage() throws Exception {
        return "/member/activeMemberPage";
    }

    @RequestMapping("/toDoList")
    public String calendar() throws Exception {
        return "/member/calendar";
    }

    @RequestMapping("/popup")
    public String popup() throws Exception {
        return "/member/popup";
    }

    @RequestMapping("/showEvent")
    public String showEvent() throws Exception {
        return "/member/showEvent";
    }

    @ResponseBody
    @PostMapping("/addEvent")  //이벤트 등록 (파일 업로드 같이)
    public String insert(EventDTO eventDTO, @RequestParam(required = false) List<MultipartFile> file) throws Exception {

        Integer event_seq = service.getEventNextval();   //b_seq nextval
        eventDTO.setEvent_seq(event_seq);

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        boolean flag = true;

        if (file == null) { //파일 없을때
            service.insertEvent(eventDTO);
        } else if (file != null) {  //파일 있을때
            service.insertEvent(eventDTO);
            String path = "D:/storage/";
            File dir = new File(path);
            if (!dir.isDirectory()) {
                dir.mkdirs();
            }

            for (MultipartFile f : file) {
                Map<String, Object> map = new HashMap<>();

                String oriname = f.getOriginalFilename();
                if (oriname.equals("")) {
                    flag = false;
                }

                UUID uuid = UUID.randomUUID();
                String sysname = uuid + "_" + oriname;
                String savePath = path + sysname;

                f.transferTo(new File(savePath));
                map.put("event_seq", event_seq);
                map.put("oriname", oriname);
                map.put("sysname", sysname);
                list.add(map);
            }
            Integer size = list.size();
            for (int i = 0; i < size; i++) {
                fileService.insertEventMap(list.get(i));
            }
        }
        return "success";
    }


    @ResponseBody
    @PostMapping("/registeredEvent")
    public List<EventDTO> registeredEvent() throws Exception {
        List<EventDTO> list = service.getEvents(); //등록된 이벤트 가져오기
        for (int i = 0; i < list.size(); i++) {

        }
//        for (Integer i = 0; i<list.size(); i++){
//            if(list.get(i).getEvent_seq()){
//
//            }
//        }
//        List<EventDTO> fileList = service.getEventFile(); //등록된 파일 가져오기
        return list;
    }

    @RequestMapping("/coupon")
    public String coupon(Model model) throws Exception {
        String id = (String) session.getAttribute("id");
        Integer m_seq = service.getmSeq(id); //로그인한 회원의 seq
        List<CouponDTO> coupon = service.getCoupon(m_seq);
        model.addAttribute("coupon", coupon);
        return "/member/coupon";
    }


    @RequestMapping("/cart")
    public String cart() throws Exception {
        return "/member/cart";
    }


}
