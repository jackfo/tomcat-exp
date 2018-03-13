<jsp:include page="../container/header.jsp"></jsp:include>
<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<div class="site-block">
    <form class="layui-form" action="updateDepartment">
        <input type="hidden" name="departmentId" value="${cmDepartment.departmentId}">
        <div class="layui-form-item">
            <label class="layui-form-label">部门名称</label>
            <div class="layui-input-block">
                <input type="text" value="${cmDepartment.departmentName}"  name="departmentName" required  lay-verify="required" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">说明</label>
            <div class="layui-input-block">
                <textarea name="departmentDescription" required  lay-verify="required"  class="layui-textarea">${cmDepartment.departmentDescription}</textarea>
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