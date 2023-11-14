<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
html{
  height:100%;
}
body{
  height:100%;
}
#whole-container{
  height:100%;
  min-height:100%;
}
#charts-container{
  text-align:center;
  height:85%;
  width:85%;
  margin:0 auto;
}
.el-tabs{
    height:90% !important;
}
.el-tabs__content{
    height:100% !important;
}

</style>
<link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
<!--script src = "../js/vue.js"></script>
<script src = "../js/fakeData.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script src="../js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/echarts@5.2.2/dist/echarts.min.js"></script-->
	<script  src="utils/elementui/vue.js"></script> 
  	<script src="utils/elementui/index.js"></script>
  	<script src="utils/js/jquery-1.8.3.min.js" type="text/javascript"></script>
<script src="utils/js/jsf.js" type="text/javascript"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/echarts@5.2.2/dist/echarts.min.js"></script>
<title>数据分析</title>
</head>
<body>
<div id="whole-container">
  <el-tabs type="border-card" v-model="activeName" @tab-click="drawCharts">
      <el-form  :inline="true"
                :model="dateForm" 
                class="demo-form-inline" 
                ref="dateForm" 
                id="dateForm">
            <el-form-item prop="date1">
              <el-date-picker type="date" id="startDate" placeholder="选择开始日期" v-model="dateForm.startDate" style="width: 100%;" :picker-options="pickerOptions"></el-date-picker>
            </el-form-item>
            <el-form-item prop="date2">
              <el-date-picker type="date" id="EndDate" placeholder="选择结束日期" v-model="dateForm.EndDate" style="width: 100%;" :picker-options="pickerOptions"></el-date-picker>
            </el-form-item>
            <el-form-item label="时间跨度" prop="region">
                <el-select v-model="dateForm.region" id="timePeriod" placeholder="选择时间跨度">
                    <el-option label="年" value="byYear"></el-option>
                    <el-option label="月" value="byMonth"></el-option>
                    <el-option label="周" value="byWeek"></el-option>
                    <el-option label="日" value="byDate"></el-option>
                </el-select>
            </el-form-item >
            <el-form-item label="产品名称" prop="name" id="goodsNameItem">
                  <el-input v-model="dateForm.name" id="goodsName" ></el-input>
            </el-form-item>
            <el-button type="primary" @click="submitForm('dateForm')">查询</el-button>
            <div id="info_container"></div>
      </el-form>
          <!--el-tab-pane label="订单趋势" name="first" ></el-tab-pane>
          <el-tab-pane label="销售额" name="second"></el-tab-pane-->
          <el-tab-pane label="访问量" name="third" ></el-tab-pane>
          <!--el-tab-pane label="销售比例" name="fourth"></el-tab-pane-->
          <el-tab-pane label="产品量" name="fifth"></el-tab-pane>
          <el-tab-pane label="数据对比" name="sixth"></el-tab-pane>
          <div id="charts-container"></div>  
  </el-tabs>
</div>


<script>
$("#goodsNameItem").hide();
$(document).ready(function(){//打开页面时触发，仅一次
      triple_value_1 = getDatas(callback_data,dataName);
      triple_value_2 = getDatas(callback_data,dataName2);
      triple_value_3 = getDatas(callback_data,dataName3);
      if(callback_data.data.length == 0){
            titlemsg = "在这个时间段内没有数据。请调整时间段再进行查询。";
            triple_name1 ='';
            triple_name2 ='';
            triple_name3 =''; 
      }else{
            titlemsg = "访问量与销售额与比例的对比图";
            draw_triple("draw");
      }
      draw_triple("draw");
})
//所有全局变量的声明和预设，由于默认tab打开在third中，部分预设设置为third中的数值。
      var double_name1 ='';
      var double_name2 ='';
      var triple_name1 ='访问量';
      var triple_name2 ='订单量';
      var triple_name3 ='比例';
      var DrawtimeType = "orderTime";
      var titlemsg='';
      var requestType = 'orderPro';
      var dataName = 'clicksSum';//在submitForm中获取所在的tab区域的变量
      var dataName2 ='orderCount';
      var dataName3 = 'rate';
      localStorage.setItem("chartType","");  	
      var timeSetting ={//传输值预设
            "timeType":"2",
            "startTime":get3MonthAgo(),
            "endTime":getToday(),
            "catalogno":""
      };
      var callback_data = dldata(requestType,JSON.stringify(timeSetting),1);//打开页面触发绘制，仅一次 
//vue设置
    var vu = new Vue({
    	el:"#whole-container",
         data() {
          return {
            pickerOptions:{
            disabledDate(time) {
                return time.getTime() > Date.now(); //今天之后禁用
              }
           },
            activeName:'third',
            dateForm: {
            name: '',
            region: '月',
            goods:'',
            startDate: get3MonthAgo(),//默认起点为三个月前
            EndDate: getToday(),//默认终点为当日
            delivery: false,
            type: [],
            resource: '',
            desc: ''
          },
      }
    },
      methods:{
        handleClick(tab, event) {
                console.log(tab, event);
              },
        drawCharts(tab){//此函数将表格类型设置进行传输打包

            /*if (tab.name == "first"){
                $("#goodsNameItem").hide();
                timeSetting.catalogno ='';
                values = getDatas(example_timeObject)[1];
                double_value_1 = values;
                draw("clear");
                draw("draw");
            }else if (tab.name == "second"){            
                $("#goodsNameItem").hide();
                timeSetting.catalogno ='';
                values = getRandomArray(100);
                double_value_2 = values;
                draw("clear");
                draw("draw");
            }*/
            /*if (tab.name =="third"){     //点击率数据查询
          	  
                dataName = "clicksSum";
                titlemsg = "访问量的数据分析图";
                localStorage.setItem("chartType","clickAnalysis")     
                requestType = localStorage.getItem("chartType");  
                callback_data = dldata(requestType,JSON.stringify(timeSetting),1); 
                getXaxis();
                values = getDatas(callback_data,dataName);
                if(callback_data.data.length == 0){
                	titlemsg ="在这个时间段内没有数据,请调整时间段再进行查询。" ;
                	        }
                $("#goodsNameItem").show(); 
                draw("clear");  
                draw("draw");

            }else if (tab.name == "fourth"){  //订单量/访问量数据查询
          	  
                $("#goodsNameItem").hide();
                dataName = "rate";
                titlemsg = "销售比例的数据分析图";
                localStorage.setItem("chartType","orderPro")      
                timeSetting.catalogno ='';
                requestType = localStorage.getItem("chartType");
               
                callback_data = dldata(requestType,JSON.stringify(timeSetting),1);
                getXaxis();
                values = getDatas(callback_data,dataName);
                if(callback_data.data.length == 0){
                	titlemsg ="在这个时间段内没有数据,请调整时间段再进行查询。" ;
                	        }
                draw("clear");
                draw("draw");

            }*/if (tab.name =="third"){     //点击、销售、比例的三项对比图
                dataName = "clicksSum";
                dataName2 ='orderCount';
                dataName3 = 'rate';
                titlemsg = "访问量与销售额与比例的对比图";
                localStorage.setItem("chartType","orderPro")     
                requestType = localStorage.getItem("chartType");  

                callback_data = dldata(requestType,JSON.stringify(timeSetting),1); 
                getXaxis();
                triple_value_1 = getDatas(callback_data,dataName);
                triple_value_2 = getDatas(callback_data,dataName2);
                triple_value_3 = getDatas(callback_data,dataName3);
                if(callback_data.data.length == 0){
                	                        titlemsg ="在这个时间段内没有数据,请调整时间段再进行查询。"
                	                        triple_name1 ='';
                	                        triple_name2 ='';
                                          triple_name3 ='';
                	                }else{
                                          triple_name1 ='访问量';
                                          triple_name2 ='订单量';
                                          triple_name3 ='比例';
                	              }
                $("#goodsNameItem").show(); 
                draw("clear");  
                draw_triple("draw");

            }else if (tab.name == "fifth"){  //产品总量和增量的对比图数据查询
          	  
                dataName = "proCount";
                dataName2 = "proIncrement";
                titlemsg = "产品量的数据分析图";
                localStorage.setItem("chartType","onlinePro")   
                timeSetting.catalogno ='';
                requestType = localStorage.getItem("chartType"); 
                callback_data = dldata(requestType,JSON.stringify(timeSetting),1);
                getXaxis();      
                $("#goodsNameItem").hide();
                double_value_1 =getDatas(callback_data,dataName);
                double_value_2 =getDatas(callback_data,dataName2);
                if(callback_data.data.length == 0){
                	                        titlemsg ="在这个时间段内没有数据,请调整时间段再进行查询。"
                	                        double_name1 ='';
                	                        double_name2 ='';
                	                }else{
                	                        double_name1 ='产品总量';
                	                        double_name2 ='产品增量';
                	              }
                draw("clear");
                draw_Double("draw");
				
            }else if (tab.name == "sixth"){ //订单查询分析数据 
                dataName = "totalPrice";
                dataName2 = "orderCount";
                titlemsg="订单趋势与销售额的对比图";
                localStorage.setItem("chartType","orderAnalysis")  
                timeSetting.catalogno ='';
                requestType = localStorage.getItem("chartType");           
                $("#goodsNameItem").hide();
                callback_data = dldata(requestType,JSON.stringify(timeSetting),1);
                
                getXaxis();
                double_value_1 =getDatas(callback_data,dataName);
                double_value_2 =getDatas(callback_data,dataName2);
                if(callback_data.data.length == 0){
                	                        titlemsg ="在这个时间段内没有数据,请调整时间段再进行查询。"
                	                        double_name1 ='';
                	                        double_name2 ='';
                	                }else{
                	                        double_name1 ='销售额';
                	                        double_name2 ='订单趋势';
                	              }
                draw("clear");
                draw_Double("draw");

            }
        },
        submitForm(formName) {//此函数将时间设置进行传输打包
            getXaxis();

            this.$refs[formName].validate((valid) => {
              if (valid) {
                timeSetting.startTime = dateForm.startDate.value;//调整timeSetting值
                timeSetting.endTime = dateForm.EndDate.value;
                if(dateForm.timePeriod.value == "年"){//调整timeType数据
                    timeSetting.timeType = "1"
                }else if(dateForm.timePeriod.value == "月"){
                    timeSetting.timeType = "2"
                }else if(dateForm.timePeriod.value == "日"){
                    timeSetting.timeType = "3"
                }else if(dateForm.timePeriod.value == "周"){
                    timeSetting.timeType = "4"
                }
                if(requestType == "clickAnalysis"){//如果选择到点击量页面则激活名称搜索框
                     timeSetting.catalogno = dateForm.goodsName.value;
                }
                //console.log(requestType);
                //console.log(timeSetting);
                callback_data = dldata(requestType,JSON.stringify(timeSetting),1);

                //console.log("从"+dateForm.startDate.value+"到"+dateForm.EndDate.value+"为止查询物品"+dateForm.goodsName.value+",以每"+dateForm.timePeriod.value+"进行区分");
                //console.log(localStorage.getItem("chartType"));
                if(callback_data.data.length == 0){//检测返callback_data的数据是否为空，空则直接返回
                	titlemsg ="在这个时间段内没有数据,请调整时间段再进行查询。"   
                	double_name1 ='';
                	double_name2 ='';
                  triple_name1 ='';
                  triple_name2 ='';
                  triple_name3 ='';
                  draw("clear");
                  draw("draw");
                  return;
                }
                
                if(requestType == "orderAnalysis"){//这里的条件是用于根据所在的tab绘制函数的，不同模块之间传参困难所以选择全局变量并重新绘制
                      console.log("orderAnalysis");
                      double_value_1 =getDatas(callback_data,"totalPrice");
                      double_value_2 =getDatas(callback_data,"orderCount");
                      dataName = "totalPrice";
                      dataName2 = "orderCount";
                      titlemsg = "订单趋势与销售额的对比图";
                      double_name1 ='销售额';
                  	  double_name2 ='订单趋势';
                      draw("clear");
                      draw_Double("draw");
                      
                }else if (requestType == "onlinePro"){
                      console.log(dataName);
                      double_value_1 =getDatas(callback_data,"proCount");
                      double_value_2 =getDatas(callback_data,"proIncrement");
                      dataName = "proCount";
                      dataName2 = "proIncrement";
                      titlemsg = "产品量的数据分析图";
                      double_name1 ='产品总量';
                  	  double_name2 ='产品增量';
                      draw("clear");
                      draw_Double("draw");
                }else if(requestType == "orderPro"){
                      triple_value_1 = getDatas(callback_data,"clicksSum");
                      triple_value_2 = getDatas(callback_data,'orderCount');
                      triple_value_3 = getDatas(callback_data,'rate');
                      dataName = "clicksSum";
                      dataName2 ='orderCount';
                      dataName3 = 'rate';
                      titlemsg = "访问量与销售额与比例的对比图";
                      triple_name1 ='访问量';
                      triple_name2 ='订单量';
                      triple_name3 ='比例';                     
                      draw("clear");
                      draw_triple("draw");
                }
                else{
                      values = getDatas(callback_data,dataName);
                      console.log(dataName);
                      draw("clear");
                      draw("draw");
                }
               
              } else {
                console.log('error submit!!');
                return false;
              }
            });
        }
        
      }
    });
   
//echarts
    var dom = document.getElementById("charts-container");
    var myChart = echarts.init(dom);
    var app = {};
    var values = [];
    var double_value_1 =[];
    var double_value_2 =[];
    var option;
    var double_option;

function getDatas(datalogs,key){
//datalogs：一般使用callback_data。key：需要调取的字段。返回datalogs中名称为key的数据数组。
  var DataArray =[];
  for(i=0;i<datalogs.data.length;i++){
      DataArray.push((datalogs.data[i])[key]);
  }
      
  return DataArray; 
}

function getXaxis(){//根据目标所在的tab的名称设置x坐标的时间段对应字段值
      if(localStorage.getItem("chartType") == "orderPro"){
            DrawtimeType ="orderTime";
      }else if(localStorage.getItem("chartType") == "onlinePro"){
            DrawtimeType ="regTime";
      }else if(localStorage.getItem("chartType") == "orderAnalysis"){
            DrawtimeType ="orderTime";
      }
}

function draw_triple(status){//绘制三线图
        double_option = {
            title: {
              text: titlemsg
            },
            tooltip: {
              trigger: 'axis'
            },
            legend: {},
            toolbox: {
              show: true,
              feature: {
                /* dataZoom: {
                  yAxisIndex: 'none'
                }, */
                /* dataView: { readOnly: false }, */
                magicType: { type: ['line', 'bar'] },
                /* restore: {}, */
                saveAsImage: {}
              }
            },
            xAxis: {
              type: 'category',
              boundaryGap: false,
              data: getDatas(callback_data,DrawtimeType)
            },
            yAxis: {
              type: 'value',
            },
            series: [
              {
                name: triple_name1,
                type: 'line',
                data: triple_value_1,
                markPoint: {
                  data: [
                    { type: 'max', name: 'Max' },
                    { type: 'min', name: 'Min' }
                  ]
                },
                markLine: {
                  data: [{ type: 'average', name: 'Avg' }]
                }
              },
              {
                name: triple_name2,
                type: 'line',
                data: triple_value_2,
                markLine: {
                  data: [
                    { type: 'average', name: 'Avg' },
                    [
                      {
                        symbol: 'none',
                        x: '90%',
                        yAxis: 'max'
                      },
                      {
                        symbol: 'circle',
                        label: {
                          position: 'start',
                          formatter: 'Max'
                        },
                        type: 'max',
                        name: '最高点'
                      }
                    ]
                  ]
                }
              },
              {
                name: triple_name3,
                type: 'line',
                data: triple_value_3,
                markLine: {
                  data: [
                    { type: 'average', name: 'Avg' },
                    [
                      {
                        symbol: 'none',
                        x: '90%',
                        yAxis: 'max'
                      },
                      {
                        symbol: 'circle',
                        label: {
                          position: 'start',
                          formatter: 'Max'
                        },
                        type: 'max',
                        name: '最高点'
                      }
                    ]
                  ]
                }
              }
            ]
          };
          if (status == "clear"){
            myChart.clear();
          }else if (status == "draw"){
            if (double_option && typeof double_option === 'object') {
              myChart.setOption(double_option);
            } 
          }
}
function draw_Double(status){//绘制双线图
        double_option = {
            title: {
              text: titlemsg
            },
            tooltip: {
              trigger: 'axis'
            },
            legend: {},
            toolbox: {
              show: true,
              feature: {
                /* dataZoom: {
                  yAxisIndex: 'none'
                }, */
                /* dataView: { readOnly: false }, */
                magicType: { type: ['line', 'bar'] },
                /* restore: {}, */
                saveAsImage: {}
              }
            },
            xAxis: {
              type: 'category',
              boundaryGap: false,
              data: getDatas(callback_data,DrawtimeType)
            },
            yAxis: {
              type: 'value',
            },
            series: [
              {
                name: double_name1,
                type: 'line',
                data: double_value_1,
                markPoint: {
                  data: [
                    { type: 'max', name: 'Max' },
                    { type: 'min', name: 'Min' }
                  ]
                },
                markLine: {
                  data: [{ type: 'average', name: 'Avg' }]
                }
              },
              {
                name: double_name2,
                type: 'line',
                data: double_value_2,
                markLine: {
                  data: [
                    { type: 'average', name: 'Avg' },
                    [
                      {
                        symbol: 'none',
                        x: '90%',
                        yAxis: 'max'
                      },
                      {
                        symbol: 'circle',
                        label: {
                          position: 'start',
                          formatter: 'Max'
                        },
                        type: 'max',
                        name: '最高点'
                      }
                    ]
                  ]
                }
              }
            ]
          };
          if (status == "clear"){
            myChart.clear();
          }else if (status == "draw"){
            if (double_option && typeof double_option === 'object') {
              myChart.setOption(double_option);
            } 
          }
          
}
function draw(status){//画表函数。预设。参数status：字符串，clear清除画布，draw进行绘制。参数设置在上方绑定方法的drawCharts中。
          option = {
            title: {
                  text: titlemsg
                 },
          tooltip: {
                trigger: 'axis'
              },
              toolbox: {
                show: true,
                feature: {
                  /* dataZoom: {
                    yAxisIndex: 'none'
                  },
                dataView: { readOnly: false }, */
                magicType: { type: ['line', 'bar'] },
                /* restore: {}, */
                saveAsImage: {}
                }
              },
              xAxis: {
                type: 'category',
                data: getDatas(callback_data,DrawtimeType)
              },
              yAxis: {
                type: 'value'
              },
              series: [
                {
                  data: values,
                  type: 'line'
                }
              ]
            };
              if (status == "clear"){
            myChart.clear();
          }else if (status == "draw"){
            if (option && typeof option === 'object') {
              myChart.setOption(option);
            } 
          }
    }
/*筛选函数由后端执行，此函数弃用
function getDatabyPeriod(timeArray,startTime,EndTime){//时间段筛选函数，参数为时间数组，起始时间，结束时间。返回起始时间到结束时间为止的被切割的数组。
    var gottenArray = new Array();
    for(i=0;i<timeArray.length;i++){//复制参数数组
      gottenArray.push(timeArray[i]);
    }
    var startYear = parseInt(startTime.split('-')[0]);
    var EndYear = parseInt(EndTime.split('-')[0]);
    var startMonth = parseInt(EndTime.split('-')[1]);
    var EndMonth = parseInt(EndTime.split('-')[1]);
    var startDate = parseInt(EndTime.split('-')[2]);
    var EndDate = parseInt(EndTime.split('-')[2]);
    if(dateForm.timePeriod.value == "年"){

    }else if(dateForm.timePeriod.value == "月"){

    }else if(dateForm.timePeriod.value == "日"){

    }

}*/

function random(min, max) {//伪随机生成函数，仅做测试用。
 
  return Math.floor(Math.random() * (max - min)) + min;
 
}
function getRandomArray(multer){//伪随机生成函数，仅做测试用。
    var randomArray =[];
    for (var i = 1; i <= 30; i++) { 
      randomArray.push(random(1, 1000)*multer);
    } 
    return randomArray;
}
function get3MonthAgo(){
	  var Year = new Date().getFullYear();
	  var Month = new Date().getMonth() + 1;
	  var Day = new Date().getDate();

	  if (Month <= 3){
	    Month = Month + 9;
	    Year = Year - 1;
	  }else{
	    Month = Month-3;
	  }
	  var DateData = Year.toString()+"-"+Month.toString()+"-"+Day.toString();
	  return DateData;
}    

function getToday(){
	  var Year = new Date().getFullYear();
	  var Month = new Date().getMonth() + 1;
	  var Day = new Date().getDate();
	  var DateData = Year.toString()+"-"+Month.toString()+"-"+Day.toString();
	  return DateData;
}

</script>
</body>
</html>