package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.*;
import com.example.Spring_Project.service.MemberService;
import com.example.Spring_Project.service.PayService;
import com.example.Spring_Project.service.ProductService;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.querydsl.binding.QuerydslPredicate;
import org.springframework.data.relational.core.sql.In;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.*;

@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private HttpSession httpSession;

    @Autowired
    private MemberService memberService;

    @Autowired
    private PayService payService;

    //전체 상품
    @RequestMapping("/list")
    public String productList(Model model) throws Exception {
        List<ProductDTO> product = productService.getProducts();
        model.addAttribute("product", product);
        return "/product/productList";
    }

    //상품 디테일
    @RequestMapping("/detail")
    public String detail(Model model, Integer pd_seq) throws Exception {
        ProductDTO productDTO = productService.getProductDetail(pd_seq); //상품 상세 정보
        List<OptionDTO> optionDTO = productService.getOptions(pd_seq); //상품 옵션 정보
        List<String> category = productService.getCategory(pd_seq);//옵션 카테고리

        Map<String, List<OptionListDTO>> optionList = new HashMap();
        System.out.println("optionDTO.size() = " + optionDTO.size());
        if (optionDTO != null || optionDTO.size() != 0) {
            for (Integer i = 0; i < category.size(); i++) {
                String cg = category.get(i);
                List<OptionListDTO> getOptionByGroup = productService.getOptionByGroup(category.get(i), pd_seq);  //카테고리별 optionList
                optionList.put(cg, getOptionByGroup);
            }
            model.addAttribute("productDTO", productDTO);
            model.addAttribute("optionDTO", optionDTO);
            model.addAttribute("category", category);
            model.addAttribute("optionList", optionList);
        }
        return "/product/detail";
    }

    //여성 카테고리
    @RequestMapping("/women")
    public String wProduct(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getWProduct();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/women";
    }

    @RequestMapping("/women/outer")
    public String wOuter(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getWOuter();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/women/outer";
    }

    @RequestMapping("/women/top")
    public String wTop(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getWTop();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/women/top";
    }

    @RequestMapping("/women/pants")
    public String wPants(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getWPants();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/women/pants";
    }

    @RequestMapping("/women/accessories")
    public String wAccessories(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getWAccessories();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/women/accessories";
    }

    //남성 카테고리
    @RequestMapping("/men")
    public String mProduct(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getMProduct();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/men";
    }

    @RequestMapping("/men/outer")
    public String mOuter(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getMOuter();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/men/outer";
    }

    @RequestMapping("/men/top")
    public String mTop(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getMTop();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/men/top";
    }

    @RequestMapping("/men/pants")
    public String mPants(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getMPants();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/men/pants";
    }

    @RequestMapping("/men/accessories")
    public String mAccessories(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getMAccessories();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/men/accessories";
    }

    //신상품 카테고리
    @RequestMapping("/new")
    public String newProduct(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getNewProduct();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/new";
    }

    @RequestMapping("/new/outer")
    public String newOuter(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getNewOuter();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/new/outer";
    }

    @RequestMapping("/new/top")
    public String newTop(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getNewTop();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/new/pants";
    }

    @RequestMapping("/new/pants")
    public String newPants(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getNewPants();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/new/top";
    }

    @RequestMapping("/new/accessories")
    public String newAccessories(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getNewAccessories();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/new/accessories";
    }

    //장바구니에 상품 추가
    @ResponseBody
    @PostMapping("/addProduct")
    public String addProduct(@RequestParam Map<String, Object> map) throws Exception {
//        "count":cnt,
//        "id":id,
//        "pd_seq":pd_seq,
//        "optionList":integerArray2

        Integer count = Integer.parseInt(map.get("count").toString());
        String id = map.get("id").toString();
        Integer pd_seq = Integer.parseInt(map.get("pd_seq").toString());

        if (map.get("optionList") != null) {
            System.out.println("length : " + map.get("optionList").toString().split(",").length);
            String[] test = map.get("optionList").toString().split(",");
            System.out.println("test 배열 길이 : " + map.get("optionList").toString().split(",").length);
            for (Integer i = 0; i < test.length; i++) {
                test[i] = map.get("optionList").toString().split(",")[i];
            }

            List<String> list = new ArrayList<>();
            Map<String, List<String>> optionList = new HashMap<>();
            for (Integer i = 0; i < test.length; i++) {
                Map<String, Object> options = new HashMap<>();
                String option_name = test[i].substring(0, test[i].indexOf("("));
                System.out.println("옵션 이름 : " + option_name);
                list.add(option_name);
                optionList.put("name", list);
            }

            //장바구니 insert 옵션 있을때
            productService.insertCart(id, count, pd_seq, optionList.toString());
        } else if (map.get("optionList") == null) {
            //옵션 없을때
            productService.insertCartWtOption(id, count, pd_seq);
        }

        return "success";
    }

    //장바구니로 이동
    @PostMapping("/cart")
    public String toCart(Model model, @RequestParam String id) throws Exception {

        List<Map<String, Object>> optionList = new ArrayList<>();
        JsonParser jsonParser = new JsonParser();
        JsonArray jsonArray = new JsonArray();
        JsonObject jsonObject = new JsonObject();
        List<CartDTO> cartInfo = productService.getCartInfo(id);
        List<String> list = new ArrayList<>();
        List<Map<String, Object>> cart = new ArrayList<>();
        Integer totalPrice = 0;  //상품 총 합계
        Integer totalSum = 0;  //상품 총 개수
        for (Integer i = 0; i < cartInfo.size(); i++) {
            if (cartInfo.get(i).getOptions() != null) {  //상품 옵션 있을때
                Object object = jsonParser.parse(cartInfo.get(i).getOptions());
                jsonObject = (JsonObject) object;
                jsonArray = (JsonArray) jsonObject.get("name");
                list = productService.getOptionCategory(cartInfo.get(i).getCart_seq());
                List<Map<String, Object>> optionMap = new ArrayList<>();
                for (Integer k = 0; k < list.size(); k++) {
                    Map<String, Object> map = new HashMap<>();
                    String category = list.get(k);
                    String option = String.valueOf(jsonArray.get(k)).replace("\"", "");
                    map.put(category, option);
                    optionMap.add(map);
                }
                Map<String, Object> item = new HashMap<>();
                item.put("id", cartInfo.get(i).getId());
                item.put("count", cartInfo.get(i).getCount());
                item.put("cart_seq", cartInfo.get(i).getCart_seq());
                item.put("status", cartInfo.get(i).getStatus());
                item.put("pd_seq", cartInfo.get(i).getPd_seq());
                item.put("name", cartInfo.get(i).getName());
                item.put("description", cartInfo.get(i).getDescription());
                item.put("price", cartInfo.get(i).getPrice());
                item.put("stock", cartInfo.get(i).getStock());
                item.put("img", cartInfo.get(i).getImg());
                item.put("category", cartInfo.get(i).getCategory());
                item.put("option", optionMap);
                item.put("totalPrice", cartInfo.get(i).getPrice() * cartInfo.get(i).getCount());
                cart.add(item);

                //돌면서 상품 개수, 상품 가격 가져오고 더하기
                Integer pdCount = cartInfo.get(i).getCount();
                Integer pdProduct_seq = cartInfo.get(i).getPd_seq();
                Integer pdPrice = productService.getPdPrice(pdProduct_seq);

                totalPrice += pdPrice * pdCount;
                totalSum += pdCount;
            } else {
                list = productService.getOptionCategory(cartInfo.get(i).getCart_seq());
                Map<String, Object> item = new HashMap<>();
                item.put("id", cartInfo.get(i).getId());
                item.put("count", cartInfo.get(i).getCount());
                item.put("cart_seq", cartInfo.get(i).getCart_seq());
                item.put("status", cartInfo.get(i).getStatus());
                item.put("pd_seq", cartInfo.get(i).getPd_seq());
                item.put("name", cartInfo.get(i).getName());
                item.put("description", cartInfo.get(i).getDescription());
                item.put("price", cartInfo.get(i).getPrice());
                item.put("stock", cartInfo.get(i).getStock());
                item.put("img", cartInfo.get(i).getImg());
                item.put("category", cartInfo.get(i).getCategory());
                item.put("totalPrice", cartInfo.get(i).getPrice() * cartInfo.get(i).getCount());
                cart.add(item);

                //돌면서 상품 개수, 상품 가격 가져오고 더하기
                Integer pdCount = cartInfo.get(i).getCount();
                Integer pdProduct_seq = cartInfo.get(i).getPd_seq();
                Integer pdPrice = productService.getPdPrice(pdProduct_seq);

                totalPrice += pdPrice * pdCount;
                totalSum += pdCount;
            }
        }

        //m_seq 가져오기
        Integer m_seq = productService.getMemberSeq(id);
        //쿠폰 리스트 가져오기
        List<CouponDTO> couponDTOList = productService.getCoupon(m_seq);
        model.addAttribute("cart", cart);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("totalSum", totalSum);
        model.addAttribute("couponDTOList", couponDTOList);
        return "/product/cart";
    }


    @ResponseBody
    @RequestMapping("/cart/delete")
    public String deleteItem(Integer cart_seq) throws Exception {
        productService.deleteItem(cart_seq);
        return "success";
    }

    @ResponseBody
    @RequestMapping("/count")
    public Integer getCount(Integer cart_seq) throws Exception {
        Map<String, Object> cartOption = productService.getCartOption(cart_seq);
        int stock = 0;
        if (cartOption.size() != 1) {
            //pd_seq
            Integer pd_seq = Integer.parseInt(cartOption.get("PD_SEQ").toString());
            //옵션
            JsonParser jsonParser = new JsonParser();
            JsonObject jsonObject = (JsonObject) jsonParser.parse((String) cartOption.get("OPTIONS"));

            JsonArray jsonArray = (JsonArray) jsonObject.get("name");

            int[] list = new int[jsonArray.size()];

            for (int i = 0; i < jsonArray.size(); i++) {
                int index = jsonArray.get(i).toString().indexOf("\"");
                String option = jsonArray.get(i).toString().substring(index + 1, jsonArray.get(i).toString().length() - 1);
                stock = productService.getOptionCount(pd_seq, option);
                list[i] = stock;
            }
            stock = Arrays.stream(list).min().getAsInt();
        } else if (cartOption.size() == 1) {
            Integer pd_seq = productService.getPdSeq(cart_seq);// pd_seq 가져오기
            stock = productService.getPdStock(pd_seq);
        }
        return stock;
    }

    @ResponseBody
    @RequestMapping("/discountedPrice")  //쿠폰 먹여서 다시 계산
    public Integer changePrice(@RequestParam Map<String, Object> map) throws Exception {
        Integer discount = Integer.parseInt(map.get("discount").toString());
        Integer originalPrice = Integer.parseInt(map.get("price").toString());
        Integer price = productService.getChangedPrice(discount, originalPrice);
        return price;
    }

    @ResponseBody
    @RequestMapping("/updCount")
    public String updCount(Integer count, Integer cart_seq) throws Exception {
        productService.updateCount(count, cart_seq);
        return "success";
    }

    @RequestMapping("/payInfo")
    public String toPayInfo(Model model, String data, Integer price) throws Exception { //data : id
        List<Map<String, Object>> optionList = new ArrayList<>();
        JsonParser jsonParser = new JsonParser();
        JsonArray jsonArray = new JsonArray();
        JsonObject jsonObject = new JsonObject();
        List<String> list = new ArrayList<>();
        List<CartDTO> cartInfo = productService.getCartInfo(data);
        List<Map<String, Object>> cart = new ArrayList<>();
        Integer totalPrice = 0;  //상품 총 합계
        Integer totalSum = 0;  //상품 총 개수
        for (Integer i = 0; i < cartInfo.size(); i++) {
            if (cartInfo.get(i).getOptions() != null) {
                Object object = jsonParser.parse(cartInfo.get(i).getOptions());
                jsonObject = (JsonObject) object;
                jsonArray = (JsonArray) jsonObject.get("name");
                list = productService.getOptionCategory(cartInfo.get(i).getCart_seq());
                List<Map<String, Object>> optionMap = new ArrayList<>();
                for (Integer k = 0; k < list.size(); k++) {
                    Map<String, Object> map = new HashMap<>();
                    String category = list.get(k);
                    String option = String.valueOf(jsonArray.get(k)).replace("\"", "");
                    map.put(category, option);
                    optionMap.add(map);
                }
                Map<String, Object> item = new HashMap<>();
                item.put("id", cartInfo.get(i).getId());
                item.put("count", cartInfo.get(i).getCount());
                item.put("cart_seq", cartInfo.get(i).getCart_seq());
                item.put("status", cartInfo.get(i).getStatus());
                item.put("pd_seq", cartInfo.get(i).getPd_seq());
                item.put("name", cartInfo.get(i).getName());
                item.put("description", cartInfo.get(i).getDescription());
                item.put("price", cartInfo.get(i).getPrice());
                item.put("stock", cartInfo.get(i).getStock());
                item.put("img", cartInfo.get(i).getImg());
                item.put("category", cartInfo.get(i).getCategory());
                item.put("option", optionMap);
                item.put("totalPrice", cartInfo.get(i).getPrice() * cartInfo.get(i).getCount());
                cart.add(item);

                //돌면서 상품 개수, 상품 가격 가져오고 더하기
                Integer pdCount = cartInfo.get(i).getCount();
                Integer pdProduct_seq = cartInfo.get(i).getPd_seq();
                Integer pdPrice = productService.getPdPrice(pdProduct_seq);

                totalPrice += pdPrice * pdCount;
                totalSum += pdCount;
            } else {
                list = productService.getOptionCategory(cartInfo.get(i).getCart_seq());
                Map<String, Object> item = new HashMap<>();
                item.put("id", cartInfo.get(i).getId());
                item.put("count", cartInfo.get(i).getCount());
                item.put("cart_seq", cartInfo.get(i).getCart_seq());
                item.put("status", cartInfo.get(i).getStatus());
                item.put("pd_seq", cartInfo.get(i).getPd_seq());
                item.put("name", cartInfo.get(i).getName());
                item.put("description", cartInfo.get(i).getDescription());
                item.put("price", cartInfo.get(i).getPrice());
                item.put("stock", cartInfo.get(i).getStock());
                item.put("img", cartInfo.get(i).getImg());
                item.put("category", cartInfo.get(i).getCategory());
                item.put("totalPrice", cartInfo.get(i).getPrice() * cartInfo.get(i).getCount());
                cart.add(item);

                //돌면서 상품 개수, 상품 가격 가져오고 더하기
                Integer pdCount = cartInfo.get(i).getCount();
                Integer pdProduct_seq = cartInfo.get(i).getPd_seq();
                Integer pdPrice = productService.getPdPrice(pdProduct_seq);

                totalPrice += pdPrice * pdCount;
                totalSum += pdCount;
            }
        }
        Map<String, Object> deliAddress = new HashMap<>();
        String name = productService.getName(data);//이름
        String phone = productService.getPhone(data);//폰
        phone = phone.substring(0, 3) + "-" + phone.substring(3, 7) + "-" + phone.substring(7, 11);
        String defaultAddress = productService.getDefaultAddress(data);
        deliAddress.put("name", name);
        deliAddress.put("phone", phone);
        deliAddress.put("defaultAddress", defaultAddress);

        MemberDTO memberDTO = memberService.getMemInfo(data);

        model.addAttribute("cart", cart);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("totalSum", totalSum);
        model.addAttribute("deliAddress", deliAddress);
        model.addAttribute("price", price); //실제 총 합계
        model.addAttribute("memberDTO", memberDTO); //회원 정보
        return "/product/payInfo";
    }

    @ResponseBody
    @RequestMapping("/getAdditionalAddr")
    public String getAdditionalAddr(String id) throws Exception {
        String additionalAddress1 = productService.getAdditionalAddress1(id);
        return additionalAddress1;
    }

    @ResponseBody
    @RequestMapping("/getAdditionalAddr2")
    public String getAdditionalAddr2(String id) throws Exception {
        String additionalAddress2 = productService.getAdditionalAddress2(id);
        return additionalAddress2;
    }

    @ResponseBody
    @RequestMapping("/getDefaultAddr")
    public String getDefaultAddr(String id) throws Exception {
        String defaultAddress = productService.getDefaultAddress(id);
        return defaultAddress;
    }

    //선택삭제 테스트
    @ResponseBody
    @RequestMapping("/cart/delCart")
    public String deleteItem(@RequestParam(value = "deleteCartSeq[]") List<Integer> deleteCartSeq) throws
            Exception {
        System.out.println("deleteCartSeq = " + deleteCartSeq);
        for (Integer i : deleteCartSeq) {
            productService.deleteItem(i);
        }
        return "success";
    }

    @RequestMapping("/paymentDetails")
    public String paymentDetails(Model model, String id, Integer price, String carts) throws Exception {

        //결제 테이블에 인서트
        Map<String, Object> param = new HashMap<>();
        param.put("id", id);
        param.put("price", price);
        payService.insertPayInfo(param);

        JsonParser jsonParser = new JsonParser();
        JsonArray jsonArray = new JsonArray();
        JsonObject jsonObject = new JsonObject();
        List<String> list = new ArrayList<>();
        List<CartDTO> cartInfo = productService.getCartInfo(id);
        List<Map<String, Object>> cart = new ArrayList<>();
        Integer totalPrice = 0;  //상품 총 합계
        Integer totalSum = 0;  //상품 총 개수
        for (Integer i = 0; i < cartInfo.size(); i++) {
            if (cartInfo.get(i).getOptions() != null) {
                Object object = jsonParser.parse(cartInfo.get(i).getOptions());
                jsonObject = (JsonObject) object;
                jsonArray = (JsonArray) jsonObject.get("name");
                list = productService.getOptionCategory(cartInfo.get(i).getCart_seq());
                List<Map<String, Object>> optionMap = new ArrayList<>();
                for (Integer k = 0; k < list.size(); k++) {
                    Map<String, Object> map = new HashMap<>();
                    String category = list.get(k);
                    String option = String.valueOf(jsonArray.get(k)).replace("\"", "");
                    map.put(category, option);
                    optionMap.add(map);
                }
                Map<String, Object> item = new HashMap<>();
                item.put("id", cartInfo.get(i).getId());
                item.put("count", cartInfo.get(i).getCount());
                item.put("cart_seq", cartInfo.get(i).getCart_seq());
                item.put("status", cartInfo.get(i).getStatus());
                item.put("pd_seq", cartInfo.get(i).getPd_seq());
                item.put("name", cartInfo.get(i).getName());
                item.put("description", cartInfo.get(i).getDescription());
                item.put("price", cartInfo.get(i).getPrice());
                item.put("stock", cartInfo.get(i).getStock());
                item.put("img", cartInfo.get(i).getImg());
                item.put("category", cartInfo.get(i).getCategory());
                item.put("option", optionMap);
                item.put("totalPrice", cartInfo.get(i).getPrice() * cartInfo.get(i).getCount());
                cart.add(item);

                //돌면서 상품 개수, 상품 가격 가져오고 더하기
                Integer pdCount = cartInfo.get(i).getCount();
                Integer pdProduct_seq = cartInfo.get(i).getPd_seq();
                Integer pdPrice = productService.getPdPrice(pdProduct_seq);

                totalPrice += pdPrice * pdCount;
                totalSum += pdCount;
            } else if (cartInfo.get(i).getOptions() == null) {
                list = productService.getOptionCategory(cartInfo.get(i).getCart_seq());
                Map<String, Object> item = new HashMap<>();
                item.put("id", cartInfo.get(i).getId());
                item.put("count", cartInfo.get(i).getCount());
                item.put("cart_seq", cartInfo.get(i).getCart_seq());
                item.put("status", cartInfo.get(i).getStatus());
                item.put("pd_seq", cartInfo.get(i).getPd_seq());
                item.put("name", cartInfo.get(i).getName());
                item.put("description", cartInfo.get(i).getDescription());
                item.put("price", cartInfo.get(i).getPrice());
                item.put("stock", cartInfo.get(i).getStock());
                item.put("img", cartInfo.get(i).getImg());
                item.put("category", cartInfo.get(i).getCategory());
                item.put("totalPrice", cartInfo.get(i).getPrice() * cartInfo.get(i).getCount());
                cart.add(item);

                //돌면서 상품 개수, 상품 가격 가져오고 더하기
                Integer pdCount = cartInfo.get(i).getCount();
                Integer pdProduct_seq = cartInfo.get(i).getPd_seq();
                Integer pdPrice = productService.getPdPrice(pdProduct_seq);

                totalPrice += pdPrice * pdCount;
                totalSum += pdCount;
            }
        }
        //상품 수량, 옵션 수량 변경
        for (int i = 0; i < cartInfo.size(); i++) {
            Integer pd_seq = cartInfo.get(i).getPd_seq();
            Integer count = cartInfo.get(i).getCount();
            if (cartInfo.get(i).getOptions() != null) {
                Object object = jsonParser.parse(cartInfo.get(i).getOptions());
                JsonObject jsonObject1 = (JsonObject) object;
                JsonArray jsonArray1 = (JsonArray) jsonObject1.get("name");
                //상품 옵션 수량 변경
                //상품 수량 변경
                productService.chgPdCount(pd_seq, count);
                //상품 수량이 0일때 status n으로
                Integer pdStock = productService.getPdStock(pd_seq);
                if (pdStock <= 0) {
                    productService.updatePdStatus(pd_seq);
                }
                for (int k = 0; k < jsonArray1.size(); k++) {
                    System.out.println("jsonArray1.size() = " + jsonArray1.size());
                    String option = String.valueOf(jsonArray1.get(k)).replace("\"", "");
                    System.out.println("option = " + option);
                    Map<String, Object> map = new HashMap<>();
                    map.put("pd_seq", pd_seq);
                    map.put("option", option);
                    map.put("count", count);
                    //상품 수량이 0일때 status n으로
                    OptionDTO optionStock = productService.getOptionStock(map);
                    System.out.println("mapseq= " + map.get("pd_seq"));
                    if (optionStock.getStock() <= 0) {
                        //옵션 있고 옵션 수량이 0일때
                        productService.updateOptionStatus(optionStock.getOption_seq());
                        productService.chgOptionCount(map);
                        //재고가 음수일떄 0으로 update해주기
                        productService.updOptionStock(optionStock.getOption_seq(), optionStock.getPd_seq());
                    } else if (optionStock.getStock() > 0) {
                        //옵션 있고 옵션 수량 0이 아닐때
                        productService.chgOptionCount(map);
                    }
                }
            } else if (cartInfo.get(i).getOptions() == null) {
                //옵션 없을때
                //상품 수량 변경
                productService.chgPdCount(pd_seq, count);
                //상품 수량이 0일때 status n으로
                Integer pdStock = productService.getPdStock(pd_seq);
                if (pdStock <= 0) {
                    productService.updatePdStatus(pd_seq);
                }
            }
        }

        //장바구니 비우기
        productService.updCartStatus(id);
        model.addAttribute("cart", cart);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("totalSum", totalSum);
        return "/product/paymentDetail";
    }

    @ResponseBody
    @RequestMapping("/likeYN") //좋아요 눌렀는지 여부
    public Integer likeYN(String id, Integer pd_seq) throws Exception {
        System.out.println("id = " + id);
        System.out.println("pd_seq = " + pd_seq);
        Integer yn = productService.likeYN(id, pd_seq);
        return yn;
    }

    @ResponseBody
    @RequestMapping("/like") //좋아요 테이블 인서트
    public String like(String id, Integer pd_seq) throws Exception {
        System.out.println("id = " + id);
        System.out.println("pd_seq = " + pd_seq);
        productService.insertLike(id, pd_seq);
        return "success";
    }

    @ResponseBody
    @RequestMapping("/cancleLike") //좋아요 취소
    public String cancleLike(String id, Integer pd_seq) throws Exception {
        System.out.println("id = " + id);
        System.out.println("pd_seq = " + pd_seq);
        productService.cancleLike(id, pd_seq); //좋아요 취소 상태 n
        return "success";
    }

    @ResponseBody
    @PostMapping("/addPd")  //관리자 상품 추가
    public String addPd(@RequestParam Map<String, Object> map, HttpServletRequest request,
                        @RequestPart(value = "img", required = false) MultipartFile img) throws Exception {
        System.out.println("map = " + map);
        String path = "/resources/img/products/";

        String savePath = request.getServletContext().getRealPath(path); //webapp 폴더
        File fileSavePath = new File(savePath);

        if (!fileSavePath.exists()) {
            fileSavePath.mkdir();
        }

        String oriname = img.getOriginalFilename();
        String sysname = UUID.randomUUID() + "_" + oriname;

        img.transferTo(new File(fileSavePath + "/" + sysname));

        // 상품 인서트
        String name = map.get("name").toString();
        String description = map.get("description").toString();
        Integer stock = Integer.parseInt(map.get("stock").toString());
        Integer price = Integer.parseInt(map.get("price").toString());
        String category1 = map.get("category1").toString();
        String category2 = map.get("category2").toString();
        //상품 인서트할때 category_seq 가져오기
        Integer category_seq = productService.getCategorySeq(category1, category2);

        Map<String, Object> param = new HashMap<>();
        param.put("name", name);
        param.put("description", description);
        param.put("price", price);
        param.put("stock", stock);
        param.put("img", sysname);
        param.put("category", category_seq);

        productService.insertPd(param);

        System.out.println(map.get("option").toString().length());
        //option json으로 파싱
        JsonParser jsonParser = new JsonParser();
        Object object = jsonParser.parse((String) map.get("option"));
        JsonArray optionArray = (JsonArray) object;

        //옵션이 없을때
        if (optionArray.size() == 0) {
            System.out.println("옵션 없음");
        } else { //옵션이 있을때
            for (int i = 0; i < optionArray.size(); i++) {
                System.out.println("옵션 있을때 사이즈 : " + optionArray.size());
                Object object1 = jsonParser.parse(optionArray.get(i).toString());
                System.out.println("object1 : " + object1);
                JsonObject jsonObject = (JsonObject) object1;
                String category = jsonObject.get("category").toString().replace("\"", "");
                String optionName = jsonObject.get("name").toString().replace("\"", "");
                Integer optionStock = Integer.parseInt(jsonObject.get("stock").toString().replace("\"", ""));

                Integer currVal = productService.getPdCurrVal(); // 상품  currval 가져오기

                Map<String, Object> map1 = new HashMap<>();
                map1.put("category", category);
                map1.put("name", optionName);
                map1.put("stock", optionStock);
                map1.put("pd_seq", currVal);
                System.out.println("map1 : " + map1);
                productService.insertOption(map1);///옵션 인서트
            }
        }
        return "success";
    }


    @ResponseBody
    @RequestMapping("/deletePd")   // 등록한 상품 삭제
    public String deletePd(Integer pd_seq) throws Exception {
        productService.deletePd(pd_seq);
        return "success";
    }

    @ResponseBody
    @RequestMapping("/updProduct") //관리자 상품 수정
    public String updProduct(@RequestParam Map<String, Object> map, HttpServletRequest request,
                             @RequestPart(value = "img", required = false) MultipartFile img) throws Exception {
        //상품 업데이트
        String name = map.get("name").toString();
        String description = map.get("description").toString();
        Integer stock = Integer.parseInt(map.get("stock").toString());
        Integer price = Integer.parseInt(map.get("price").toString());
        String category1 = map.get("category1").toString();
        String category2 = map.get("category2").toString();
        Integer pd_seq = Integer.parseInt(map.get("pd_seq").toString());

        System.out.println("map.get(\"img\").toString() : " + map.get("img").toString());
        Map<String, Object> param = new HashMap<>();
        if (map.get("img").toString().replace("\"", "").length() != 0) { //이미지 변경 될때

            System.out.println("map = " + map);
            String path = "/resources/img/products/";

            String savePath = request.getServletContext().getRealPath(path); //webapp 폴더
            File fileSavePath = new File(savePath);

            if (!fileSavePath.exists()) {
                fileSavePath.mkdir();
            }

            String oriname = img.getOriginalFilename();
            String sysname = UUID.randomUUID() + "_" + oriname;

            img.transferTo(new File(fileSavePath + "/" + sysname));

            System.out.println("sysname : " + sysname);
            productService.updPdImg(pd_seq, sysname);
        }

        //상품 업데이트할때 category_seq 가져오기
        Integer category_seq = productService.getCategorySeq(category1, category2);
        param.put("name", name);
        param.put("description", description);
        param.put("stock", stock);
        param.put("price", price);
        param.put("category_seq", category_seq);
        param.put("pd_seq", pd_seq);
        productService.updProduct(param);//상품 정보 update

        /*옵션 업데이트*/
        //deleteOpt json으로 파싱
        JsonParser jsonParser = new JsonParser();
        Object object = jsonParser.parse((String) map.get("deleteOpt"));
        JsonArray deleteOpt = (JsonArray) object;
        System.out.println("deleteOpt : " + deleteOpt);
        System.out.println("deleteOpt.size() : " + deleteOpt.size());
        //돌면서 삭제
        if (deleteOpt.size() != 0) {
            for (int i = 0; i < deleteOpt.size(); i++) {
                Object object1 = jsonParser.parse(String.valueOf(deleteOpt.get(i)));
                JsonObject jsonObject = (JsonObject) object1;
                Integer option_seq = Integer.parseInt(String.valueOf(jsonObject.get("key")));
                productService.updOptionStatus(option_seq); //옵션 삭제
            }
        }

        //updOpt json으로 파싱
        Object object1 = jsonParser.parse((String) map.get("updOpt"));
        JsonArray updOpt = (JsonArray) object1;
        System.out.println("updOpt : " + updOpt);
        System.out.println("updOpt.size() : " + updOpt.size());
        //돌면서 수정
        if (updOpt.size() != 0) {
            for (int i = 0; i < updOpt.size(); i++) {
                Object object2 = jsonParser.parse(String.valueOf(updOpt.get(i)));
                JsonObject jsonObject = (JsonObject) object2;
                Integer option_seq = Integer.parseInt(String.valueOf(jsonObject.get("stock")).replace("\"", ""));
                String category = String.valueOf(jsonObject.get("category")).replace("\"", "");
                String option_name = String.valueOf(jsonObject.get("name")).replace("\"", "");
                Integer option_stock = Integer.parseInt(String.valueOf(jsonObject.get("stock")).replace("\"", ""));
                Map<String, Object> updParam = new HashMap<>();
                updParam.put("category", category);
                updParam.put("option_name", option_name);
                updParam.put("option_stock", option_stock);
                updParam.put("option_seq", option_seq);
                productService.updOptions(updParam); //새로운 옵션 추가
            }
        }

        //newOpt json으로 파싱
        Object object2 = jsonParser.parse((String) map.get("newOpt"));
        JsonArray newOpt = (JsonArray) object2;
        System.out.println("newOpt : " + newOpt);
        System.out.println(" newOpt.size() : " + newOpt.size());
        //돌면서 추가
        if (newOpt.size() != 0) {
            for (int i = 0; i < newOpt.size(); i++) {
                Object object3 = jsonParser.parse(String.valueOf(newOpt.get(i)));
                JsonObject jsonObject = (JsonObject) object3;
                Integer option_seq = productService.getNextOptSeq(); //option_seq nextval가져오기
                String category = String.valueOf(jsonObject.get("category")).replace("\"", "");
                String option_name = String.valueOf(jsonObject.get("name")).replace("\"", "");
                Integer option_stock = Integer.parseInt(String.valueOf(jsonObject.get("stock")).replace("\"", ""));
                Map<String, Object> insertParam = new HashMap<>();
                insertParam.put("pd_seq", pd_seq);
                insertParam.put("category", category);
                insertParam.put("option_name", option_name);
                insertParam.put("option_stock", option_stock);
                insertParam.put("option_seq", option_seq);
                productService.insertNewOptions(insertParam); //새로운 옵션 추가
            }
        }
        return "success";
    }

    //상품 검색
    @RequestMapping("/searchPd")
    public String searchPd(String keyword, Model model) throws Exception {
        List<ProductDTO> product = productService.getProductsByKeyword(keyword);
        model.addAttribute("product", product);
        return "/product/productList";
    }

}
