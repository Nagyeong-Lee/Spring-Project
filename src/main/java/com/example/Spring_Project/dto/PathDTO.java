package com.example.Spring_Project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class PathDTO {
    private Integer path_seq;
    private String path;
    private String name;
    private Integer parent_path_seq;
}
