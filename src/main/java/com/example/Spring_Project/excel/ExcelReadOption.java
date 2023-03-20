package com.example.Spring_Project.excel;

import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class ExcelReadOption {


    private String filePath; //	엑셀파일 경로
    private List<String> outputColumns; //열 이름
    private int startRow;//행 번호

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public List<String> getOutputColumns() {

        List<String> temp = new ArrayList<String>();
        temp.addAll(outputColumns);

        return temp;
    }

    public void setOutputColumns(List<String> outputColumns) {

        List<String> temp = new ArrayList<String>();
        temp.addAll(outputColumns);

        this.outputColumns = temp;
    }

    public void setOutputColumns(String ... outputColumns) {

        if(this.outputColumns == null) {
            this.outputColumns = new ArrayList<String>();
        }

        for(String ouputColumn : outputColumns) {
            this.outputColumns.add(ouputColumn);
        }
    }

    public int getStartRow() {
        return startRow;
    }
    public void setStartRow(int startRow) {
        this.startRow = startRow;
    }
}