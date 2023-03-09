package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.encryption.AES256;
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

import static org.apache.tomcat.util.net.openssl.ciphers.Encryption.AES256;

@Service
public class MemberService {

    @Autowired
    private AES256 aes256;
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

        memberDTO.setPw(aes256.encrypt(memberDTO.getPw()));  //비밀번호 암호화
        mapper.signUp(memberDTO);
    }

    //아이디 중복 체크
    public Integer idDupleCheck (String id) throws Exception{
        return mapper.idDupleCheck(id);
    }

    //이메일 중복 체크
    public Integer emailDupleCheck(@RequestParam String email) throws Exception{
        return mapper.emailDupleCheck(email);
    }
    //로그인
    public Integer login(@RequestParam String id, @RequestParam String pw) throws Exception{
        return mapper.login(id, aes256.encrypt(pw));
    }

    //탈퇴하기
    public void delete(@RequestParam String id) throws Exception{
         mapper.delete(id);
    }

    //회원 정보 가져오기
    public MemberDTO memberInfo(@RequestParam String id) throws Exception{
        return mapper.memberInfo(id);
    }

    //id 찾기
    public String searchId(@RequestParam String email) throws Exception{
        return mapper.searchId(email);
    }

   //pw 찾기
    public String searchPw(@RequestParam String id) throws Exception{
        return mapper.searchPw(id);
    }

}