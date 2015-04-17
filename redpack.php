‘<?php

function mylog($str)
{
  //echo $str;
}

function xml_content_to_array($xml_content)
{
    $xml = simplexml_load_string($xml_content);
    $array = (array)$xml;
    $nocdata = array();
    foreach ($array as $k=>$v)
    {
        $nocdata[$k] = str_replace(array('![CDATA[',']]'), '', $v);
    }
    return $nocdata;
}

Class SimpleXMLElementExtended extends SimpleXMLElement {
    /**
     * Adds a child with $value inside CDATA
     * @param unknown $name
     * @param unknown $value
     */
    public function addChildWithCDATA($name, $value = NULL) {
        $new_child = $this->addChild($name);

        if ($new_child !== NULL) {
            $node = dom_import_simplexml($new_child);
            $no   = $node->ownerDocument;
            $node->appendChild($no->createCDATASection($value));
        }

        return $new_child;
    }
}


function array_to_xml_content($root, $array)
{
    $xml = new SimpleXMLElementExtended('<' . $root .'/>');
    foreach ($array as $k => $v)
    {
        $xml->addChildWithCDATA($k, $v);
    }
    $to_ret =  $xml->asXML();
    $x = '<?xml version="1.0"?>' . "\n";
    return str_replace($x, '', $to_ret);
}


function httpGet($url)
{
    $curl = curl_init();
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curl, CURLOPT_TIMEOUT, 500);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($curl, CURLOPT_URL, $url);

    $res = curl_exec($curl);
    curl_close($curl);

    return $res;
}

/*
$fc = file_get_contents('x.xml');
var_dump(xml_content_to_array($fc));

$a = array('abc'=>12, 'bcd'=>'中文');
echo array_to_xml_content('xml', $a);
*/

/**
 * curl POST
 *
 * @param   string  url
 * @param   array   数据
 * @param   int     请求超时时间
 * @param   bool    HTTPS时是否进行严格认证
 * @return  string
 */
function curl_post($url, $data = array(), $timeout = 30, $CA = true)
{
    mylog($url);
    $cacert = getcwd() . '/weixin_pay/cert/apiclient_cert.pem'; //CA根证书
    $keyfile = getcwd() . '/weixin_pay/cert/apiclient_key.pem';
    $rootca = getcwd() . '/weixin_pay/cert/rootca.pem';
    mylog($cacert);

    $SSL = substr($url, 0, 8) == "https://" ? true : false;

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $timeout-2);
    curl_setopt($ch, CURLOPT_VERBOSE, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    if ($SSL && $CA) {

        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);  // 只信任CA颁布的证书
        curl_setopt($ch, CURLOPT_CAINFO, $rootca); // CA根证书（用来验证的网站证书是否是CA颁布）
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 1); // 检查证书中是否设置域名，并且是否与提供的主机名匹配
        curl_setopt($ch, CURLOPT_SSLKEYTYPE, 'PEM');
        curl_setopt($ch, CURLOPT_SSLCERT, $cacert);
        curl_setopt($ch, CURLOPT_SSLKEY, $keyfile);
        curl_setopt($ch, CURLOPT_SSLKEYPASSWD, '1229344702');
    } else if ($SSL && !$CA) {
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // 信任任何证书
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 1); // 检查证书中是否设置域名
    }
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Expect:')); //避免data数据过长问题
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);

    mylog('prepare request');
    $ret = curl_exec($ch);
    mylog('do request');

    mylog(curl_error($ch));  //查看报错信息

    curl_close($ch);
    return $ret;
}

function create_uuid()
{
    $str = md5(uniqid(mt_rand(), true));

    return $str;
}

function get_time_str()
{
    $mch_billno=date('YmdHis').rand(1000, 9999);
    return $mch_billno;
}

function gen_sign($gets)
{
    mylog('gen_sign');
    mylog($gets);
    ksort($gets, SORT_STRING);
    mylog($gets);

    $pay_key ='wangpeisheng1234567890leapcliffW';
    $all_str = '';
    foreach ($gets as $k=>$v)
    {
        $all_str  .= ($k . '=' . $v);
        $all_str .= '&';
    }
    $all_str .= ('key='. $pay_key);
    mylog($all_str);
    $md5 = strtoupper(md5($all_str));
    mylog($md5);
    return $md5;
}


function get_request_xml($open_id, $amount,
    $send_name = '驯鹿之旅', $wishing = '欢迎来到驯鹿之旅！', $action_title = '驯鹿之旅送红包！', $action_remark = '关注驯鹿之旅，红包多多！')
{
    $mch_id = '1233034702'; // 商户ID
    $app_id = 'wx456ffb04ee140d84'; // APPID
    $nonce_str = create_uuid();

    $arr = array(
        'nonce_str'=>$nonce_str,
        'mch_billno'=>$mch_id . get_time_str(), // mch_id+yyyymmdd+10位不重复数字
        'mch_id'=>$mch_id, //商户号,
        'wxappid'=>$app_id,
        'nick_name'=>$send_name,
        'send_name'=>$send_name,
        're_openid'=>$open_id,
        'total_amount'=>$amount,
        'min_value'=>$amount,
        'max_value'=>$amount,
        'total_num'=>1,
        'wishing'=>$wishing,
        'client_ip'=>'121.42.47.121',
        'act_name'=>$action_title,
        'remark'=>$action_remark
        // ,
        // 'logo_imgurl'=>'http://www.wizarcan.com/images/logo1.png',
        // 'share_content'=>'关注万猫智慧商城，惊喜多多！',
        // 'share_url'=>'http://www.wizarcan.com/',
        // 'share_imgurl'=>'http://www.wizarcan.com/images/logo1.png'
    );

    $arr['sign'] = gen_sign($arr);

    return $arr;
}

/*
 * 红包主入口
 *  成功返回true
 *  失败返回false
 */

function do_red_pack_request($open_id, $amount,
    $send_name = '驯鹿之旅', $wishing = '欢迎来到驯鹿之旅！',
    $action_title = '驯鹿之旅送红包！', $action_remark = '关注驯鹿之旅，红包多多！')
{
    $url = 'https://api.mch.weixin.qq.com/mmpaymkttransfers/sendredpack';
    $arr = get_request_xml($open_id, $amount, $send_name, $wishing, $action_title, $action_remark);
    mylog($arr);
    $xml = array_to_xml_content('xml', $arr);
    mylog($xml);
    $ret = curl_post($url, $xml);
    mylog($ret);
    var_dump($ret);
    $result = xml_content_to_array($ret);
    if ($result['return_code'] == 'SUCCESS' && $result['result_code'] == 'SUCCESS')
    {
        return true;
    }
    else
    {
        return false;
    }
}

/*
 * 说明：修改get_request_xml函数中定义的变量：
 *    $mch_id = '1229344702';         // 商户ID
 *    $app_id = 'wx54d8b65ca288f8f3'; // 微信APPID
 *
 * 调用例子：
 *    do_red_pack_request('oFEZQuKae4P5ye8jCy0SWCHigXnk', 1000);
 */

if ($argc != 8) { 
die("Usage: redpack.php <openid> <sender_name> <wishing> <action_title> <action_remark> <min> <max>"); 
} 

// remove first argument 
array_shift($argv); 

// get and use remaining arguments 
$openid = $argv[0]; 
$sender_name = $argv[1]; 
$wishing = $argv[2]; 
$action_title = $argv[3];
$action_remark = $argv[4];
$min = $argv[5];
$max = $argv[6];

$value = rand($min, $max);
//$openid = 'oRKD0s9cXqra6-BsQzACoAii6hX4';
//$openid = 'oRKD0sy_YA8nxgeDAenEI1KN6_2s';
//$openid = 'oRKD0s8stWW-DUiWIKDKV22qaUVI';
do_red_pack_request($openid, $value, $sender_name, $wishing, $action_title, $action_remark);
?>

