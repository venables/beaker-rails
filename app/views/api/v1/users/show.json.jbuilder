json.user do
  json.id @user.id
  json.email @user.email
  json.url api_v1_user_url(@user)
end
