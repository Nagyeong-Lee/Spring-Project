package com.example.Spring_Project.excel;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.util.CellReference;
import org.springframework.stereotype.Repository;

@Repository
public class ExcelCellRef {  //데이터 구분

    public static String getName(Cell cell, int cellIndex) {
        int cellNum = 0;
        if (cell != null) {
            cellNum = cell.getColumnIndex();
        } else {
            cellNum = cellIndex;
        }

        return CellReference.convertNumToColString(cellNum);
    }

    public static String getValue(Cell cell) {
        String value = "";

        if (cell == null) {
            value = "";
        } else {
            value = cell.getStringCellValue();
        }
        return value;
    }

}
