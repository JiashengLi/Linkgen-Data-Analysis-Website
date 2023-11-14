function dldata(name,time,status){
    if (name == "clickAnalysis"){
        return fakeData1;
    }else if (name == "onlinePro"){
        return fakeData2;
    }else{
        return fakeData3;
    }
}
/*var fakeData1 = {//空的假数据，若无需要请注释掉，否则注释掉下方的非空假数据
    status:1,
    msg:"",
    data:[]
}*/
var fakeData1 = {//整合三线图的假数据
    status:1,
    msg:"",
    data:[{clicksTime:"2019-03-21",clicksSum:2013,totalPrice:14023,rate:2013/14023},{clicksTime:"2019-05-04",clicksSum:3156,totalPrice:21021,rate:3156/21021},
          {clicksTime:"2019-06-21",clicksSum:1313,totalPrice:3145,rate:1313/3145},{clicksTime:"2019-07-21",clicksSum:2013,totalPrice:14023,rate:2013/14023},
          {clicksTime:"2019-08-21",clicksSum:2013,totalPrice:14023,rate:2013/14023},{clicksTime:"2019-09-21",clicksSum:2013,totalPrice:14023,rate:2013/14023},
          {clicksTime:"2019-10-21",clicksSum:2013,totalPrice:14023,rate:2013/14023},{clicksTime:"2019-11-21",clicksSum:2013,totalPrice:14023,rate:2013/14023}]
}

var fakeData2 = {//产品增量和总量的假数据
    status:1,
    msg:"",
    data:[{regTime:"2019-03-21",proCount:900,proIncrement:27},{regTime:"2019-04-21",proCount:1524,proIncrement:524},
    {regTime:"2019-05-21",proCount:2013,proIncrement:542},{regTime:"2019-06-21",proCount:2353,proIncrement:323},
          {regTime:"2019-07-21",proCount:2750,proIncrement:441},{regTime:"2019-08-21",proCount:3720,proIncrement:1013},
          {regTime:"2019-09-21",proCount:4025,proIncrement:331},{regTime:"2019-10-21",proCount:4355,proIncrement:351}]
}

var fakeData3 = {//数据分析的假数据
    status:1,
    msg:"",
    data:[{orderTime:"2019-03-21",orderCount:2013,totalPrice:14023},{orderTime:"2019-04-21",orderCount:2013,totalPrice:14023},
          {orderTime:"2019-05-21",orderCount:2013,totalPrice:14023},{orderTime:"2019-06-21",orderCount:2013,totalPrice:14023},
          {orderTime:"2019-07-21",orderCount:2013,totalPrice:14023},{orderTime:"2019-08-21",orderCount:2013,totalPrice:14023},
          {orderTime:"2019-09-21",orderCount:2013,totalPrice:14023},{orderTime:"2019-10-21",orderCount:2013,totalPrice:14023},]
}