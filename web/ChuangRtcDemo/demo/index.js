// 自定义require 来兼容非ES模块的非打包调试，
function require (jsFile, moduleName) {
    //if (typeof module === 'object')
    moduleName = moduleName || jsFile.replace(/(.*\/)*([^.]+).*/ig, "$2");
    return window[moduleName] || "no_module";
}

function addScriptText (type, code) {
    var script = document.createElement("script");
    script.type = "module";
    try {
        //IE浏览器认为script是特殊元素,不能再访问子节点;报错;
        script.appendChild(document.createTextNode(code));
    } catch (ex) {
        script.text = code;
    }
    // script.src = code;
    document.getElementsByTagName('body')[0].appendChild(script);
}
function addScript (type, src, onload) {
    var script = document.createElement("script");
    script.type = type;
    script.src = src;
    script.onload = onload;
    document.getElementsByTagName('body')[0].appendChild(script);
}

var ChuangLiveEngine = { VERSION: '' };

// 先确定版本，运行环境，服务环境
var rconfig = {
    appid: '',
    appkey: '',

    sdkversion: '', //版本号,latest,raw
    runenv: 'local', //local,inner,online
    serverenv: 'stable', // stable,lab,grey,demo(demo为给客户演示需要输入appId和appKey的特殊版本，依然是stable)

    packjs: null,
};

(function () {
    var hostname = window.location.hostname;
    if (hostname.indexOf('localhost') >= 0 ||
        hostname.indexOf('local.') >= 0) {
        rconfig.runenv = 'local';
    } else if (hostname.indexOf('inner.') >= 0) {
        rconfig.runenv = 'inner';
    } else {
        rconfig.runenv = 'online';
    }

    var pathname = window.location.pathname;
    var regex = /\/sdk([^_]+)__([^/]+)/;
    var matches = null;
    if (matches = regex.exec(pathname)) {
        // console.log(matches);
        rconfig.sdkversion = matches[1],
            rconfig.serverenv = matches[2];
        // sdkConfig.jsmode = 1; //如果选择了路径，放弃调试
    } else {
        if (rconfig.runenv != 'local') {
            rconfig.sdkversion = 'latest',
                rconfig.serverenv = 'stable';
        } else {
            rconfig.sdkversion = 'raw',
                rconfig.serverenv = 'stable';
        }
    }

    function SDKPath () { return './sdk' + (rconfig.runenv == 'inner' ? 'inner' : ''); }

    switch (rconfig.sdkversion) {
        case 'latest':// 不要删除，不要break

        case '2.4.6':
            rconfig.packjs = SDKPath() + '/Web2.2.1.1-202110111846-2.2.1.1.js';
            break;
        case '2.4.5':
            rconfig.packjs = SDKPath() + '/W2.1.0-202105271214-2.4.5.js';
            break;
        case '2.4.4':
            rconfig.packjs = SDKPath() + '/cclive-2.4.4.js';
            break;
        case '2.4.3':
            rconfig.packjs = SDKPath() + '/cclive-2.4.3.js';
            break;
        case '2.3.4':
            rconfig.packjs = './dist/cclive.u4GJ7Z.js';
            break;
        case '2.3.3':
        case '2.3.2':
            rconfig.packjs = './dist/cclive.BzUvo4.js';
            break;
        case '2.1.0':
        case '2.0.9':
            rconfig.packjs = './dist/cclive.JRTpRY.js';
            break;
        case '2.0.8':
            rconfig.packjs = './dist/cclive.hRR0da.js';
            break;
        case '2.0.7':
        case '2.0.6':
            rconfig.packjs = './dist/cclive.n2pmtj.js';
            break;
        case '2.0.5':
        case '2.0.4':
        case '2.0.1':
            rconfig.packjs = './dist/cclive.QO0RVA.js';
            break;
        default:
            break;
    }


})();
if (rconfig.serverenv != 'demo') {
    var $appInfo = $('.app-info');
    $appInfo.hide();
}

if (rconfig.packjs) {
    addScript('text/javascript', rconfig.packjs, function () {
        startup();
    });
}
else {
    addScript('module', './third/adapter.js', function () { });
    addScript('module', './third/EventEmitter.js', function () { });
    addScript('text/javascript', './third/md5.js', function () { });
    addScript('text/javascript', './third/base64.js', function () { });
    addScript('text/javascript', './third/xxtea.js', function () { });
    addScriptText('module', 'import ChuangLiveEngine from \'./cclive.js\';\
        window.ChuangLiveEngine = ChuangLiveEngine;\
        startup();\
    ');
}

function startup () {
    // 这里的执行顺序要晚于index.html 的script

    if (rconfig.serverenv != 'demo') {
        // 初始化sdk
        sdkConfig.inited = true;

        ChuangLiveEngine.initEngine(rconfig.appid, rconfig.appkey, generalFailure);


        bindEngineEvents();
    }

}

