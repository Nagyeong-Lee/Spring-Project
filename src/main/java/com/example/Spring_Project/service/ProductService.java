package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.CartDTO;
import com.example.Spring_Project.dto.OptionDTO;
import com.example.Spring_Project.dto.OptionListDTO;
import com.example.Spring_Project.dto.ProductDTO;
import com.example.Spring_Project.mapper.ProductMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ProductService {

    @Autowired
    private ProductMapper productMapper;


    public List<ProductDTO> getProducts() throws Exception { //상품 리스트 가져오기
        return productMapper.getProducts();
    }

    public ProductDTO getProductDetail(Integer pd_seq) throws Exception { //상품 상세 정보
        return productMapper.getProductDetail(pd_seq);
    }

    public List<ProductDTO> getWProduct() throws Exception { //여자 카테고리
        return productMapper.getWProduct();
    }

    public List<ProductDTO> getWOuter() throws Exception { //여자 아우터
        return productMapper.getWOuter();
    }

    public List<ProductDTO> getWTop() throws Exception { //여자 상의
        return productMapper.getWTop();
    }

    public List<ProductDTO> getWPants() throws Exception {  //여자 하의
        return productMapper.getWPants();
    }

    public List<ProductDTO> getWAccessories() throws Exception {  //여자 악세사리
        return productMapper.getWAccessories();
    }

    public List<ProductDTO> getMProduct() throws Exception {  // 남자 카테고리
        return productMapper.getMProduct();
    }

    public List<ProductDTO> getMOuter() throws Exception {  // 남자 아우터
        return productMapper.getMOuter();
    }

    public List<ProductDTO> getMTop() throws Exception {  // 남자 상의
        return productMapper.getMTop();
    }

    public List<ProductDTO> getMPants() throws Exception {  // 남자 하의
        return productMapper.getMPants();
    }

    public List<ProductDTO> getMAccessories() throws Exception {  // 남자 악세사리
        return productMapper.getMAccessories();
    }

    public List<ProductDTO> getNewProduct() throws Exception {  //신상품
        return productMapper.getNewProduct();
    }

    public List<ProductDTO> getNewOuter() throws Exception {  //신상아우터
        return productMapper.getNewOuter();
    }

    public List<ProductDTO> getNewTop() throws Exception {  //신상 상의
        return productMapper.getNewTop();
    }

    public List<ProductDTO> getNewPants() throws Exception {  //신상 하의
        return productMapper.getNewPants();
    }

    public List<ProductDTO> getNewAccessories() throws Exception {  //신상 악세사리
        return productMapper.getNewAccessories();
    }

    public List<OptionDTO> getOptions(Integer pd_seq) throws Exception { //상품 옵션 가져오기
        return productMapper.getOptions(pd_seq);
    }

    public List<String> getCategory(Integer pd_seq) throws Exception { //상품 옵션 가져오기
        return productMapper.getCategory(pd_seq);
    }

    public List<String> optionByCategory(Integer pd_seq) throws Exception { //상품 카테고리별 옵션 정보
        return productMapper.optionByCategory(pd_seq);
    }

    public List<OptionListDTO> getOptionByGroup(String category, Integer pd_seq) throws Exception { //ex 색상 항목들
        return productMapper.getOptionByGroup(category, pd_seq);
    }

//    public void insertCart(Map<String, Object> map) throws Exception {
//        productMapper.insertCart(map);
//    }

    public void insertCart(String id,Integer count,Integer pd_seq, String optionList) throws Exception {
        productMapper.insertCart(id,count,pd_seq,optionList);
    }

    public void minusOption(Integer pd_seq, String optionName) throws Exception {
        productMapper.minusOption(pd_seq, optionName);
    }

    public void minusPd(Integer pd_seq) throws Exception {
        productMapper.minusPd(pd_seq);
    }

    public Integer getOptionStock(Integer pd_seq, String optionName) throws Exception {
        return productMapper.getOptionStock(pd_seq, optionName);
    }

    public void updateOptionStatus(Integer option_seq) throws Exception {
        productMapper.updateOptionStatus(option_seq);
    }

    public void updatePdStatus(Integer product_seq) throws Exception {
        productMapper.updatePdStatus(product_seq);
    }

    public Integer getPdStock(Integer pd_seq) throws Exception {
        return productMapper.getPdStock(pd_seq);
    }

    public List<CartDTO> getCartInfo(String id) throws Exception{
        return productMapper.getCartInfo(id);
    }

    public List<String> getOptionCategory(Integer cart_seq) throws Exception{
        return productMapper.getOptionCategory(cart_seq);
    }

    public void deleteItem(Integer cart_seq) throws Exception{  //장바구니에서 아이템 삭제
        productMapper.deleteItem(cart_seq);
    }
}
