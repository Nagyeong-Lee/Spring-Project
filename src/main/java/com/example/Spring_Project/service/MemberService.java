package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.encryption.SHA256;
import com.example.Spring_Project.mailSender.MailDTO;
import com.example.Spring_Project.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.UUID;

@Service
public class MemberService {

    @Autowired
    private SHA256 sha256;
    @Autowired
    private MemberMapper mapper;

    private Integer maxSize=1024 * 1024 *10;


    //회원가입
    public void signUp(MemberDTO memberDTO,MailDTO mailDTO,
                       MultipartFile file, MultipartHttpServletRequest request) throws Exception{  // 회원가입

        String path="/resources/img/";
        String savePath=request.getServletContext().getRealPath(path); //웹어플리케이션이 설치된 곳의 경로
        System.out.println("savePath : "+savePath);
        File fileSavePath = new File(savePath);

        if(!fileSavePath.exists()){
            fileSavePath.mkdir();
        }

        String oriname=file.getOriginalFilename(); //원래 파일 이름
        System.out.println("oriname : "+oriname);
        String sysname= UUID.randomUUID()+"_"+file.getOriginalFilename();

        file.transferTo(new File(fileSavePath+"/"+sysname));

        memberDTO.setOriname(oriname);
        memberDTO.setSysname(sysname);
        memberDTO.setSavePath(savePath);

        memberDTO.setPw(sha256.encrypt(memberDTO.getPw()));  //비밀번호 암호화
        mapper.signUp(memberDTO);
    }

    //아이디 중복 체크
    public void idDupleCheck (String id) throws Exception{
        mapper.idDupleCheck(id);
    }

}