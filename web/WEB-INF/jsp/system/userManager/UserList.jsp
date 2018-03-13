<jsp:include page="../container/header.jsp"></jsp:include>

<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<div class="demoTable" style="width: 100%;display: block;height: 40px;" >
    <a href="editUser" style="float: right;margin-right: 10px;margin-top: 10px;" class="layui-btn">新增</a>
    <div style="float: right;margin-right: 10px;margin-top: 10px;">
        <div class="layui-inline">
            <input class="layui-input" name="keyword" id="demoReload" autocomplete="off">
        </div>
        <button class="layui-btn" data-type="reload">搜索</button>
    </div>
</div>
<table class="layui-hide" id="LAY_table_user" lay-filter="user"></table>
<script>
    layui.use('table', function(){
        var table = layui.table;
        table.render({
             elem: '#LAY_table_user'
            ,url: 'queryUserList'
            ,cellMinWidth: 80
            ,cols: [[
                {checkbox: true, fixed: true}
                ,{field:'userLoginId', title: '登录名'}
                ,{field:'userName', title: '用户名'}
                ,{field:'sex', title: '用户性别'}
                ,{field:'password', title: '密码'}
                ,{field:'id',title:'操作',toolbar:'#barDemo1'}
            ]]
            ,id: 'testReload'
            ,page: true
        });

        var $ = layui.$;
        var active = {
            reload: function(){
                var demoReload = $('#demoReload');
                table.reload('testReload', {
                    where: {
                        keyword: demoReload.val()
                    }
                });
            }
        };

        $('.demoTable .layui-btn').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });


        table.on('tool(user)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的DOM对象
            if(layEvent === 'edit'){ //查看
               window.location.href ="editUser?userId="+ data.userLoginId;
            } else if(layEvent === 'del'){ //删除
                layer.confirm('真的删除行么', function(index){
                     //删除对应行（tr）的DOM结构，并更新缓存
                     layer.close(index);
                     $.ajax({ url: "delUser", data:{userId:data.userLoginId}, success: function(data){
                         if(data.code=1){
                             obj.del();
                             layer.confirm('删除成功', function(index){
                                 layer.close(index);
                                 window.location.href="userManager";
                             });
                         }
                     }});
                });
            }
        });
    });

</script>

<script type="text/html" id="barDemo1">
    <a class="layui-btn layui-btn-xsl layui-btn-primary" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xsl layui-btn-danger" lay-event="del">删除</a>
</script>

<jsp:include page="../container/footer.jsp"></jsp:include>