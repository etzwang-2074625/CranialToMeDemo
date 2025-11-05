module ApplicationHelper
	def required
    '<span class="req">*</span>'.html_safe
  end

  def clearfix
    "<div class='clearfix'></div>".html_safe
  end

  def flow_to
    '<span class="flow">=></span>'.html_safe
  end

  def cancel
    link_to 'cancel', (request.referer || root_path)
  end

  def full_title(page_title)
    base_title = 'DEPUT'
    if page_title.blank?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def active_menu(page, item)
    page ||= 'home'
    return unless page == item

    'active'
  end
  def nhash(value)
    if value.class.to_s == "PatientReport"
      render partial: 'layouts/nhash_slab_helper', locals: {item: value}
    elsif value.class.to_s == "Tissue"
      render partial: 'layouts/nhash_tissue_helper', locals: {item: value}
    elsif value.class.to_s == "CellSample"
      render partial: 'layouts/nhash_cellsample_helper', locals: {item: value}
    elsif value.class.to_s == "Patient"
      render partial: 'layouts/nhash_donor_helper', locals: {item: value}
    else
      return value.study_id
    end
    
  end

  def option_value(options, label)
    result = nil
    options.each do |ele|
      if ele[0].include?(label)
        result = ele[1]
      end
    end
    result
  end

  def required
    '<span class="req">*</span>'.html_safe
  end

  def clearfix
    "<div class='clearfix'></div>".html_safe
  end

  def flow_to
    '<span class="flow">=></span>'.html_safe
  end

  def cancel
    link_to 'cancel', (request.referer || root_path)
  end

  def full_title(page_title)
    base_title = 'DEPUT - DMS Plan Oversight Portal'
    if page_title.blank?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def active_menu(page, item)
    page ||= 'home'
    return unless page == item

    'active'
  end

  # ---------------
  # ---------------
  # Authorization
  # ---------------
  # ---------------

  def signed_in_user
    session[:return_to] = request.url
    redirect_to signin_url unless signed_in?
  end

  def admin
    redirect_to request.referer, notice: "You don't have enough privilege" unless signed_in? && current_user.admin?
  end


  def current_user=(user)
    @current_user = user
  end

  def current_user
    # last_seen = cookies[:last_seen]
    # if last_seen.present? and (Time.parse(last_seen) < 20.minute.ago)
    #   sign_out
    # else
    # end

    cookies[:last_seen] = Time.zone.now.to_s

    return if cookies[:remember_token].blank?

    @current_user ||= User.find_by(id: cookies[:remember_token])
    @current_user
  end

end
