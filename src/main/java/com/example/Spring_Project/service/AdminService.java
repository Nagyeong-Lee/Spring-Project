package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.excel.ExcelRead;
import com.example.Spring_Project.mapper.AdminMapper;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {
    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private ExcelRead excelRead;

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
        Sheet sheet = workbook.createSheet("member_list");
        int rowNo = 0;

        SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd");
        int start = 0;
        int end = 0;
        List<MemberDTO> memberList = this.selectMemberList();
        Integer memberListSize = memberList.size();

        for (Integer i = 0; i < memberListSize; i++) {
            String date = sdf.format(memberList.get(i).getSignup_date());
            //if(i == 0){
            //start = 1;
            //}else if(date.equals(sdf.format(memberList.get(i + 1).getSignup_date()))) {

            //}else{
            //end=i-1;

            //System.out.println("end : "+end);
            //System.out.println("start : "+start);
            //start=i+1;
            //}
            if (i == 0) {
                start = i + 1;
            } else if (!date.equals(sdf.format(memberList.get(i - 1).getSignup_date()))) {
                end = i;
                System.out.println("안같을때");
                System.out.println("start : " + start);
                System.out.println("end : " + end);
                sheet.addMergedRegion(new CellRangeAddress(start, end, 4, 4));
                start = i + 1;
            } else if (i == memberListSize - 1) {
                end = i + 2;
                sheet.addMergedRegion(new CellRangeAddress(start, end-2, 4, 4));
                System.out.println("마지막");
                System.out.println("start : " + start);
                System.out.println("end : " + end);
            }
//
        }
        XSSFCellStyle style = (XSSFCellStyle) workbook.createCellStyle();
        style.setFillForegroundColor(IndexedColors.YELLOW.getIndex());  // 배경색
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short) 13);

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
        Integer size = list.size();
        for (Integer i = 0; i < size - 1; i++) {
            Row row = sheet.createRow(rowNo++);
            Integer length = 0;
            //아이디
            String id = list.get(i).getId();
            length = id.length() - 2;
            id = id.substring(0, length) + "***";  // 뒷 2자리 ***
            //이름
            String name = list.get(i).getName();
            String name2 = list.get(i).getName();
            String str = "";
            if (name.length() == 2) {
                length = name.length() - 1;
                name = name.substring(0, length) + "*";  // 뒷 1자리 *
            } else if (name.length() == 3) {
                name = name.substring(0, 1) + "*" + name.substring(2, 3);  // 가운데 *
            } else {
                length = name.length() - 2;
                name = name.substring(0, length);
                for (int k = length; k < name2.length(); k++) {
                    str += "*";
                }
            }
            //이메일
            String email = list.get(i).getEmail();
            length = email.length();
            Integer index = email.indexOf("@");
            String newEmail = "";
            for (int j = 0; j < index; j++) {
                newEmail += "*";
            }
            email = newEmail + list.get(i).getEmail().substring(index, length);
            //전화번호
            String phone = list.get(i).getPhone().substring(0, 3) + "****" + list.get(i).getPhone().substring(7, 11);

            row.createCell(0).setCellValue(name + str);
            row.createCell(1).setCellValue(id);
            row.createCell(2).setCellValue(email);
            row.createCell(3).setCellValue(phone);
            row.createCell(4).setCellValue(sdf.format(list.get(i).getSignup_date()));
        }

        sheet.setColumnWidth(0, 3000);
        sheet.setColumnWidth(1, 8000);
        sheet.setColumnWidth(2, 8000);
        sheet.setColumnWidth(3, 8000);
        sheet.setColumnWidth(4, 8000);

        response.setContentType("ms-vnd/excel");
        response.setHeader("Content-Disposition", "attachment;filename=member_list.xlsx");

        workbook.write(response.getOutputStream());
    }

    //엑셀 업로드
    public boolean excelUpload(@RequestParam MultipartFile fileExcel) throws Exception {

        boolean result = false;
        List<Map<String, Object>> excelContent = excelRead.read(fileExcel);
        Integer size = excelContent.size();
        try {
            for (int i = 0; i < size; i++) {
                adminMapper.insertExcel(excelContent.get(i));
            }
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
        }
        return result;
    }

}
