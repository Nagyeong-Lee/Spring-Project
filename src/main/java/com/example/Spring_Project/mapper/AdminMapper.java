package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.MemberDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;


@Repository
@Mapper
public interface AdminMapper {

    List<MemberDTO>selectMemberList(); //회원 리스트 출력
    Integer select1(); //1-3
    Integer select2(); //4-6
    Integer select3(); //7-9
    Integer select4(); //10-12
    void insertExcel(Map<String, Object> excelContent); //엑셀 insert

}
