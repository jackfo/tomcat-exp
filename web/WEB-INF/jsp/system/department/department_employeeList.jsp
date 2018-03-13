<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../container/header.jsp"></jsp:include>

<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<div class="demoTable" style="width: 100%;display: block;height: 50px;padding-top: 10px;" >
        <input type="hidden" id="departmentId" value="${departmentId}">
        <form class="layui-form" action="" style="float: right">
            <div class="layui-form-item"  style="float: left">
                <div class="layui-inline">
                    <select id="employeeId" name="employeeId" lay-verify="required">
                            <c:forEach var="employee" items="${employeeList}">
                                <option value="${employee.employeeId}">${employee.eName}</option>
                            </c:forEach>
                       </select>
                </div>
            </div>
            <button style="float: left" id="addEmployee" class="layui-btn" >添加人员</button>
        </form>
</div>
<div>
    <table class="layui-hide" id="LAY_table_user" lay-filter="user"></table>
</div>

<script>
    var departmentId = $("#departmentId").val();
    layui.use('table', function(){
        var table = layui.table;
        table.render({
             elem: '#LAY_table_user'
            ,url: 'queryEmployeeListByDepartment?departmentId='+departmentId
            ,cellMinWidth: 80
            ,cols: [[
                {checkbox: true, fixed: true}
                ,{field:'eName', title: '姓名'}
                ,{field:'eSex', title: '性别'}
                ,{field:'eAge', title: '年龄'}
                ,{field:'id',title:'操作',toolbar:'#barDemo1'}
            ]]
            ,id: 'testReload'
            ,page: true
        });

        var $ = layui.$;
        var active = {
            reload: function(){
                var departmentIdReload = $("#departmentId");
                table.reload('testReload', {
                    where: {
                        departmentId:departmentIdReload.val()
                    }
                });
            }
        };

        $('#addEmployee').on('click', function(){
            var departmentId = $("#departmentId").val();
            var employeeId = $("#employeeId").val();
            $.ajax({
                url: "addEmployee",
                data:{departmentId:departmentId,employeeId:employeeId},
                success: function(data) {
                    window.location.reload();
                }
            });

        });


        table.on('tool(user)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的DOM对象
            if(layEvent === 'del'){ //删除
                layer.confirm('真的删除行么', function(index){
                     //删除对应行（tr）的DOM结构，并更新缓存
                     layer.close(index);
                     $.ajax({ url: "delDepartmentEmployee", data:{employeeId:data.employeeId,departmentId:departmentId}, success: function(data){
                         if(data.code=1){
                             obj.del();
                             layer.confirm('删除成功', function(index){
                                 layer.close(index);
                                 window.location.reload();
                             });
                         }
                     }});
                });
            }
        });
    });

</script>

<script type="text/html" id="barDemo1">
    <a class="layui-btn layui-btn-xsl layui-btn-danger" lay-event="del">移除</a>
</script>

<jsp:include page="../container/footer.jsp"></jsp:include>