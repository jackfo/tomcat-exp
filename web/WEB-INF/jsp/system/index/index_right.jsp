<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="row content-tabs">
    <button class="roll-nav roll-left J_tabLeft"><i class="fa fa-backward"></i>
    </button>
    <nav class="page-tabs J_menuTabs">
        <div class="page-tabs-content">
            <a href="javascript:;" class="active J_menuTab" data-id="welcome">首页</a>
        </div>
    </nav>
    <button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i>
    </button>
    <div class="btn-group roll-nav roll-right">
        <button class="dropdown J_tabClose" data-toggle="dropdown">关闭操作<span class="caret"></span>

        </button>
        <ul role="menu" class="dropdown-menu dropdown-menu-right">
            <li class="J_tabShowActive"><a>定位当前选项卡</a>
            </li>
            <li class="divider"></li>
            <li class="J_tabCloseAll"><a>关闭全部选项卡</a>
            </li>
            <li class="J_tabCloseOther"><a>关闭其他选项卡</a>
            </li>
        </ul>
    </div>
    <a href="login.html" class="roll-nav roll-right J_tabExit"><i class="fa fa fa-sign-out"></i> 退出</a>
</div>


<div class="row J_mainContent" id="content-main">
    <iframe class="J_iframe" name="iframe0" width="100%" height="100%" src="welcome" frameborder="0" data-id="welcome" seamless></iframe>
</div>