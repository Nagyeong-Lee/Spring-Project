package com.example.Spring_Project.service;


import com.example.Spring_Project.dto.BoardDTO;
import com.example.Spring_Project.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Service
public class BoardService {

    @Autowired
    private BoardMapper mapper;

    public void insert(@RequestParam BoardDTO boardDTO)throws Exception{  //게시글 insert
        mapper.insert(boardDTO);
    }

    public List<BoardDTO> select() throws Exception{   //게시글 리스트 출력
        return mapper.select();
    }

    public BoardDTO getBoardDetail(@RequestParam Integer b_seq) throws Exception{  //게시글 상세정보 출력
        return mapper.getBoardDetail(b_seq);
    }

}
