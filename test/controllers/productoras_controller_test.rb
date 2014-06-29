require 'test_helper'

class ProductorasControllerTest < ActionController::TestCase
  setup do
    @productora = productoras(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:productoras)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create productora" do
    assert_difference('Productora.count') do
      post :create, productora: { address: @productora.address, name: @productora.name, rut: @productora.rut }
    end

    assert_redirected_to productora_path(assigns(:productora))
  end

  test "should show productora" do
    get :show, id: @productora
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @productora
    assert_response :success
  end

  test "should update productora" do
    patch :update, id: @productora, productora: { address: @productora.address, name: @productora.name, rut: @productora.rut }
    assert_redirected_to productora_path(assigns(:productora))
  end

  test "should destroy productora" do
    assert_difference('Productora.count', -1) do
      delete :destroy, id: @productora
    end

    assert_redirected_to productoras_path
  end
end
