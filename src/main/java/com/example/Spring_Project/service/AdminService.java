package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.mapper.AdminMapper;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.relational.core.sql.In;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminService {
    @Autowired
    private AdminMapper adminMapper;

    public List<MemberDTO> selectMemberList() throws Exception{  //회원 리스트 출력
        return adminMapper.selectMemberList();
    }

    public Integer select1() throws Exception{  //1-3
        return adminMapper.select1();
    }

    public Integer select2() throws Exception{  //4-6
        return adminMapper.select2();
    }

    public Integer select3() throws Exception{  //7-9
        return adminMapper.select3();
    }

    public Integer select4() throws Exception{  //10-12
        return adminMapper.select4();
    }
}
