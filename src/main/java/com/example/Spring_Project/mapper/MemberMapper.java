package com.example.Spring_Project.mapper;


import com.example.Spring_Project.dto.MemberDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

@Repository
@Mapper
public interface MemberMapper {

    //회원가입
    void signUp(MemberDTO memberDTO);


    //아이디 중복 체크
    Integer idDupleCheck(@Param("id") String id);

    //이메일 중복 체크
    Integer emailDupleCheck(@Param("email") String email);

    //로그인
    Integer login(@Param("id") String id, @Param("pw") String pw);

    //탈퇴하기
    void delete(@Param("id") String id);

    //회원 정보 가져오기
    MemberDTO memberInfo(@Param("id") String id);

    //id 찾기
    String searchId(@Param("email") String email);

    //pw 찾기
    String searchPw(@Param("id") String id);

    MemberDTO selectById(@Param("id") String id);

    MemberDTO selectByEmail(@Param("email") String email);

    Integer isEmailExist(@Param("email") String email);

    void tempPw(@Param("email") String email, @Param("pw") String pw); //임시 pw

    void update(MemberDTO memberDTO); //정보수정

    MemberDTO getImgInfo(@Param("m_seq") Integer m_seq);

    String getUserType(@Param("id") String id);  //인터셉터

    void modifyLastLoginDate(@Param("id") String id);

    Integer diffDate(@Param("id") String id);

    MemberDTO getNonActiveMember(@Param("id") String id);

    void changeStatus(@Param("id") String id);


    Integer isMemberExist(@Param("id") String id,@Param("email") String email);
    void activeMember(@Param("id") String id, @Param("email") String email);

    Integer loginCheck(@Param("id") String id, @Param("pw") String pw); //aop log
}