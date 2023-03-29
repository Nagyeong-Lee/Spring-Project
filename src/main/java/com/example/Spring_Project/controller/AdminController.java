package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.LogDTO;
import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.service.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.io.IOUtils;
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
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.util.*;


@Slf4j
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private BCryptPasswordEncoder BCryptPasswordEncoder;

    @Autowired
    private HttpSession session;

    @Autowired
    private PathService pathService;

    @Autowired
    private LogService logService;

    @Autowired
    private BoardService boardService;

    @RequestMapping("/main")  //회원 리스트 출력
    public String toAdminMain(Model model) throws Exception {
        List<MemberDTO> list = adminService.selectMemberList();
        String logoutPath = pathService.getLogoutPath();
        model.addAttribute("logoutPath", logoutPath);
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

    @ResponseBody  //엑셀 업로드
    @PostMapping("/upload")
    public String excelUploadAjax(@RequestParam MultipartFile fileExcel, MultipartHttpServletRequest request) throws Exception {

        MultipartFile excelFile = request.getFile("fileExcel");

        if (excelFile == null || excelFile.isEmpty()) {

            throw new RuntimeException("엑셀파일을 선택해 주세요.");
        }

        String path = "D:\\excelUpload\\";
        File dir = new File(path);
        if (!dir.isDirectory()) {
            dir.mkdirs();
        }


        File destFile = new File(path + excelFile.getOriginalFilename());

        try {
            excelFile.transferTo(destFile);

        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        }

        DiskFileItem fileItem = new DiskFileItem("file", Files.probeContentType(destFile.toPath()), false, destFile.getName(), (int) destFile.length(), destFile.getParentFile());

        InputStream input = new FileInputStream(destFile);
        OutputStream os = fileItem.getOutputStream();
        IOUtils.copy(input, os);

        MultipartFile multipartFile = new CommonsMultipartFile(fileItem);

        boolean result = adminService.excelUpload(multipartFile);

//        ModelAndView view = new ModelAndView();
//
//        view.setViewName("/admin/main");
//
//        return view;

        if (result == true) {
            return "success";
        } else {
            return "fail";
        }
    }

    @RequestMapping("/mngMember")
    public String mngMember(Model model) throws Exception {
        List<MemberDTO> list = adminService.selectMemberList();
        model.addAttribute("list", list);
        return "/admin/memberMng";
    }

    @RequestMapping("/list") // 게시글 리스트
    public String logList(Model model,
                          @RequestParam Integer currentPage,
                          @RequestParam Integer count,
                          @RequestParam(required = false) Integer postNum,
                          @RequestParam(required = false) String searchType,
                          @RequestParam(required = false) String keyword) throws Exception {

        if (currentPage == null) {
            currentPage = 1;
        }

        //게시글 개수 기본 10
        if (count == null) {
            count = 10;
        }

//        Integer totalLog = logService.countLog(searchType, keyword);  //전체 로그 개수
        Integer start = currentPage * count - (count-1); //시작 글 번호
        Integer end = currentPage * count; // 끝 글 번호

        List<LogDTO> list = logService.selectLog(start, end, searchType, keyword);
        String paging = logService.getLogPageNavi(currentPage, count, searchType, keyword,postNum);

        Integer currPage = currentPage;
        model.addAttribute("list", list);
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("currPage",currPage);
        model.addAttribute("count",count);
        model.addAttribute("postNum",postNum);
        return "/admin/logCheck";
    }


}

