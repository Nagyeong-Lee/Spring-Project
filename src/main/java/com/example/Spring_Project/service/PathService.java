package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.PathDTO;
import com.example.Spring_Project.mapper.PathMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class PathService {

    @Autowired
    private PathMapper mapper;

    public String getCommunityPath() throws Exception {
        return mapper.getCommunityPath();
    }

    public String getLogoutPath() throws Exception {
        return mapper.getLogoutPath();
    }

    public String getDeletePath() throws Exception {
        return mapper.getDeletePath();
    }

    public String getUpdateFormPath() throws Exception {
        return mapper.getUpdateFormPath();
    }
    public String getHospitalPath() throws Exception {
        return mapper.getHospitalPath();
    }
    public String getDaily() throws Exception {
        return mapper.getDaily();
    }

    public String getMonthly() throws Exception {
        return mapper.getMonthly();
    }

    public List<PathDTO> getPathList() throws Exception {
        return mapper.getPathList();
    }
    public List<PathDTO> getNewsPathList() throws Exception {
        return mapper.getNewsPathList();
    }

}
