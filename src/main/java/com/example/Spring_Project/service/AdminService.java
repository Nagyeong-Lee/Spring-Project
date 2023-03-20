package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.excel.ExcelRead;
import com.example.Spring_Project.excel.ExcelReadOption;
import com.example.Spring_Project.mapper.AdminMapper;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {
    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private static BCryptPasswordEncoder bCryptPasswordEncoder;

    public List<MemberDTO> selectMemberList() throws Exception {  //회원 리스트 출력
        return adminMapper.selectMemberList();
    }

    public Integer select1() throws Exception {  //1-3
        return adminMapper.select1();
    }

    public Integer select2() throws Exception {  //4-6
        return adminMapper.select2();
    }

    public Integer select3() throws Exception {  //7-9
        return adminMapper.select3();
    }

    public Integer select4() throws Exception {  //10-12
        return adminMapper.select4();
    }


    public void downloadList(HttpServletResponse response) throws Exception { //회원 리스트 다운

        Workbook workbook = new XSSFWorkbook();   //엑셀 파일 생성
        Sheet sheet = workbook.createSheet("member_list"); //시트 생성
        int rowNo = 0;

        //헤더 스타일
//        CellStyle headStyle = workbook.createCellStyle();
        //headStyle.setFillForegroundColor(HSSFColor.HSSFColorPredefined.GREY_50_PERCENT.getIndex());
        //headStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        // 배경색
        XSSFCellStyle style = (XSSFCellStyle) workbook.createCellStyle();
        style.setFillForegroundColor(IndexedColors.YELLOW.getIndex());  // 배경색
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font font = workbook.createFont();
        //font.setColor(HSSFColor.HSSFColorPredefined.WHITE.getIndex());
        font.setFontHeightInPoints((short) 13);
//        headStyle.setFont(font);

        Row headerRow = sheet.createRow(rowNo++);
        headerRow.createCell(0).

                setCellValue("이름");
        headerRow.createCell(1).

                setCellValue("아이디");
        headerRow.createCell(2).

                setCellValue("이메일");
        headerRow.createCell(3).

                setCellValue("전화번호");
        headerRow.createCell(4).

                setCellValue("가입날짜");


        for (int i = 0; i <= 4; i++) {
            headerRow.getCell(i).setCellStyle(style);
        }

        List<MemberDTO> list = this.selectMemberList();
        for (
                MemberDTO dto : list) {
            Row row = sheet.createRow(rowNo++);

            Integer length = 0;
            //아이디
            String id = dto.getId();
            length = id.length() - 2;
            id = id.substring(0, length) + "***";  // 뒷 2자리 ***
            //이름
            String name = dto.getName();
            if (name.length() == 2) {
                length = name.length() - 1;
                name = name.substring(0, length) + "*";  // 뒷 1자리 *
            } else if (name.length() == 3) {
                name = name.substring(0, 1) + "*" + name.substring(2, 3);  // 가운데 *
            } else {
                length = name.length() - 2;
                name = name.substring(0, length) + "*";  // 뒷 2자리 ***
            }
            //이메일
            String email = dto.getEmail();
            length = email.length();
            Integer index = email.indexOf("@");
            String newEmail = "";
            for (int i = 0; i < index; i++) {
                newEmail += "*";
            }
            email = newEmail + dto.getEmail().substring(index, length);
            //전화번호
            String phone = dto.getPhone().substring(0, 3) + "****" + dto.getPhone().substring(7, 11);

            row.createCell(0).setCellValue(name);
            row.createCell(1).setCellValue(id);
            row.createCell(2).setCellValue(email);
            row.createCell(3).setCellValue(phone);
            SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd hh:mm");

            sheet.addMergedRegion(new CellRangeAddress(0, 0, 4, 5));
            row.createCell(4).setCellValue(sdf.format(dto.getSignup_date()));
        }

        sheet.setColumnWidth(0, 3000);
        sheet.setColumnWidth(1, 8000);
        sheet.setColumnWidth(2, 8000);
        sheet.setColumnWidth(3, 8000);
        sheet.setColumnWidth(4, 8000);

        response.setContentType("ms-vnd/excel");
        response.setHeader("Content-Disposition", "attachment;filename=member_list.xls");

        workbook.write(response.getOutputStream());
    }

    //엑셀 업로드
    public void excelUpload(@RequestParam MultipartFile fileExcel) throws Exception {

        List<Map<String, Object>> excelContent = ExcelRead.read(fileExcel);

        System.out.println("excelContent : ");
        System.out.println(excelContent);

        for(int i=0; i<excelContent.size(); i++){
            String pw = (String)excelContent.get(i).get("pw");
            bCryptPasswordEncoder.encode(pw);
            System.out.println(excelContent.get(i).get("pw"));
        }
        System.out.println("List 사이즈 : " + excelContent.size());

//        Map<String, Object> paramMap = new HashMap<String, Object>();
//        paramMap.put("excelContent", excelContent);
//
//        System.out.println("paramMap : ");
//        System.out.println(paramMap);

        try {
            adminMapper.insertExcel(excelContent);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

}
