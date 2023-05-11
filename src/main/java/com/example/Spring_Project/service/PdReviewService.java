package com.example.Spring_Project.service;

import com.example.Spring_Project.mapper.PdReviewMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.*;

@Service
public class PdReviewService {
    @Autowired
    private PdReviewMapper pdReviewMapper;

    //file insert

    //review insert
    public void reviewInsert(Map<String, Object> param) throws Exception {

    }

    public void insertReview(Map<String, Object> param, List<MultipartFile> file) throws Exception {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        boolean flag = true;
        pdReviewMapper.reviewInsert(param);//리뷰 인서트
        if (file != null) {  //파일 인서트
            String path = "D:/storage/";
            File dir = new File(path);
            if (!dir.isDirectory()) {
                dir.mkdirs();
            }
            for (MultipartFile f : file) {
                Map<String, Object> map = new HashMap<>();
                String oriname = f.getOriginalFilename();
                if (oriname.equals("")) {
                    flag = false;
                }
                UUID uuid = UUID.randomUUID();
                String sysname = uuid + "_" + oriname;
                String savePath = path + sysname;

                f.transferTo(new File(savePath));
                map.put("b_seq", b_seq);
                map.put("oriname", oriname);
                map.put("sysname", sysname);
                list.add(map);
            }
            Integer size = list.size();
            for (int i = 0; i < size; i++) {
                fileService.insertMap(list.get(i));
            }
        }
    }
}
