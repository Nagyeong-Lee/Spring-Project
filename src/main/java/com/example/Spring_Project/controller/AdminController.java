package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.encryption.AES256;
import com.example.Spring_Project.service.AdminService;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.bouncycastle.pqc.crypto.lms.HSSPrivateKeyParameters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.mail.Session;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private AES256 aes256;

    @Autowired
    private HttpSession session;

    @RequestMapping("/main")
    public String toAdminMain(Model model) throws Exception {
        List<MemberDTO> list = adminService.selectMemberList();  //회원 리스트 출력
        for (MemberDTO memberDTO : list) {
            memberDTO.setPw(aes256.decrypt(memberDTO.getPw()));
        }
        model.addAttribute("list", list);
        return "/admin/main";
    }

    @RequestMapping("/chart")
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

    @RequestMapping("/download")
    public void download(HttpServletResponse response) throws Exception {

        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("memberList"); //sheet 생성
        HSSFCellStyle style = workbook.createCellStyle();
        Row row = null; //행
        Cell cell = null; //열

        List<MemberDTO> list = adminService.selectMemberList();


        //첫행   열 이름 표기
        int cellCount = 0;
        row = sheet.createRow(0); //0번째 행
        cell = row.createCell(cellCount++);
        cell.setCellValue("이름");
        cell = row.createCell(cellCount++);
        cell.setCellValue("아이디");
        cell = row.createCell(cellCount++);
        cell.setCellValue("이메일");
        cell = row.createCell(cellCount++);
        cell.setCellValue("전화번호");
        cell = row.createCell(cellCount++);
        cell.setCellValue("가입일자");


        for (int i = 0; i < list.size(); i++) {
            row = sheet.createRow(i + 1);  // '열 이름 표기'로 0번째 행 만들었으니까 1번째행부터
            cellCount = 0; //열 번호 초기화
            cell = row.createCell(cellCount++);
            cell.setCellValue(list.get(i).getName());
            cell = row.createCell(cellCount++);
            cell.setCellValue(list.get(i).getId());
            cell = row.createCell(cellCount++);
            cell.setCellValue(list.get(i).getEmail());
            cell = row.createCell(cellCount++);
            cell.setCellValue(list.get(i).getPhone());
            cell = row.createCell(cellCount++);
            cell.setCellValue(list.get(i).getSignup_date());
        }

        CellStyle styleBlueColor = workbook.createCellStyle();
        styleBlueColor.setFillForegroundColor(IndexedColors.BLUE1.getIndex());
        styleBlueColor.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        // 컨텐츠 타입과 파일명 지정
        response.setContentType("ms-vnd/excel");
        response.setHeader("Content-Disposition", "attachment;filename=memberList.xls");  //파일이름지정.
        //response OutputStream에 엑셀 작성 (엑셀 출력)
        workbook.write(response.getOutputStream());
        workbook.close();
    }
}

