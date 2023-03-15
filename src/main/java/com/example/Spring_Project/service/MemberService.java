package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.mailSender.MailDTO;
import com.example.Spring_Project.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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
    private BCryptPasswordEncoder bCryptPasswordEncoder;
    @Autowired
    private MemberMapper mapper;

    private Integer maxSize=1024 * 1024 *10;


    //회원가입
    public void signUp(MemberDTO memberDTO,MailDTO mailDTO,
                       @RequestParam("file") MultipartFile file, MultipartHttpServletRequest request) throws Exception{  // 회원가입

        memberDTO.setPw(bCryptPasswordEncoder.encode(memberDTO.getPw()));  //비밀번호 암호화
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
        return mapper.login(id, bCryptPasswordEncoder.encode(pw));
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

    public MemberDTO selectById(@RequestParam String id) throws Exception{
        return mapper.selectById(id);
    }

    public MemberDTO selectByEmail(@RequestParam String email) throws Exception{
        return mapper.selectByEmail(email);
    }
    public Integer isEmailExist(@RequestParam String email) throws Exception{
        return mapper.isEmailExist(email);
    }

    public void tempPw(@RequestParam String email,@RequestParam String pw) throws Exception{
         mapper.tempPw(email,bCryptPasswordEncoder.encode(pw));
    }
}