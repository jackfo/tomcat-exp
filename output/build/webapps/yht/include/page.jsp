<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<div class="Page">
	<nobr>总记录数:<b> <c:out value="${pageList.totalCount}"/></b> 笔</nobr>
	<nobr>每页 <b><c:out value="${pageList.pageSize}"/>
	<input style="display:none" id="PAGE_SIZE" size="1"  class="TextCom css_BC" value="<c:out value="${pageList.pageSize}"/>"></b> 笔</nobr>
	<a href="javascript:pageEvent(0)" title="首 页"  class="Page_first" ></a>
	<a href="javascript:pageEvent(<c:out value="${pageList.previousIndex}"/>)" title="上一页"  class="Page_up" ></a>
	<a class="Page_Text css_BC"> <c:out value="${pageList.currentPageIndex+1}"/> / <c:out value="${fn:length(pageList.indexes) }"/>
	<input style="display:none" id="Page_Num" size="1"  class="TextCom css_BC" value="<c:out value="${fn:length(pageList.indexes) }"/>">
	</a>		
	<a href="javascript:pageEvent(<c:out value="${pageList.nextIndex}"/>)" title="下一页"  class="Page_down"></a>
	<a href="javascript:pageEvent(<c:out value="${pageList.indexes[fn:length(pageList.indexes)-1]}"/>)" title="未 页"  class="Page_last" ></a>
	 &nbsp;转至第<INPUT id="Page_index_text" size="1" value="<c:out value="${pageList.currentPageIndex+1}"/>" class="TextCom css_BC">页
	  <INPUT type="button" id="findpage" size="2" value="GO" onclick="pageEvent(Page_index_text.value,true)" class="FuncBtn">
	<Script Language="JavaScript">
		function pageEvent(index,flag){
			var pageSize = parseInt(PAGE_SIZE.value);
			var totalNum = parseInt(Page_Num.value);
			if(isNaN(index)){
				return;
			}
			if(flag){
				var index = parseInt(index) ;
				if(isNaN(index)){
					alert("不是有效数字!");
					Page_index_text.select();
					return;
				}else if(index < 0 || index > totalNum){
					alert("对不起，您输入的页码过大或过小!");
					Page_index_text.select();
					return;
				}
				var index = (index-1) * pageSize;
			}
			var param = "&PAGE_INDEX="+index;
			param += "&PAGE_SIZE="+pageSize;

			PaginationSupportForm.action = "<c:out escapeXml="false"  value="${pageUrl}" />"+param;			
			PaginationSupportForm.submit();
		}
	</Script>
	<form name="PaginationSupportForm" method="POST" style="display:none;">
		<c:forEach var="item" items="${pageList.param}">
			<input name="<c:out  value='${item.key}'/>" value="<c:out  value="${item.value}"/>" >
		</c:forEach>
	</form>
</div>