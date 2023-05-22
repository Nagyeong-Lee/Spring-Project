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

    public List<QuestionDTO> getMyQnAs(Integer start,Integer end,String id) throws Exception {
        return qnAMapper.getMyQnAs(start,end,id);
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

    public void updQuestion(Integer q_seq,String content) throws Exception {
        qnAMapper.updQuestion(q_seq,content);
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

    public Integer countMyQuestion(String id) throws Exception{
        return qnAMapper.countMyQuestion(id);
    }
    public Map<String, Object> paging(Integer cpage,Integer postCnt) throws Exception {
        //현재 페이지
//        Integer postCount = salesPdCount(); //판매 상품수
        Integer postCount = postCnt; //판매 상품수
        System.out.println("postCount = " + postCount);
        Integer postPerPage = 10; //페이지 당 글 개수
        Integer naviPerPage = 10; //페이지 당 내비 수
        Integer totalPageCount = 0; //전체 페이지 수
        Map<String, Object> map = new HashMap<>();
        if (postCount % naviPerPage > 0) {
            totalPageCount = postCount / naviPerPage + 1;
        } else {
            totalPageCount = postCount / naviPerPage;
        }

        if (cpage > totalPageCount) {
            cpage = totalPageCount;
        }

        int startNavi = (cpage - 1) / naviPerPage * naviPerPage + 1;  //페이지 start
        int endNavi = startNavi + naviPerPage - 1; //페이지 end

        if (endNavi > totalPageCount) {
            endNavi = totalPageCount;
        }

        boolean needPrev = true;
        boolean needNext = true;

        if (startNavi == 1) {
            needPrev = false;
        }
        if (endNavi == totalPageCount) {
            needNext = false;
        }

        map.put("startNavi", startNavi);
        map.put("endNavi", endNavi);
        map.put("needPrev", needPrev);
        map.put("needNext", needNext);
        map.put("totalPageCount", totalPageCount);
        map.put("cpage", cpage);
        return map;
    }

    public Map<String, Object> pagingStartEnd(Integer cpage, Integer naviPerPage) throws Exception {
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        Map<String, Object> map = new HashMap<>();
        map.put("start", start);
        map.put("end", end);
        return map;
    }

    public Integer filteredReviewCnt(List<String> pcArr, List<String> chCArr, List<String> starArr
            , String selectType, String keyword) throws Exception{
        return qnAMapper.filteredReviewCnt(pcArr,chCArr,starArr,selectType,keyword);
    }
}
