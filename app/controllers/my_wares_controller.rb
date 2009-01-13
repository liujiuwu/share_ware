require 'rexml/document'
include REXML

class MyWaresController < ApplicationController
  layout 'taobao'
  skip_before_filter :verify_authenticity_token

  def index
     url = URI.parse('http://sip.alisoft.com/sip/rest')
    sessionid = Time.now.strftime("%Y%m%d%H%M%S")
    p = {
      'sip_appkey' => '20426',
      'sip_appsecret' => '144098c0d58411ddbc14a92bef58a353',
      'sip_apiname' => 'taobao.items.onsale.get',
      #'sip_apiname' => 'taobao.items.get',
      'sip_timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      'sip_sessionid' => sessionid,
      'page_no' => params[:page_no],
      'page_size' => params[:page_size],
      'v' => '1.0',
      'nicks' => params[:nick],
      'q' => params[:q],
      'fields' => 'iid,title,nick,type,cid,pic_path, delist_time,price,post_fee',
      'format' => 'json'
    }
    p["sip_sign"] = MD5.hexdigest('144098c0d58411ddbc14a92bef58a353' + p.sort.flatten.join).upcase

    redirect_url = nil
    resp  = Net::HTTP.post_form(url, p)
    doc = REXML::Document.new(resp.body)
    doc.elements.each("error_rsp/url") { |e| redirect_url = e.text }
    #result = JSON.parse(resp.body)
    unless redirect_url.nil?
      puts "#{redirect_url}&sip_redirecturl=http://127.0.0.1:3000/my_wares"
      redirect_to "#{redirect_url}&sip_redirecturl=http://127.0.0.1:3000/vindex"
    else
      render :text => resp.body
    end
  end

  def vindex
    @user_name = params[:isp_username]
  end
  
  def my_wares
    url = URI.parse('http://sip.alisoft.com/sip/rest')
    sessionid = Time.now.strftime("%Y-%m-%d %H:%M:%S")+"taobao";
    p = {
      'sip_appkey' => '20426',
      'sip_appsecret' => '144098c0d58411ddbc14a92bef58a353',
      'sip_apiname' => 'taobao.items.onsale.get',
      #'sip_apiname' => 'taobao.items.get',
      'sip_timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      'sip_sessionid' => sessionid,
      'page_no' => params[:page_no],
      'page_size' => params[:page_size],
      'v' => '1.0',
      'nicks' => params[:nick],
      'q' => params[:q],
      'fields' => 'iid,title,nick,type,cid,pic_path, delist_time,price,post_fee',
      'format' => 'json'
    }
    p["sip_sign"] = MD5.hexdigest('144098c0d58411ddbc14a92bef58a353' + p.sort.flatten.join).upcase
    
    resp  = Net::HTTP.post_form(url, p)
    render :text => resp.body
  end

end
