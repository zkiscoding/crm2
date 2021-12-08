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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		// bootstrap的时间选择器
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		$("#addBtn").click(function (){
			// 为创建按钮绑定事件 目的是在打开模态窗口的同时绑定一些事件

			$.ajax({
				url:"workbench/activity/getUserList.do",

				type:"get",
				dataType:"json",
				success:function (data){
					var html = "<option></option>"
					$.each(data,function (i,n){
						html+="<option value='"+n.id+"'>"+n.name+"</option>"
					})
					$("#create-marketActivityOwner").html(html);
					$("#create-marketActivityOwner").val("${user.id}")
					$("#createActivityModal").modal("show")

				}


			})

		})
		$("#saveBtn").click(function (){
			$.ajax({
				url:"workbench/activity/save.do",
				data:{
					"owner" : $("#create-marketActivityOwner").val(),
					"name" : $("#create-marketActivityName").val(),
					"startDate" : $("#startDate").val(),
					"endDate" : $("#endDate").val(),
					"cost" : $("#create-cost").val(),
					"description" : $("#description").val(),
					"createBy":"${user.name}" // 创建人为当前登录用户
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if(data){
						pageList( 1 ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#createActivityModal").modal("hide");
						$("#saveForm")[0].reset();

					}else {
						alter("添加失败")
					}
				}


			})
		})
		pageList(1,5);
		// 为搜索按钮注册条件查询时间
		$("#searchBtn").click(function () {

			//单击查询按钮的时候将查询条件全部保存在隐藏域中
			$("#hidden-name").val($("#search-name").val());
			$("#hidden-owner").val($("#search-owner").val());
			$("#hidden-startDate").val($("#search-startDate").val());
			$("#hidden-endDate").val($("#search-endDate").val());

			pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
					,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#qx").click(function (){
			$("input[name=xz]").prop("checked",this.checked)
		})
		$("#activityBody").on("click",$("input[name=xz]"),function (){
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		$("#deleteBtn").click(function (){
			var $xz = $("input[name=xz]:checked");
			if($xz.length==0){
				alert("请选择删除的数据")
			}else {
					if(confirm("确定删除所选中的记录吗？")){
						var param =	"";
						for (var i = 0; i < $xz.length; i++){
							param += "id=" + $xz[i].value ;
							if(	i < $xz.length - 1){
								param += "&";
							}
						}
						$.ajax({
							url:"" +
									"" +
									"",
							data:param,
							type:"post",
							dataType:"json",
							success:function (data){
								if(data){
									pageList( 1 ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
								}else {
									alert("删除失败")
								}
							}


						})
					}
			}
		})
		$("#editBtn").click(function (){
			var $xz = $("input[name=xz]:checked");
			if($xz.length==0 || $xz.length>1){
				alert("请选择一条需要修改的数据")
			}else {
				//$("#createActivityModal").modal("show")
				var id = $xz.val();
				$.ajax({
					url:"workbench/activity/getAcById.do",
					data:{
						"id":id
					},
					type:"get",
					dataType:"json",
					success:function (data){
						var html = "<option></option>";

						// 下拉框赋值 每一个option中的value赋值为该对应用户的id
						$.each(data.userList , function (index,element) {
							// 当前活动的所有着 为下列列表的开头
							//alert(element.name);
							html += "<option value='"+element.id+"' id='"+element.id+"'>"+element.name+"</option>";
						});

						$("#edit-owner").html(html);
						$("#edit-owner").val(data.activity.owner);
						// 给所有文本栏赋值
						$("#edit-name").val(data.activity.name);
						$("#edit-startDate").val(data.activity.startDate);
						$("#edit-endDate").val(data.activity.endDate);
						$("#edit-cost").val(data.activity.cost);
						$("#edit-description").val(data.activity.description);

						// 隐藏域中保存id
						$("#edit-id").val(data.activity.id);
						$("#editActivityModal").modal("show")


					}



				})
			}
		})
		$("#updateBtn").click(function (){
			$.ajax({
				url:"workbench/activity/update.do",
				data:{
					"id" : $("#edit-id").val(),
					"owner" : $("#edit-owner").val(),
					"name" : $("#edit-name").val(),
					"startDate" : $("#edit-startDate").val(),
					"endDate" : $("#edit-endDate").val(),
					"cost" : $("#edit-cost").val(),
					"description" : $("#edit-description").val(),
					"editBy":"${user.name}" // 为当前登录用户
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if(data){
						// 保持当前页不动
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editActivityModal").modal("hide");

					}else {
						alert("修改失败")
					}
				}


			})
		})
		
	});
	function pageList(pageNo,pageSize){
		// 将所有复选框取消选择
		$("#qx").prop("checked",false);

		$("#search-name").val($("#hidden-name").val());
		$("#search-owner").val($("#hidden-owner").val());
		$("#search-startDate").val($("#hidden-startDate").val());
		$("#search-endDate").val($("#hidden-endDate").val());
		$.ajax({
			url:"workbench/activity/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				// 搜索条件 利用动态sql 有就填 没有就不填
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"startDate":$.trim($("#search-startDate").val()),
				"endDate":$.trim($("#search-endDate").val())
			},
			type:"get",
			dataType:"json",
			success:function (data){
				var html="";
				$.each(data.dataList,function (i,n){
						html += '<tr class="active">';
						html += '<td><input type="checkbox" value='+n.id+' name="xz"/></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
						html += '<td>'+n.owner+'</td>';
						html += '<td>'+n.startDate+'</td>';
						html += '<td>'+n.endDate+'</td>';
						html += '</tr>';
				})
				$("#activityBody").html(html);
				// 获取总页数 总记录条数除每没一页展示的条数 向上取整
				var totalPages = data.totalSize%pageSize==0?data.totalSize/pageSize:parseInt(data.totalSize/pageSize)+1;
				$("#activityPage").bs_pagination({
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
	<%--隐藏域 用来保存信息--%>
	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="saveForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id" />

						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" >
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage">

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>