package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.AnswerDTO;
import com.example.Spring_Project.dto.QuestionDTO;
import com.example.Spring_Project.service.QnAService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

import java.util.Map;
import java.util.List;

//@Controller
@Controller
@RequestMapping("/QnA")
public class QnAController {

    @Autowired
    private QnAService qnAService;

    @PostMapping("/popup") //QnA 작성 팝업
    public String openPopup(Model model, @RequestParam Map<String, Object> param) throws Exception {
        // id,pd_seq
        model.addAttribute("param", param);
        return "/product/QnA/QnApopup";
    }

    @ResponseBody
    @PostMapping("/insert") //Q 등록
    public String insertQuestion(@RequestParam Map<String, Object> param) throws Exception {
        qnAService.insertQuestion(param); //Q 등록
        return "success";
    }

    @RequestMapping("") //나의 Q&A 조회로
    public String toMyQnA(Model model, String id) throws Exception {
        List<QuestionDTO> questionDTOS = qnAService.getMyQnAs(id);  //작성한 Q&A 모두 가져옴
        List<Map<String, Object>> qNaList = qnAService.getQnAList(questionDTOS);
        model.addAttribute("qNaList", qNaList);
        return "/product/QnA/myQnA";
    }


    @ResponseBody
    @PostMapping("/{q_seq}") //Q&A 삭제 ans있으면 ans 같이 삭제
    public String deleteQuestion(@PathVariable("q_seq") Integer q_seq) throws Exception {
        qnAService.deleteQuestion(q_seq);
        return "success";
    }

    @PostMapping("/updPopup")  //질문 수정 팝업으로
    public String toUpdPopup(Model model, @RequestParam Map<String, Object> param) throws Exception {
        QuestionDTO questionDTO = qnAService.getQuestion(Integer.parseInt(param.get("q_seq").toString()));  //질문 1개
//        model.addAttribute("param",param);
        model.addAttribute("questionDTO", questionDTO);
        return "/product/QnA/updPopup";
    }

    @ResponseBody
    @PostMapping("/updQuestion")
    public String updQuestion(@RequestParam Map<String, Object> param) throws Exception {
        qnAService.updQuestion(param);
        return "success";
    }

    @PostMapping("/ansPopup")  //답변 작성 팝업으로
    public String toAnsPopup(Model model, @RequestParam Map<String, Object> param) throws Exception {
        model.addAttribute("param", param);
        return "/admin/ansPopup";
    }

    @ResponseBody
    @PostMapping("/addAns") //답변 작성
    public String addAns(@RequestParam Map<String, Object> param) throws Exception {
        qnAService.insertAns(param);
        return "success";
    }

    @PostMapping("/updAnsPopup")  //관리자 답변 수정 팝업으로
    public String toUpdAnsPopup(Model model, @RequestParam Map<String, Object> param) throws Exception {
        AnswerDTO answerDTO = qnAService.getAnswer(Integer.parseInt(param.get("q_seq").toString()));
        model.addAttribute("param", param);
        model.addAttribute("answerDTO", answerDTO);
        return "/admin/updPopup";
    }

    @ResponseBody
    @PostMapping("/updAns")  //답변 수정
    public String updAns(@RequestParam Map<String,Object> param) throws Exception {
        qnAService.updAns(param);
        return "success";

    }
}
