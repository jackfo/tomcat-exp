<jsp:include page="../container/header.jsp"></jsp:include>
<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<div class="site-block">
    <form class="layui-form" action="createRole">
        
        <div class="layui-form-item">
            <label class="layui-form-label">角色</label>
            <div class="layui-input-block">
                <input type="text" name="roleId" required  lay-verify="required" placeholder="请输入角色" autocomplete="off" class="layui-input">
            </div>
        </div>
      <div class="layui-form-item">
            <label class="layui-form-label">姓名</label>
            <div class="layui-input-block">
                <input type="text"  name="roleName" required  lay-verify="required" placeholder="请输入姓名" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>
</div>
<jsp:include page="../container/footer.jsp"></jsp:include>