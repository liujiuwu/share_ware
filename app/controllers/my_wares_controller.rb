require 'rexml/document'
include REXML

class MyWaresController < ApplicationController
  layout 'taobao'
  skip_before_filter :verify_authenticity_token

  def index
  end
  
  def my_wares
    url = URI.parse('http://sip.alisoft.com/sip/rest')
    login_url,json,sip_appkey,sip_appsecret,sessionid = nil,'','20426','144098c0d58411ddbc14a92bef58a353','063261cda065408e9401d81973e72c10'

    p = {
      'sip_appkey' => sip_appkey,
      'sip_appsecret' => sip_appsecret,
      'sip_apiname' => 'taobao.items.onsale.get',
      'sip_timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      'sip_sessionid' => sessionid,
      'page_no' => params[:page_no],
      'page_size' => params[:page_size],
      'v' => '1.0',
      'fields' => 'iid,title,price,list_time,num,pic_path, delist_time',
      'format' => 'json'
    }
    p["sip_sign"] = MD5.hexdigest(sip_appsecret + p.sort.flatten.join).upcase

    resp  = Net::HTTP.post_form(url, p)
    doc = REXML::Document.new(resp.body)
    doc.elements.each("error_rsp/url") { |e| login_url = e.text }
    json = login_url.nil? ?  resp.body : "{login_url:\"#{login_url}&sip_redirecturl=http://127.0.0.1:3000/my_wares\"}"
    render :text => json
  end

end
