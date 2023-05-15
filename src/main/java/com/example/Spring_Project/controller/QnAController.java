package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.QuestionDTO;
import com.example.Spring_Project.service.QnAService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

import java.util.Map;
import java.util.List;

@Controller
@RequestMapping("/QnA")
public class QnAController {

    @Autowired
    private QnAService qnAService;
    
    @PostMapping("") //QnA 작성 팝업
    public String openPopup(Model model, @RequestParam Map<String,Object> param) throws Exception{
        System.out.println("param = " + param);
        // id,pd_seq
        model.addAttribute("param",param);
       return "/product/QnA/QnApopup";
    }

    @ResponseBody
    @PostMapping("/insert") //Q 등록
    public String insertQuestion(@RequestParam Map<String,Object> param) throws Exception{
        qnAService.insertQuestion(param); //Q 등록
        return "success";
    }

    @PostMapping("/{id}") //나의 Q&A 조회로
    public String toMyQnA(Model model,@PathVariable("id") String id) throws Exception{
        List<QuestionDTO> questionDTOS = qnAService.getMyQnAs(id);  //작성한 Q&A 모두 가져옴
        List<Map<String, Object>> qNaList = qnAService.getQNaList(questionDTOS);
        model.addAttribute("qNaList",qNaList);
        return "/product/QnA/myQnA";
    }

    @PostMapping("/{q_seq}") //Q&A 삭제
    public String deleteQuestion(@PathVariable("q_seq") Integer q_seq, @RequestParam String id) throws Exception{
        qnAService.deleteQuestion(q_seq);
        return "/product/QnA/myQnA";
    }
}
