package com.example.Spring_Project.service;
import com.example.Spring_Project.dto.CommentDTO;
import com.example.Spring_Project.dto.ReplyDTO;
import com.example.Spring_Project.mapper.CommentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Service
public class CommentService {

    @Autowired
    private CommentMapper mapper;

    public void insert(CommentDTO commentDTO) throws Exception {  //댓글 insert
        mapper.insert(commentDTO);
    }

    public List<ReplyDTO> getComment(@RequestParam Integer b_seq) throws Exception {  //댓글까지 같이 출력
        return mapper.getComment(b_seq);
    }

    public void reply(@RequestParam String writer, @RequestParam String content, @RequestParam Integer b_seq
                    ,@RequestParam Integer parent_cmt_seq)throws Exception { // 대댓글 insert
        mapper.reply(writer, content, b_seq,parent_cmt_seq);
    }

    public void deleteCmt(@RequestParam Integer cmt_seq) throws Exception{
       mapper.deleteCmt(cmt_seq);
    }

    public void updateCmt(@RequestParam String content, @RequestParam Integer b_seq, @RequestParam Integer cmt_seq) throws Exception{
        mapper.updateCmt(content,b_seq,cmt_seq);
    }

    public Integer getParentSeq(@RequestParam Integer cmt_seq) throws Exception{
        return mapper.getParentSeq(cmt_seq);
    }

    public Integer getCurrentVal() throws Exception{
        return mapper.getCurrentVal();
    }


}