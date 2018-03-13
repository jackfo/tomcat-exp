<jsp:include page="../container/header.jsp"></jsp:include>
<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<div class="site-block">
    <form class="layui-form" action="createUser">
        <div class="layui-form-item">
            <label class="layui-form-label">登录名</label>
            <div class="layui-input-block">
                <input type="text"  name="userLoginId" required  lay-verify="required"  class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">用户姓名</label>
            <div class="layui-input-block">
                <textarea  name="userName" required  lay-verify="required"  class="layui-input"></textarea>
            </div>
        </div>
                <div class="layui-form-item">
            <label class="layui-form-label">用户性别</label>
            <div class="layui-input-block">
                <textarea  name="sex" required  lay-verify="required"  class="layui-input"></textarea>
            </div>
        </div>
		<div class="layui-form-item">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-block">
                <textarea  name="password" required  lay-verify="required"  class="layui-input"></textarea>
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