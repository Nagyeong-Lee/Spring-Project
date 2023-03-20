package com.example.Spring_Project;

import com.example.Spring_Project.service.PathService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import javax.servlet.http.HttpSession;

@Configuration
@EnableWebSecurity // 스프링 시큐리티 필터가 스프링 필터체인에 등록 된다.
@AllArgsConstructor
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private PathService service;

    @Autowired
    private HttpSession session;

    // 해당 메서드의 리턴되는 오브젝트를 IoC로 등록해준다.
    @Bean
    public BCryptPasswordEncoder encodePwd() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
//
//        //ROLE 가져오기
//        String id = (String) session.getAttribute("id");
//        String role = service.getRole(id);
//        if(role.equals("ROLE_MEMBER")){
//            String role_member="ROLE_MEMBER";
//        }else if(role.equals("ROLE_ADMIN")){
//            String role_admin="ROLE_ADMIN";
//        }

        http.csrf().disable(); //csrf 비활성화
        http.authorizeRequests()
//                .antMatchers("/member/**").access("hasRole(role_member) or hasRole(role_admin)") // 인증만 되면 들어갈 수 있는 주소
//                .antMatchers("/board/**").access("hasRole(role_member) or hasRole(role_admin)")
//                .antMatchers("/file/**").access("hasRole(role_member) or hasRole(role_admin)")
//                .antMatchers("/comment/**").access("hasRole(role_member) or hasRole(role_admin)")
//                .antMatchers("/admin/**").access("hasRole('role_admin')")
                .antMatchers("/").permitAll(); //index 페이지
//                .and()
//                .formLogin()
//                .loginPage("/member/login")
//                .loginProcessingUrl("/member/login"); // /login 주소가 호출이 되면 시큐리티가 낚아채서 대신 로그인을 진행해준다.

    }
}