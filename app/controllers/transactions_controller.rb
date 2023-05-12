class TransactionsController < ApplicationController
    before_action :authenticate_user!

  def new
    @transaction = Transaction.new
    @categories = Category.created_by_current_user(current_user)
  end

  def index
    @transactions = Transaction.joins(:categories).where(categories: { id: params[:category_id] }).order(created_at: :desc)
    @category = Category.find(params[:category_id])
  end

  def create
    params = transaction_params
    @transaction = Transaction.new(name: params[:name], amount: params[:amount])
    @transaction.author = current_user
    @categories_id = params[:ids]
    @categories_id.each do |id|
      category = Category.find(id) unless id == ''
      @transaction.categories.push(category) unless category.nil?
    end

    if @transaction.save
      redirect_to category_transaction_path(@transaction.categories.first.id), notice: 'Transactions added successfully'
    else
      render :new
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :amount, ids: [])
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
