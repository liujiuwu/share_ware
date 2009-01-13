require 'rubygems'
require 'net/http'
require 'uri'
require 'md5'
require 'json'

class ValidateUserController < ApplicationController
  def index
    url = URI.parse('http://sip.alisoft.com/sip/rest')
    p = {
      'sip_appkey' => '20426',
      'sip_appsecret' => '144098c0d58411ddbc14a92bef58a353',
      'sip_apiname' => 'alisoft.validateUser',
      'userId' => params[:user_id],
      'appInstanceId' => params[:app_instance_id],
      'token' => params[:token],
      'appId' => params[:app_id],
      'sip_timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      'sip_sessionid' => '063261cda065408e9401d81973e72c10',
      'format' => 'json'
    }
    p["sip_sign"] = MD5.hexdigest('144098c0d58411ddbc14a92bef58a353' + p.sort.flatten.join).upcase
    resp  = Net::HTTP.post_form(url, p)
    result = JSON.parse(resp.body)
    if result['response'] == "0" || result['response'] == "1" then
      redirect_to :controller => "my_wares"
    else
      render :text => return_message(result['response'])
    end
    #    render :text => return_message(result['response'])
  end

  private
  def return_message(code)
    message = ""
    case code
    when "1"
      message = "应用的订购者"
    when "0"
      message = "应用的使用者"
    when "-1"
      message = "尚未订购该应用"
    when "-2"
      message = "非法用户"
    when "-3"
      message = "没有订购"
    when "-4"
      message = "订阅了多个，不明确"
    when "1001"
      message = "签名无效"
    when "1002"
      message = "请求已过期"
    when "1004"
      message = "需要绑定用户"
    when "1005"
      message = "需要提供appid"
    when "1006"
      message = "需要提供服务名"
    when "1007"
      message = "需要提供签名"
    when "1008"
      message = "需要提供时间戳"
    when "1010"
      message = "无权访问服务"
    when "1011"
      message = "服务不存在"
    when "1012"
      message = "需要提供SessionId"
    when "1013"
      message = "需要提供用户名"
    when "1014"
      message = "回调服务不存在"
    when "1015"
      message = "AppKey不存在"
    when "1016"
      message = "服务次数超过限制"
    when "1017"
      message = "服务请求过于频繁"
    when "1018"
      message = "登录请求URL过长"
    when "1019"
      message = "ISP请求IP非法"
    when "1020"
      message = "请求参数值长度溢出"
    when "1021"
      message = "isp处理请求失败"
    else
      message = "未知异常"
    end
    message
  end

end
