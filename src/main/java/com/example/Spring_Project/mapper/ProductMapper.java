package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.OptionDTO;
import com.example.Spring_Project.dto.OptionListDTO;
import com.example.Spring_Project.dto.ProductDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Mapper
@Repository
public interface ProductMapper {
    List<ProductDTO> getProducts();
    ProductDTO getProductDetail(@Param("pd_seq") Integer pd_seq);

    List<ProductDTO> getWProduct(); //여자 카테고리만

    List<ProductDTO> getWOuter(); //여자 아우터

    List<ProductDTO> getWTop(); //여자 상의

    List<ProductDTO> getWPants(); //여자 하의
    List<ProductDTO> getWAccessories(); //여자 악세사리
    List<ProductDTO> getMProduct(); //남자 카테고리
    List<ProductDTO> getMOuter(); //남자 아우터
    List<ProductDTO> getMTop(); //남자 상의
    List<ProductDTO> getMPants(); //남자 하의
    List<ProductDTO> getMAccessories(); //남자 악세사리
    List<ProductDTO> getNewProduct(); //신상품
    List<ProductDTO> getNewOuter(); //신상아우터
    List<ProductDTO> getNewTop(); //신상 상의
    List<ProductDTO> getNewPants(); //신상  하의
    List<ProductDTO> getNewAccessories(); //신상  악세사리

    List<OptionDTO> getOptions(@Param("pd_seq") Integer pd_seq); //상품 옵션 정보 가져오기
    List<String> getCategory(@Param("pd_seq") Integer pd_seq); //상품 옵션 정보 가져오기
    List<String> optionByCategory(@Param("pd_seq") Integer pd_seq); //상품 카테고리별 옵션 정보
    List<OptionListDTO> getOptionByGroup(@Param("category") String category,@Param("pd_seq") Integer pd_seq); //상품 카테고리별 옵션 정보
    void insertCart(Map<String,Object>map);
    void minusOption(@Param("pd_seq") Integer pd_seq,@Param("optionName") String optionName);
    void minusPd(@Param("pd_seq") Integer pd_seq);
    Integer getOptionStock(@Param("pd_seq") Integer pd_seq,@Param("optionName") String optionName);
    Integer updateOptionStatus(@Param("option_seq") Integer option_seq);
    Integer updatePdStatus(@Param("pd_seq") Integer pd_seq);
    Integer getPdStock(@Param("pd_seq") Integer pd_seq);
}
