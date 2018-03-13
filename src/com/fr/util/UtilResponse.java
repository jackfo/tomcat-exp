package com.fr.util;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


public class UtilResponse {

    public static void json(Object object, HttpServletResponse response) {
        try {
            response.setContentType("text/html;charset=utf-8");
            String obj = JSON.toJSONString(object,SerializerFeature.WriteDateUseDateFormat, SerializerFeature.DisableCircularReferenceDetect);
            response.getWriter().write(obj);
            response.getWriter().flush();
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            try {
                response.getWriter().close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    public static void jsonNullvalue(Object object, HttpServletResponse response) {
        try {
            response.setContentType("text/html;charset=utf-8");
            String obj = JSON.toJSONString(object,SerializerFeature.WriteMapNullValue,SerializerFeature.DisableCircularReferenceDetect,SerializerFeature.WriteNullListAsEmpty);
            response.getWriter().write(obj);
            response.getWriter().flush();
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            try {
                response.getWriter().close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    //	public static void json(String key,String value, HttpServletResponse response) {
//		try {
//			response.setContentType("text/json;charset=utf-8");
//			String obj = JSON.toJSONString(UtilMisc.toMap(key, value),SerializerFeature.WriteDateUseDateFormat, SerializerFeature.DisableCircularReferenceDetect);
//			response.getWriter().write(obj);
//			response.getWriter().flush();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}finally {
//			try {
//				response.getWriter().close();
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//        }
//	}
    public static void responseOutWithJson(Object object,HttpServletResponse response) {
        try {
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/json; charset=utf-8");
            String obj = JSON.toJSONString(object,SerializerFeature.WriteDateUseDateFormat, SerializerFeature.DisableCircularReferenceDetect);
            response.getWriter().write(obj);
            response.getWriter().flush();
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            try {
                response.getWriter().close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void html(String html, HttpServletResponse response) {
        try {
            response.setContentType("text/html;charset=utf-8");
            response.getWriter().write(html);
            response.getWriter().flush();
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            try {
                response.getWriter().close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    /**
     * 放入sessionId写入浏览器
     * @param object
     * @param response
     */
    public static void json(Object object, HttpServletResponse response,String sessionId) {
        try {
            response.setContentType("text/html;charset=utf-8");
            response.setHeader("session_id", sessionId);
            String obj = JSON.toJSONString(object,SerializerFeature.WriteDateUseDateFormat, SerializerFeature.DisableCircularReferenceDetect);
            response.getWriter().write(obj);
            response.getWriter().flush();
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            try {
                response.getWriter().close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
