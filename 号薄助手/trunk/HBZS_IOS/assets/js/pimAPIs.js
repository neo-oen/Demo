//JS调的打电话功能
function pimApiDoCall(param) {
    try {
//      window.FoundWebView.doCall(param);
        window.location = "tel-"+param;
    } catch (error) {
        //pimApiShowToastMessage("pimApiDoCall发生异常，请稍后再试");
    }
}
//定位发起
function pimApiGetlocation(){}
var lonlatjson='{"Latitude":"116.38","Longitude":"39.9"}';
//定位回调
function locationCallback(location) {
    try {
        lonlatjson = location;
    } catch (error) {
        //pimApiShowToastMessage("locationCallback发生异常，请稍后再试");
    }
}
//去登录
function pimApiToLogin() {
	try {
		window.FoundWebView.login();
    } catch (error) {
        //pimApiShowToastMessage("pimApiToLogin发生异常，请稍后再试");
    }
}
//获取登录状态
function pimApiGetPhoneFunc() {
    try {
        var phonejson = window.FoundWebView.getLoginFlag();
        var parsedPhone = jQuery.parseJSON(phonejson);
        return parsedPhone.phone;
    } catch (error) {
        //pimApiShowToastMessage("pimApiGetPhoneFunc发生异常，请稍后再试");
    }
}

//获取登录用户名
function pimApiGetUserId() {}

// JS链接跳转本应用的WebView
function pimApiOpenURL(navtitle, url) {
    try {
        var parsedJson = jQuery.parseJSON(lonlatjson);
        window.location=url+'-/title'+navtitle;
    } catch (error) {
    }
}

// JS链接跳转本应用的WebView
function pimApiOpenURLWithLocation(navtitle, url) {
    try {
        var parsedJson = jQuery.parseJSON(lonlatjson);
        var locstr = '&lon='+parsedJson.Longitude+'&lat='+parsedJson.Latitude;
        window.location=url+'-/title'+navtitle;
    } catch (error) {
    }
}

function pimApiOpenURLForBST(navtitle, url) {
    try {
        var parsedJson = jQuery.parseJSON(lonlatjson);
        var locstr = '&logn=%E4%B8%9C%E7%BB%8F'+parsedJson.Longitude+'&dim=%E5%8C%97%E7%BA%AC'+parsedJson.Latitude;
        var mdnstr = '&tel='+pimApiGetPhoneFunc();
		//window.FoundWebView.openURLs(navtitle, url+locstr+mdnstr);
        //pimApiShowToastMessage(locstr+mdnstr);
        window.location=url+'-/title'+navtitle;
    } catch (error) {
    }
}
//链接跳转手机内置的浏览器
function pimApiOpenSafari(url){
    window.location = url+'/OpenBySafari';
}
function pimApiOpenChrome(url) {}
//toast弹出消息的方法
function pimApiShowToastMessage(message){
    try{
        window.location = "alert-"+message;
    }catch(error) {
        pimApiShowToastMessage("pimApipimApiShowToastMessage消息弹出失败");
    }
}
//打开精彩应用
function pimApiOpenWonderfulApp(){
	try{
		window.FoundWebView.openWonderfulApp();
	}catch(error) {
		//pimApiShowToastMessage("pimApipimApiShowToastMessage消息弹出失败");
	}

}
//打开免费短信
function pimApiOpenFreeMessage(navtitle, url) {
    try {
        window.FoundWebView.openFreeMessage(navtitle, url);
    } catch (error) {
        //pimApiShowToastMessage("pimApiOpenFreeMessage免费短信打开失败");
    }

}