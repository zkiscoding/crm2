<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>" />
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
	<script>
		$(function (){
			pageList(1,5);
			$("#qx").click(function (){
				$("input[name=xz]").prop("checked",this.checked)
			})
			$("#dicBody").on("click",$("input[name=xz]"),function (){
				$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
			})
			$("#editBtn").click(function (){
				var $xz = $("input[name=xz]:checked");
				if($xz.length !=1 ){
					alert("请选择一条需要修改的数据")
				}else {
					//alert($xz.val())
					window.location.href='settings/dictionary/value/edit.do?id='+$xz.val();
				}
			})
			$("#deleteBtn").click(function (){
				var $xz = $("input[name=xz]:checked");
				if($xz.length == 0){
					alert("请选择!")
				}else {if(confirm("确认删除此条数据么")){
					var param = "";
					for (let i = 0; i < $xz.length; i++) {
						param += "id=" + $xz[i].value;
						if(	i < $xz.length - 1){
							param += "&";
						}
					}
					$.ajax({
						url:"settings/dictionary/value/delete.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data){
							if(data){
								pageList(1,5)
							}else {
								alert("删除失败")
							}

						}


					})
				}

				}
			})

		})
		function pageList(pageNo,pageSize){
			$("#qx").prop("checked",false);
			$.ajax({
				url:"settings/user/getDicValueList.do",
				type:"get",
				data: {
					"pageNo": pageNo,
					"pageSize": pageSize
				},
				dataType:"json",
				success:function (data){
					var html = "";
					$.each(data.dataList,function (i,n){
						html += '<tr><td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html += '<td>'+n.value+'</td>';
						html += '<td>'+n.text+'</td>';
						html += '<td>'+n.orderNo+'</td>';
						html += '<td>'+n.typeCode+'</td></tr>';
					})
					$("#dicBody").html(html);
					// 获取总页数 总记录条数除每没一页展示的条数 向上取整
					var totalPages = data.totalSize%pageSize==0?data.totalSize/pageSize:parseInt(data.totalSize/pageSize)+1;
					$("#dicValuePage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // ActivityController每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.totalSize, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					});
				}


			})
		}
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/value/save.jsp'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" id="editBtn" class="btn btn-default" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="qx"/></td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="dicBody">

			</tbody>
		</table>
	</div>
	<div style="height: 50px; position: relative;top: 30px;">
		<div id="dicValuePage">

		</div>
	</div>
	
</body>
</html>