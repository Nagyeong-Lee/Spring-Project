package com.example.Spring_Project.mailSender;

import com.example.Spring_Project.mailSender.MailDTO;
import com.example.Spring_Project.mailSender.MailService;
import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@Controller
public class MailController {

    @Autowired
    private MailService mailService;

    @ResponseBody
    @PostMapping("/mail")
    public void sendMail(MailDTO mailDTO) {
        mailService.mailSend(mailDTO);
    }

}