class IndexController < ApplicationController

  layout 'application'
  
  def index
    # flash[:notice] = "BOB"
    # flash[:error]  = "JIM"
  end
  
  def create
    unless params[:txt].blank?
      txturl = TxtRedis.get_url(params[:txt]) unless params[:txt].blank?
      token = TxtRedis.token_from_url(txturl)
      h = {:token => token, :txt => TxtRedis.get_txt_for_client(params[:txt], txturl), :url => txturl, :raw => params[:txt]}
      respond_to do |format|
        format.html {
          TxtRedis.set_session(session, h)
          if params[:submit_tweet] == "twitter"
            redirect_to "/twitter/create"
          else
            @twitter_txt = h[:raw]
            redirect_to txturl and return
          end
        }
        format.xml { render :xml => h.to_xml(:root => "txt141"), :status => :created, :location => txturl }
        format.json { render :json => h.to_json, :status => :created, :location => txturl }
      end
    else
      respond_to do |format|
        format.html { render :action => "index" }
        format.xml  { render :status => :unprocessable_entity }
        format.json  { render :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    txtr = TxtRedis.get_session(session)
    txtr[:txt] = params[:txt]
    TxtRedis.set_session(session, txtr)
    redirect_to "/twitter/create"
  end
  
  def show
    @txt = TxtRedis.get_txt(params[:id])
    if @txt.blank? || @txt.nil?
      perm_redirect and return
    else
      @txturl = TxtRedis.url_from_token(params[:id])
      if REDIS.exists(session[:session_id]) == true
        txtr = TxtRedis.get_session(session[:session_id])
        @twitter_txt = TxtRedis.get_txt_for_client(txtr[:txt], txtr[:url])
      end
      data = {:token => params[:id], :txt => TxtRedis.get_txt_for_client(@txt, @txturl), :url => @txturl, :raw => @txt}
      respond_to do |format|
        format.html
        format.xml { render :xml => data.to_xml(:root => "txt141"), :status => :ok }
        format.json { render :json => data.to_json, :status => :ok }
      end
    end
  end
  
  def api
  end
  
  def about
  end

  def browse
    @page = (params[:page] || 1).to_i
    @per_page = 10
    cnt = (@page - 1) * @per_page
    txt_codes = REDIS.zrevrange "codes", cnt, (cnt + @per_page - 1)
    txt_count = REDIS.zcount "codes", "-inf", "+inf"
    @txts = txt_codes.collect {|code| {:token => code, :txt => REDIS.hget("code-text",code)}}
    
    @txts = WillPaginate::Collection.create @page, @per_page, txt_count do |pager|
      pager.replace @txts
    end    
    # @txts = @txts.paginate(:page => @page, :per_page => @per_page, :total_entries => txt_count)
  end
  
  # TODO move this to app.rb - wasn't working
  def perm_redirect( the_url = nil, status = "301 Moved Permanently")
    flash[:alert] = "Not found"
    headers["Status"] = status
    if the_url.nil?
      redirect_to "/" and return
    else
      redirect_to the_url and return
    end
  end
  
end
