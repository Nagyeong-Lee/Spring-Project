package com.example.Spring_Project.service;
import com.example.Spring_Project.dto.CommentDTO;
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

    public List<CommentDTO> getComment(@RequestParam Integer b_seq) throws Exception {  //댓글까지 같이 출력해서 리스트 뿌리기
        return mapper.getComment(b_seq);
    }

    public void reply(@RequestParam String writer, @RequestParam String content, @RequestParam Integer b_seq
                    ,@RequestParam Integer parent_cmt_seq)throws Exception {
        mapper.reply(writer, content, b_seq,parent_cmt_seq);   // 대댓글 insert
    }
}