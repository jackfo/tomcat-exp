<jsp:include page="../container/header.jsp"></jsp:include>
<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<div class="site-block">
    <form class="layui-form" action="updatePermission">
        <div class="layui-form-item">
            <label class="layui-form-label">权限名称</label>
            <div class="layui-input-block">
                <input type="text" value="${syspermission.permissionId}"  readonly="true" name="permissionId" required  lay-verify="required" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">信息</label>
            <div class="layui-input-block">
                <textarea name="description" required  lay-verify="required"  class="layui-textarea">${syspermission.description}</textarea>
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