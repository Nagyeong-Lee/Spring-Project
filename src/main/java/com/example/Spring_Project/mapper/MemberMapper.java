package com.example.Spring_Project.mapper;


import com.example.Spring_Project.dto.*;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.List;

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
    Integer getMemberInfo(@Param("id") String id, @Param("pw") String pw);

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


    Integer isMemberExist(@Param("id") String id,@Param("email") String email,@Param("password")String password);
    void activeMember(@Param("id") String id, @Param("email") String email);

    void modifyLastLoginDateNull(@Param("id") String id, @Param("email") String email);

    Integer getEventNextval();

    void insertEvent(EventDTO eventDTO);
    List<EventDTO>getEvents();
    List<EventFileDTO>getEventFile();


    //쿠폰 발급
    void insertCoupon(@Param("m_seq")Integer m_seq);

    //로그인한 아이디의 seq
    Integer getmSeq(@Param("id") String id);
    //쿠폰 가져오기
    List<CouponDTO>getCoupon(@Param("m_seq") Integer m_seq);
    MemberDTO getMemInfo(@Param("id") String id);

}