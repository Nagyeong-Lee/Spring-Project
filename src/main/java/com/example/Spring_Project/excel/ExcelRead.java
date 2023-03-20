package com.example.Spring_Project.excel;


import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.util.*;

@Repository
public class ExcelRead {

    @Autowired
    private static BCryptPasswordEncoder bCryptPasswordEncoder;

    public static List<Map<String, Object>> read(MultipartFile fileExcel) throws Exception {
        OPCPackage opcPackage = OPCPackage.open(fileExcel.getInputStream()); // 파일 읽어옴
        Workbook workbook = WorkbookFactory.create(opcPackage);
        Sheet firstSheet = workbook.getSheetAt(0);
        Iterator<Row> iterator = firstSheet.iterator();

        List<Map<String, Object>> result = new ArrayList<>();


        while (iterator.hasNext()) {
            Row nextRow = iterator.next();
            Iterator<Cell> cellIterator = nextRow.cellIterator();
            Map<String, Object> dataMap = new HashMap<>();

            while (cellIterator.hasNext()) {
                Cell cell = cellIterator.next();
                String cellvalue = "";

                if (cell.getCellType() == Cell.CELL_TYPE_STRING) {
                    cellvalue = "" + cell.getStringCellValue();
                } else if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
                    cellvalue = "" + cell.getNumericCellValue();
                } else if (cell.getCellType() == Cell.CELL_TYPE_BOOLEAN) {
                    cellvalue = "" + cell.getBooleanCellValue();
                } else if (cell.getCellType() == Cell.CELL_TYPE_FORMULA) {      //수식일 경우 변환
                    if (cell.getCachedFormulaResultType() == Cell.CELL_TYPE_NUMERIC) {
                        cellvalue = "" + cell.getNumericCellValue();
                    } else if (cell.getCachedFormulaResultType() == Cell.CELL_TYPE_STRING) {
                        cellvalue = "" + cell.getStringCellValue();
                    } else if (cell.getCachedFormulaResultType() == Cell.CELL_TYPE_BOOLEAN) {
                        cellvalue = "" + cell.getBooleanCellValue();
                    }
                }
                System.out.print(cellvalue + " ");

                if (cell.getRowIndex() > 0) {
                    switch (cell.getColumnIndex()) {
                        case 0:
                            dataMap.put("id", cellvalue);
                            break;
                        case 1:
                            dataMap.put("pw", cellvalue);
                            break;
                        case 2:
                            dataMap.put("name", cellvalue);
                            break;
                        case 3:
                            dataMap.put("email", cellvalue);
                            break;
                        case 4:
                            System.out.println("phone : " + cellvalue);
                            String[] arr = cellvalue.split("-");
                            cellvalue = "";
                            for (String str : arr) {
                                cellvalue += str;
                            }
                            dataMap.put("phone", cellvalue);
                            break;
                        case 5:
                            cellvalue = cellvalue.substring(0, 5);
                            dataMap.put("postcode", cellvalue);
                            break;
                        case 6:
                            dataMap.put("roadAddress", cellvalue);
                            break;
                        case 7:
                            dataMap.put("jibunAddress", cellvalue);
                            break;
                        case 8:
                            dataMap.put("detailAddress", cellvalue);
                            break;
                        case 9:
                            dataMap.put("oriname", cellvalue);
                            break;
                        case 10:
                            dataMap.put("sysname", cellvalue);
                            break;
                        case 11:
                            dataMap.put("savePath", cellvalue);
                            break;
                    }

                }

            }
            if (dataMap.size() != 0) {
                result.add(dataMap);
            }

        }


        return result;
    }
}
