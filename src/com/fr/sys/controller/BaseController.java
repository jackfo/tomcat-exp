package com.fr.sys.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by jack on 2017/10/29.
 */
@Controller
public class BaseController {

    @RequestMapping("welcome")
    public String login(){
        return "system/welcome/welcome";
    }

}
