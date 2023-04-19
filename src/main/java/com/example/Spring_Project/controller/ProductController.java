package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.CartDTO;
import com.example.Spring_Project.dto.OptionDTO;
import com.example.Spring_Project.dto.OptionListDTO;
import com.example.Spring_Project.dto.ProductDTO;
import com.example.Spring_Project.service.ProductService;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private HttpSession httpSession;

    //전체 상품
    @RequestMapping("/list")
    public String productList(Model model) throws Exception {
        List<ProductDTO> product = productService.getProducts();
        model.addAttribute("product", product);
        return "/member/productList";
    }

    //상품 디테일
    @RequestMapping("/detail")
    public String detail(Model model, Integer pd_seq) throws Exception {
        ProductDTO productDTO = productService.getProductDetail(pd_seq); //상품 상세 정보
        List<OptionDTO> optionDTO = productService.getOptions(pd_seq); //상품 옵션 정보
//      List<OptionDTO>optionByCategory = productService.optionByCategory(pd_seq); //상품 카테고리별 옵션 정보
        List<String> category = productService.getCategory(pd_seq);//옵션 카테고리

        Map<String, List<OptionListDTO>> optionList = new HashMap();
        for (Integer i = 0; i < category.size(); i++) {
            String cg = category.get(i);
            List<OptionListDTO> getOptionByGroup = productService.getOptionByGroup(category.get(i), pd_seq);  //카테고리별 optionList
            optionList.put(cg, getOptionByGroup);
        }
        model.addAttribute("productDTO", productDTO);
        model.addAttribute("optionDTO", optionDTO);
        model.addAttribute("category", category);
        model.addAttribute("optionList", optionList);
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
        System.out.println("map : " + map);
        System.out.println("optionList : " + map.get("optionList").toString());
        Integer count = Integer.parseInt(map.get("count").toString());
        String id = map.get("id").toString();
        Integer pd_seq = Integer.parseInt(map.get("pd_seq").toString());

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
        System.out.println("optionList : " + optionList);

        //장바구니 insert
        productService.insertCart(id, count, pd_seq, optionList.toString());

//        for (Integer i = 0; i < optionList.size(); i++) { //옵션 수량 0일때
//            option_seq=productService.getOptionStock(pd_seq, optionList.get(i));
//            if(option_seq !=0){
//                productService.updateOptionStatus(option_seq);
//            }
//        }
//        product_seq=productService.getPdStock(pd_seq);
//        if (product_seq != 0) { //상품 수량 0일때 상태 n으로
//            productService.updatePdStatus(product_seq);
//        }
//        else{
//            productService.insertCart(map); //장바구니 table insert
//            for (Integer i = 0; i < optionList.size(); i++) {
//                productService.minusOption(pd_seq, optionList.get(i));
//            }//옵션들 -1
//            productService.minusPd(pd_seq);//총 수량 -1
//        }
        return "success";
    }

    //장바구니로 이동
    @PostMapping("/cart")
    public String toCart(Model model, @RequestParam String id) throws Exception {
        List<Map<String, Object>> optionList = new ArrayList<>();
        System.out.println("id : " + id);
        JsonParser jsonParser = new JsonParser();
        JsonArray jsonArray = new JsonArray();
        JsonObject jsonObject = new JsonObject();
        List<CartDTO> cartInfo = productService.getCartInfo(id);
        List<String> list = new ArrayList<>();
        List<Map<String,Object>> cart = new ArrayList<>();
        for (Integer i = 0; i < cartInfo.size(); i++) {
            Object object = jsonParser.parse(cartInfo.get(i).getOptions());
            jsonObject = (JsonObject) object;
            jsonArray = (JsonArray) jsonObject.get("name");
            list = productService.getOptionCategory(cartInfo.get(i).getCart_seq());
            System.out.println("list : " + list);
            List<Map<String, Object>> optionMap = new ArrayList<>();
            for (Integer k = 0; k < list.size(); k++) {
                Map<String, Object> map = new HashMap<>();
                String category = list.get(k);
                String option = String.valueOf(jsonArray.get(k)).replace("\"", "");
                map.put(category, option);
                optionMap.add(map);
            }
            Map<String,Object> item = new HashMap<>();
            item.put("id",cartInfo.get(i).getId());
            item.put("count",cartInfo.get(i).getCount());
            item.put("cart_seq",cartInfo.get(i).getCart_seq());
            item.put("status",cartInfo.get(i).getStatus());
            item.put("pd_seq",cartInfo.get(i).getPd_seq());
            item.put("name",cartInfo.get(i).getName());
            item.put("description",cartInfo.get(i).getDescription());
            item.put("price",cartInfo.get(i).getPrice());
            item.put("stock",cartInfo.get(i).getStock());
            item.put("img",cartInfo.get(i).getImg());
            item.put("category",cartInfo.get(i).getCategory());
            item.put("option",optionMap);
            cart.add(item);
            System.out.println(cartInfo.get(i).getId());
            System.out.println(cartInfo.get(i).getCount());
            System.out.println(cartInfo.get(i).getPd_seq());
            System.out.println(cartInfo.get(i).getOptions());
            System.out.println("optionMap : "+optionMap);
            System.out.println("cart : "+cart);
        }

//        model.addAttribute("optionMap",optionMap);
//        model.addAttribute("cartInfo",cartInfo);
//        System.out.println(optionMap);
//        System.out.println("LIST : "+cart);
        model.addAttribute("cart",cart);
        return "/product/cart";
    }


    @ResponseBody
    @RequestMapping("/cart/delete")
    public String deleteItem(Integer cart_seq) throws Exception{
        productService.deleteItem(cart_seq);
        return "success";
    }

}