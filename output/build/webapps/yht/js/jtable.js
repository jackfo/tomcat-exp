function Jtable(initArea){
			this.table = initArea;
			//this.table.className = "DataTable";
			$(this.table).addClass("DataTable");
			$(this.table).attr('cellPadding', '0').attr('cellSpacing', '0');
			//this.table.cellPadding = 2;
			//this.table.cellSpacing = 0;
			this.com = new Object();
			this.remRowArr = new Object();
			this.checkboxName = "_"+$(this.table).attr("id")+"_checkbox";
			this.checkbox = [];
		}
		Jtable.prototype.init = function(){
			this.initCom();
			this.initEvent();
		}
		Jtable.prototype.initCom = function(){
			var mobj = this;
			//var cells = this.table.tHead.rows[0].cells;
			var cells = $(this.table).find("thead tr td");
			for(var i = 0; i < cells.length; i++){
				var cell = cells[i];
				if($(cell).attr("vtype")){
					this.com[$(cell).attr("vtype")] = i;
					switch($(cell).attr("vtype")){
						case "index":
							cell.innerHTML = "<span class='Table_index_column'></span>";
							break;
						case "checkbox":
							var chkbox = document.createElement("input");
							chkbox.type = "checkbox";
							chkbox.name = this.checkboxName;
							chkbox.className = "CHECK_BOX";
							initChkbox(chkbox);
							cell.appendChild(chkbox);
							break;
					}
				}
			}
			function initChkbox (chkbox){
				chkbox.onclick = function(){
					if(chkbox.checked){
						mobj.selectAll();
					}else{
						mobj.blur();
					}
				}
			}
			for(var i = 0; i < $(this.table).find("tbody").length; i++){
				var rows = $(this.table).find("tbody tr");
				for(var j = 0; j < rows.length; j++){
					var row = rows[j];
					if(!isNaN(parseInt(this.com["index"]))){
						var cell = row.insertCell(this.com["index"]);
						cell.innerHTML = row.rowIndex - $(this.table).find("thead tr").length + 1;
						cell.className = "Table_index";
					}
					if(!isNaN(parseInt(this.com["checkbox"]))){
						var cell =row.insertCell(this.com["checkbox"]);
						var chkbox = document.createElement("input");
						chkbox.type = "checkbox";
						chkbox.name = this.checkboxName;
						chkbox.className = "CHECK_BOX";
						chkbox.row = row;
						chkbox.value = row.rowIndex;
						cell.appendChild(chkbox);
						initSingleChkbox(chkbox);
						this.checkbox[this.checkbox.length] = chkbox;
						row.checkbox = chkbox;
					}
				}
			}
			function initSingleChkbox (chkbox){				
				$(chkbox).click(function(event){
					mobj.select(chkbox.row, chkbox.checked);
					//event.cancelBubble = true;
					event.stopPropagation();
				});
			}
		}
		Jtable.prototype.selectAll = function(){
			var rows = [];
			for(var i = 0; i < $(this.table).find("tbody").length; i++){
				var rs = $(this.table).find("tbody tr");
				for(var j = 0; j < rs.length; j++){
					rows[rows.length] = rs[j];
				}
			}
			this.setFocus(rows);
		}
		Jtable.prototype.initEvent = function(){
			var mobj = this;
			for(var i = 0; i < $(this.table).find("tbody tr").length; i++){
				var tbody = $(this.table).find("tbody tr")[i];
				regionEvent(tbody);
			}
			function regionEvent(tbody){
				$(tbody).click(function(){
					var tr = this;
					if(tr.nodeName == "TBODY") return;
					while(tr.nodeName != "TR"){
						tr = tr.parentNode;
					}
					if(tr != null){		
						mobj.blur();
						mobj.setFocus([tr]);
					}
				});
			}
		}
		Jtable.prototype.setFocus = function(rowArr){	
			for(var i = 0; i < rowArr.length; i++){
				var tr = rowArr[i];
				this.select(tr, true);
			}			
		}
		Jtable.prototype.blur= function(){		
			for(var item in this.remRowArr){
				this.select(this.remRowArr[item],false);
			}
		}
		
		Jtable.prototype.select= function(obj,flag){	
			if(flag){
				if(obj.checkbox)obj.checkbox.checked = true;
				obj.className += " RowActive";
				this.remRowArr[obj.rowIndex] = obj;
			}else{
				obj.className = obj.className.replace(/\s*(RowActive)/g,"" );
				if(obj.checkbox)obj.checkbox.checked = false;
				delete this.remRowArr[obj.rowIndex];
			}
		}
		Jtable.prototype.getSelected= function(){
			var arr = [];
			for(var item in this.remRowArr){
				arr[arr.length] = this.remRowArr[item];
			}
			return arr;
		}