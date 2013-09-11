<?php
error_reporting(E_ALL ^ E_NOTICE);
$output = date('Y-m-d H:i:s');
if(count($argv) == 3){
	$phoneNum = $argv[1];
	$msg = $argv[2];
	if(isset($phoneNum) && isset($msg)){
		function _print($message){
			echo date('Y-m-d H:i:s').' '.$message.'【'.$phoneNum.' '.$msg.'】';
		}
		$output .= '【'.$phoneNum.' '.$msg.'】,info:';
		$conf = include_once('./conf.php');
		$argv = array( 
	         'sn'=> $conf['sn'], ////替换成您自己的序列号
			 'pwd'=> strtoupper(md5($conf['sn'].$conf['pwd'])), //此处密码需要加密 加密方式为 md5(sn+password) 32位大写
			 'mobile'=> $phoneNum,//手机号 多个用英文的逗号隔开 post理论没有长度限制.推荐群发一次小于等于10000个手机号
			 'content'=> urlencode( $msg ),//短信内容
			 'ext'=>'',
			 'rrid'=>'',//默认空 如果空返回系统生成的标识串 如果传值保证值唯一 成功则返回传入的值
			 'stime'=>''//定时时间 格式为2011-6-29 11:09:21
		);
		//构造要post的字符串 
		foreach ($argv as $key=>$value) { 
			$params .= "&".$key."=".urlencode($value);
		} 
		$params = substr($params, 1);
		$len = strlen($params);
		$fp = fsockopen($conf['host'],$conf['port'],$errno,$errstr,$conf['timeout']) or exit($output.$errstr."->".$errno); 
		//构造post请求的头 
		$header = "POST ".$conf['path']." HTTP/1.1\r\n"; 
		$header .= "Host:".$conf['host']."\r\n"; 
		$header .= "Content-Type: application/x-www-form-urlencoded\r\n"; 
		$header .= "Content-Length: ".$len."\r\n"; 
		$header .= "Connection: Close\r\n\r\n"; 
		//添加post的字符串 
		$header .= $params."\r\n"; 
		//发送post的数据 
		fputs($fp,$header); 
		$inheader = 1; 
		while (!feof($fp)) { 
			$line = fgets($fp,1024); //去除请求包的头只显示页面的返回数据 
			// echo $line;
			if ($inheader && ($line == "\n" || $line == "\r\n")) { 
			     $inheader = 0; 
			} 
			if ($inheader == 0) { 
			    // echo $line; 
			} 
		}
		preg_match('/<string xmlns=\"http:\/\/tempuri.org\/\">(.*)<\/string>/',$line,$match);
		if(count($match) == 2 && count(explode("-",$match[1])) == 1){
			$output .= "success [".$match[1]."]";
		}else{
			$output .= "fail [".$line."]";
		}
	}
}
echo $output;
?>