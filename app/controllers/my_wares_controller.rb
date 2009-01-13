class MyWaresController < ApplicationController
  layout 'taobao'
  skip_before_filter :verify_authenticity_token

  def index
  end
  
  def my_wares
    url = URI.parse('http://sip.alisoft.com/sip/rest')
    sessionid = Time.now.strftime("%Y-%m-%d %H:%M:%S")+"taobao";
    p = {
      'sip_appkey' => '20426',
      'sip_appsecret' => '144098c0d58411ddbc14a92bef58a353',
      'sip_apiname' => 'taobao.items.onsale.get',
      'sip_timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      'sip_sessionid' => sessionid,
      'format' => 'json',
      'page_no' => params[:page_no],
      'page_size' => params[:page_size],
      'v' => '1.0',
      #'nicks' => params[:nick],
      #'q' => params[:q],
      'fields' => 'iid,title,nick,type,cid,pic_path, delist_time,price,post_fee'
    }
    p["sip_sign"] = MD5.hexdigest('144098c0d58411ddbc14a92bef58a353' + p.sort.flatten.join).upcase

    resp  = Net::HTTP.post_form(url, p)
    render :text => resp.body
  end

end
