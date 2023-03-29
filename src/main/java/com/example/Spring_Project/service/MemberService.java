package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.MemberDTO;
import com.example.Spring_Project.mailSender.MailDTO;
import com.example.Spring_Project.mapper.MemberMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;


@Service
public class MemberService {

    @Autowired
    private MemberMapper mapper;

    //회원가입
    public void signUp(MemberDTO memberDTO, MailDTO mailDTO,
                       @RequestParam("file") MultipartFile file, MultipartHttpServletRequest request) throws Exception {
        mapper.signUp(memberDTO);
    }

    //아이디 중복 체크
    public Integer idDupleCheck(String id) throws Exception {
        return mapper.idDupleCheck(id);
    }

    //이메일 중복 체크
    public Integer emailDupleCheck(@RequestParam String email) throws Exception {
        return mapper.emailDupleCheck(email);
    }

    //탈퇴하기
    public void delete(@RequestParam String id) throws Exception {
        mapper.delete(id);
    }

    //회원 정보 가져오기
    public MemberDTO memberInfo(@RequestParam String id) throws Exception {
        return mapper.memberInfo(id);
    }
    public Integer getMemberInfo(@RequestParam String id,@RequestParam String pw) throws Exception {
        return mapper.getMemberInfo(id,pw);
    }
    //id 찾기
    public String searchId(@RequestParam String email) throws Exception {
        return mapper.searchId(email);
    }

    //id로 회원 정보 가져오기
    public MemberDTO selectById(@RequestParam String id) throws Exception {
        return mapper.selectById(id);
    }

    //email로 회원 정보 가져오기
    public MemberDTO selectByEmail(@RequestParam String email) throws Exception {
        return mapper.selectByEmail(email);
    }

    //이메일 존재 여부 체크
    public Integer isEmailExist(@RequestParam String email) throws Exception {
        return mapper.isEmailExist(email);
    }

    //임시 pw
    public void tempPw(@RequestParam String email, @RequestParam String pw) throws Exception {
        mapper.tempPw(email,pw);
    }

    //정보 수정
    public void update(MemberDTO memberDTO) throws Exception {
        mapper.update(memberDTO);
    }

    //로그인
    public Integer login(@RequestParam String id, @RequestParam String pw) throws Exception {
        return mapper.login(id, pw);
    }

    //update img
    public MemberDTO getImgInfo(@RequestParam Integer m_seq) throws Exception {
        return mapper.getImgInfo(m_seq);
    }

    public void modifyLastLoginDate(@RequestParam String id) throws Exception{ //로그인시 시간 저장
        mapper.modifyLastLoginDate(id);
    }

    public Integer diffDate(@RequestParam String id) throws Exception{
        return mapper.diffDate(id);
    }

    public void changeStatus(@RequestParam String id) throws Exception{
        mapper.changeStatus(id);
    }

    public MemberDTO getNonActiveMember(@RequestParam String id) throws Exception{
        return mapper.getNonActiveMember(id);
    }

    public Integer isMemberExist(@RequestParam String id,@RequestParam String email) throws Exception{
        return mapper.isMemberExist(id,email);
    }
    public void activeMember(@RequestParam String id, @RequestParam String email) throws Exception{
        mapper.activeMember(id,email);
    }

    //인터셉터
    public String getUserType(@Param("id") String id) throws Exception{
        return mapper.getUserType(id);
    }


}