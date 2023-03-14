package com.example.Spring_Project.controller;

import com.example.Spring_Project.SecurityConfig;
import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.service.AdminService;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private BCryptPasswordEncoder BCryptPasswordEncoder;

    @Autowired
    private HttpSession session;

    @RequestMapping("/main")  //회원 리스트 출력
    public String toAdminMain(Model model) throws Exception {
        List<MemberDTO> list = adminService.selectMemberList();
        for (MemberDTO memberDTO : list) {
            memberDTO.setPw(BCryptPasswordEncoder.encode(memberDTO.getPw()));
        }
        model.addAttribute("list", list);
        return "/admin/main";
    }

    @RequestMapping("/chart") //분기별 회원가입 수
    public String toChart(Model model) throws Exception {
        Integer count1 = adminService.select1();
        Integer count2 = adminService.select2();
        Integer count3 = adminService.select3();
        Integer count4 = adminService.select4();
        ArrayList<Integer> list = new ArrayList<>();
        list.add(count1);
        list.add(count2);
        list.add(count3);
        list.add(count4);
        model.addAttribute("list", list);
        return "/admin/memberChart";
    }

    @RequestMapping("/download") // 회원 리스트 다운
    public void download(HttpServletResponse response) throws Exception {
        adminService.downloadList(response);
    }

    @ResponseBody
    @PostMapping("/upload")
    public ModelAndView excelUploadAjax(MultipartFile testFile, MultipartHttpServletRequest request) throws Exception {

        System.out.println("업로드 진행");

        MultipartFile excelFile = request.getFile("excelFile");

        if (excelFile == null || excelFile.isEmpty()) {

            throw new RuntimeException("엑셀파일을 선택 해 주세요.");
        }

        File destFile = new File("C:\\" + excelFile.getOriginalFilename());

        try {
            //내가 설정한 위치에 내가 올린 파일을 만들고
            excelFile.transferTo(destFile);

        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        }

        //업로드를 진행하고 다시 지우기
        adminService.excelUpload(destFile);

        destFile.delete();
        //		FileUtils.delete(destFile.getAbsolutePath());

        ModelAndView view = new ModelAndView();

        view.setViewName("/admin/main");

        return view;
    }
}

