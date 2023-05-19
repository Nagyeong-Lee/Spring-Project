package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.AnswerDTO;
import com.example.Spring_Project.dto.ProductDTO;
import com.example.Spring_Project.dto.QuestionDTO;
import com.example.Spring_Project.mapper.QnAMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service

public class QnAService {
    @Autowired
    private QnAMapper qnAMapper;

//    @Autowired
//    private ProductService productService;


    public void insertQuestion(Map<String, Object> param) throws Exception {
        qnAMapper.insertQuestion(param);
    }

    public List<QuestionDTO> getQuestions(Integer pd_seq) throws Exception {
        return qnAMapper.getQuestions(pd_seq);
    }

    public Integer isAnswerExist(Integer q_seq) throws Exception {
        return qnAMapper.isAnswerExist(q_seq);
    }

    public AnswerDTO getAnswer(Integer q_seq) throws Exception {
        return qnAMapper.getAnswer(q_seq);
    }

    public ProductDTO pdInfo(Integer pd_seq) throws Exception {
        return qnAMapper.pdInfo(pd_seq);
    }

    //질문 + 답변
    public List<Map<String, Object>> getQnAList(List<QuestionDTO> questionDTOS) throws Exception {
        List<Map<String, Object>> qNaList = new ArrayList<>();
        for (QuestionDTO dto : questionDTOS) {
            Map<String, Object> map = new HashMap<>();
            Integer q_seq = dto.getQ_seq();
            Integer isAnswerExist = isAnswerExist(q_seq);
//            ProductDTO productDTO = productService.getPdInfo(dto.getPd_seq());//상품 정보
            ProductDTO productDTO = pdInfo(dto.getPd_seq());//상품 정보
            map.put("productDTO", productDTO);
            if (isAnswerExist != 0) { //답변 있으면 map put
                AnswerDTO answerDTO = getAnswer(q_seq); //답변
                map.put("answerDTO", answerDTO);
                map.put("answerYN", "Y");
            } else {
                map.put("answerYN", "N");
            }
            map.put("questionDTO", dto);
            qNaList.add(map);
        }
        return qNaList;
    }

    public List<QuestionDTO> getMyQnAs(String id) throws Exception {
        return qnAMapper.getMyQnAs(id);
    }

    @Transactional
    public void deleteQuestion(Integer q_seq) throws Exception {
        qnAMapper.deleteQuestion(q_seq); //Q&A 삭제
        Integer isAnswerExist = qnAMapper.isAnswerExist(q_seq);
        if (isAnswerExist != 0) qnAMapper.deleteAnswer(q_seq);  //답변 있을때 답변도 삭제
    }

    public QuestionDTO getQuestion(Integer q_seq) throws Exception {
        return qnAMapper.getQuestion(q_seq);
    }

    public void updQuestion(Map<String, Object> param) throws Exception {
        qnAMapper.updQuestion(param);
    }

    public List<QuestionDTO> qNaList(Integer start, Integer end) throws Exception {
        return qnAMapper.qNaList(start, end);
    }

    public void insertAns(Map<String, Object> param) throws Exception {
        qnAMapper.insertAns(param);
    }

    public void updAns(Map<String, Object> param) throws Exception {
        qnAMapper.updAns(param);
    }

    public Integer countQuestion() throws Exception {
        return qnAMapper.countQuestion();
    }

    //페이징
    public List<Object> repaging(List<QuestionDTO>questionDTOS,Map<String, Object> paging) throws Exception {
        List<Object> qNaList = new ArrayList<>();
        for (QuestionDTO dto : questionDTOS) {
            Map<String, Object> reMap = new HashMap<>();
            reMap.put("startNavi", Integer.parseInt(paging.get("startNavi").toString()));
            reMap.put("endNavi", Integer.parseInt(paging.get("endNavi").toString()));
            reMap.put("needPrev", Boolean.parseBoolean(paging.get("needPrev").toString()));
            reMap.put("needNext", Boolean.parseBoolean(paging.get("needNext").toString()));
            reMap.put("paging", paging);
            reMap.put("cpage", Integer.parseInt(paging.get("cpage").toString()));

            Integer q_seq = dto.getQ_seq();
            Integer isAnswerExist = isAnswerExist(q_seq);
//            ProductDTO productDTO = productService.getPdInfo(dto.getPd_seq());//상품 정보
            ProductDTO productDTO = pdInfo(dto.getPd_seq());//상품 정보
            reMap.put("productDTO", productDTO);
            if (isAnswerExist != 0) { //답변 있으면 map put
                AnswerDTO answerDTO = getAnswer(q_seq); //답변
                reMap.put("answerDTO", answerDTO);
                reMap.put("answerYN", "Y");
            } else {
                reMap.put("answerYN", "N");
            }
            reMap.put("questionDTO", dto);
            qNaList.add(reMap);
        }
        return qNaList;
    }
}
