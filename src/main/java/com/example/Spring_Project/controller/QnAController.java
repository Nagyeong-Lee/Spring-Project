package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.AnswerDTO;
import com.example.Spring_Project.dto.QuestionDTO;
import com.example.Spring_Project.service.QnAService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

import java.util.HashMap;
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
    public String toMyQnA(Model model, String id, Integer cpage) throws Exception {
        System.out.println("cpage = " + cpage);
        if (cpage == null) {
            cpage = 1;
        }
        Integer postCnt = qnAService.countMyQuestion(id); //질문 개수
        Map<String, Object> paging = qnAService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<QuestionDTO> questionDTOS = qnAService.getMyQnAs(start, end, id);  //작성한 Q&A 모두 가져옴
        List<Map<String, Object>> qNaList = qnAService.getQnAList(questionDTOS);
        model.addAttribute("qNaList", qNaList);
        model.addAttribute("paging", paging);
        return "/product/QnA/myQnA";
    }


    @ResponseBody
    @PostMapping("/repaging")
    public List<Object> repaging(Integer cpage, String id) throws Exception {
        Integer naviPerPage = 10;
        Map<String, Object> pagingStartEnd = qnAService.pagingStartEnd(cpage, naviPerPage);
        Integer start = Integer.parseInt(pagingStartEnd.get("start").toString());
        Integer end = Integer.parseInt(pagingStartEnd.get("end").toString());
        Integer postCnt = qnAService.countMyQuestion(id); //질문 개수
        List<QuestionDTO> questionDTOS = qnAService.getMyQnAs(start, end, id);  //작성한 Q&A 모두 가져옴
        Map<String, Object> paging = qnAService.paging(cpage, postCnt);
        List<Object> qNaList = qnAService.repaging(questionDTOS, paging);
        return qNaList;
    }

    @ResponseBody
    @PostMapping("/delete") //Q&A 삭제 ans있으면 ans 같이 삭제
    public String deleteQuestion(Integer q_seq) throws Exception {
        qnAService.deleteQuestion(q_seq);
        return "success";
    }

    @PostMapping("/updPopup")  //질문 수정 팝업으로
    public String toUpdPopup(Model model, @RequestParam Map<String, Object> param) throws Exception {
        QuestionDTO questionDTO = qnAService.getQuestion(Integer.parseInt(param.get("q_seq").toString()));  //질문 1개
//        model.addAttribute("param",param);
        model.addAttribute("questionDTO", questionDTO);
        model.addAttribute("param", param);
        return "/product/QnA/updPopup";
    }

    @ResponseBody
    @PostMapping("/updQuestion")
    public String updQuestion(@RequestParam Map<String, Object> param) throws Exception {
       Integer q_seq = Integer.parseInt(param.get("q_seq").toString());
       String content = param.get("content").toString();
        qnAService.updQuestion(q_seq,content);
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
    public String updAns(@RequestParam Map<String, Object> param) throws Exception {
        qnAService.updAns(param);
        return "success";

    }

    @ResponseBody
    @PostMapping("/deleteAns")  //답변 삭제
    public String deleteAns(@RequestParam Integer q_seq) throws Exception {
        qnAService.deleteAns(q_seq);
        return "success";

    }
}
