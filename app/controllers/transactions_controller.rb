class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @transact = Transact.new
    @categories = Category.created_by_current_user(current_user)
  end

  def index
    @transacts = Transact.all
    @category = Category.find(params[:category_id])
  end

  def create
    params = transact_params
    @transact = Transact.new(params)
    @transact.author = current_user
    @categories_ids = params[:categories_ids]

    @categories_ids&.each do |id|
      category = Category.find(id) unless id == ''
      @transact.categories.push(category) unless category.nil?
    end

    if @transact.save
      category_id = @transact.categories.first.id if @transact.categories.first
      redirect_to category_transactions_path(category_id), notice: 'Transaction added successfully'
    else
      render :new
    end
  end

  private

  def transact_params
    params.require(:transact).permit(:name, :amount, category_ids: [])
  end

  def create_general_category
    @general = current_user.categories.where(name: 'General').first

    if @general.nil?
      @general = Category.create(name: 'General',
                                 icon: 'https://cdn-icons-png.flaticon.com/512/3418/3418001.png', author: current_user)
    end

    @general
  end
end
