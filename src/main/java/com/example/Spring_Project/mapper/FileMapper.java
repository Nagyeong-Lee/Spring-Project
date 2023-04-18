package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.FileDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface FileMapper {
    void insert(List<Map<String, Object>> list);

    void insertMap(Map<String, Object> map);
    void insertEventMap(Map<String, Object> map);

    List<FileDTO> getFile(@Param("b_seq") Integer b_seq);

    FileDTO getFileInfo(@Param("f_seq") Integer f_seq);
}
