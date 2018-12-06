json.extract! @user, :id, :museum_id, :email, :authentication_token, :created_at, :updated_at

if @user.museum.present?
  json.museum do
    json.extract! @user.museum, :id, :name
    json.set! :link, api_v1_museum_url(@user.museum, format: :json)
  end
else

  json.set! :museum, nil
end