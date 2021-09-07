class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = t(:micropost_created)
      redirect_to home_url
    else
      @feed_items = current_user.feed.page(params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t(:micropost_deleted)
    else
      flash[:danger] = t(:delete_fail)
    end
    redirect_to request.referer || home_url
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost
    flash[:danger] = t(:micropost_invalid)
    redirect_to request.referrer || home_url
  end

  def micropost_params
    params.require(:micropost).permit :content, :image
  end
end
