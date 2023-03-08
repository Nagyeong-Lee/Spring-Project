package com.example.Spring_Project.mailSender;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MailService {

    @Autowired
    private JavaMailSender mailSender;
    private static final String FROM_ADDRESS = "nhd5607@gmail.com";

    public void mailSend(MailDTO mailDTO) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(mailDTO.getAddress());            // 받는 사람 주소
        message.setFrom(MailService.FROM_ADDRESS);      // 보내는 사람 주소
        message.setSubject(mailDTO.getTitle());         // 제목
        message.setText(mailDTO.getMessage());          // 메시지 내용

        mailSender.send(message); //메일 발송
    }
}