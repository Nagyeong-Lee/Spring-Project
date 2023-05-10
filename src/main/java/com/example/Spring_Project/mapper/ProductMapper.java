package com.example.Spring_Project.mapper;

import com.example.Spring_Project.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

@Mapper
@Repository
public interface ProductMapper {
    List<ProductDTO> getProducts(@Param("start") Integer start,@Param("end") Integer end);
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
    void insertCart(@Param("id") String id,@Param("count") Integer count,@Param("pd_seq") Integer pd_seq, @Param("optionList")String optionList); //옵션 있을때
    void insertCartWtOption(@Param("id") String id,@Param("count") Integer count,@Param("pd_seq") Integer pd_seq); //옵션 없을때
    void minusOption(@Param("pd_seq") Integer pd_seq,@Param("optionName") String optionName);
    void minusPd(@Param("pd_seq") Integer pd_seq);
    OptionDTO getOptionStock(Map<String,Object>map);
    Integer updateOptionStatus(@Param("option_seq") Integer option_seq);
    Integer updatePdStatus(@Param("pd_seq") Integer pd_seq);
    Integer getPdStock(@Param("pd_seq") Integer pd_seq);
    List<CartDTO>getCartInfo(@Param("id")String id);
    List<String>getOptionCategory(@Param("cart_seq")Integer cart_seq);
    void deleteItem(@Param("cart_seq")Integer cart_seq);
    Map<String,Object> getCartOption(@Param("cart_seq")Integer cart_seq);
    Integer getOptionCount(@Param("pd_seq") Integer pd_seq, @Param("option") String option);
    Integer getPdPrice(@Param("pd_seq") Integer pd_seq);
    Integer getMemberSeq(@Param("id") String id);
    List<CouponDTO> getCoupon(@Param("m_seq") Integer m_seq);
    void updateCount(@Param("count") Integer count,@Param("cart_seq") Integer cart_seq);
    Integer getChangedPrice(@Param("discount") Integer discount,@Param("price") Integer price);
    List<String> getDeliInfo(@Param("id") String id);
    String getDefaultAddress(String id);
    String getAdditionalAddress1(String id);
    String getAdditionalAddress2(String id);
    String  getName(String id);
    String  getPhone(String id);
    List<CouponDTO> checkCouponPr();
    void updCoupon(@Param("cp_seq")Integer cp_seq);
    void updCartStatus(@Param("id") String id);
    void chgPdCount(@Param("pd_seq")  Integer pd_seq,@Param("count") Integer count);
    void chgOptionCount(Map<String,Object>map);
    Integer getPdSeq(@Param("cart_seq") Integer cart_seq);
    void updOptionStock(@Param("option_seq") Integer option_seq,@Param("pd_seq") Integer pd_seq);
    Integer likeYN(@Param("id") String id,@Param("pd_seq") Integer pd_seq);
    void insertLike(@Param("id") String id,@Param("pd_seq") Integer pd_seq);
    void cancleLike(@Param("id") String id,@Param("pd_seq") Integer pd_seq);
    Integer getCategorySeq(@Param("category1") String category1,@Param("category2") String category2);
    void insertPd(Map<String,Object>param);
    Integer getPdCurrVal();
    void insertOption(Map<String,Object>map1);
    Integer isOptExist(@Param("pd_seq") Integer pd_seq);
    List<OptionDTO> getOptByGroup(@Param("pd_seq") Integer pd_seq);
    void deletePd(@Param("pd_seq") Integer pd_seq);
    ProductDTO getPdInfo(@Param("pd_seq")Integer pd_seq);
    CategoryDTO getPdCategory(@Param("category_seq") Integer category);
    CategoryDTO getPdSubCategory(Integer category);
    void updProduct(Map<String,Object>param);
    void updPdImg(@Param("pd_seq") Integer pd_seq,@Param("img") String sysname);
    void updOptionStatus(@Param("option_seq") Integer option_seq);
    Integer getNextOptSeq();
    void insertNewOptions(Map<String,Object>insertParam);
    void updOptions(Map<String, Object> updParam);
    List<ProductDTO> getProductsByKeyword(@Param("keyword") String keyword);
    List<CartDTO> cartInfo(@Param("cart_seq") Integer cart_seq);
    Integer getPdCount(@Param("cart_seq") Integer cart_seq);
    String getOption(@Param("cart_seq")  Integer cart_seq);
    Integer getId(@Param("id")  String id);
    void insertBuyPd(@Param("id")  String id,@Param("sum") Integer sum,@Param("price")  Integer price);
    void updateBuyPd(@Param("id")  String id,@Param("sum") Integer sum,@Param("price")  Integer price);
    Integer getSum(@Param("id")  String id);
    Integer getPrice(@Param("id")  String id);

    void updCartFlag(@Param("cart_seq") Integer cart_seq);
    void updFlagToY(@Param("cart_seq") Integer cart_seq);
    List<CartDTO> getCart(@Param("id") String id);
    List<DeliDTO> getDeliveryInfo(@Param("id") String id);
    List<DeliDTO> deliveryInfo(@Param("id") String id);
    void insertDeli(Map<String,Object>param);
    DeliDTO getSeqDeli(@Param("seq") Integer seq);
    Integer getCurrval();
    void updDeliStatus(@Param("seq") Integer seq);
    void updDeli(Map<String,Object>param);
    void deleteDeli(@Param("seq") Integer seq);
    void chgDefaultAddr(@Param("seq") Integer seq);
    void updStatus(@Param("seq") Integer seq);
    DeliDTO getDefaultAddr();
    Integer currPaySeq();
    void insertPayProduct(Map<String,Object>parameter);
    void insertPayPd(@Param("pd_seq") Integer pd_seq, @Param("pay_seq")Integer pay_seq);
    Integer getDefaultAdr();
    List<Map<String,Object>> getHistory(@Param("id") String id,@Param("start") Integer start,@Param("end")Integer end);
    DeliDTO getDeliInfoBySeq(@Param("deli_seq") Integer deli_seq);
    String getOptCategory(@Param("pd_seq") Integer pd_seq, @Param("optName") String optName);
    Integer countPost();
    Integer salesPdCount();
    Timestamp getPayDate(@Param("pay_seq") Integer pay_seq);
    void insertSales(Map<String,Object>salesParam);
    List<SalesDTO> getSalesList(@Param("start") Integer start, @Param("end") Integer end);
    List<CourierDTO> getCourierInfo();
    void insert(@Param("code") Integer code, @Param("name") String name);
    Integer getCourierCode(@Param("name") String name);
    void deliveryStatus(@Param("code") Integer code,@Param("sales_seq") Integer sales_seq);
    PayInfoDTO getPayInfo(@Param("pay_seq") Integer pay_seq);

}