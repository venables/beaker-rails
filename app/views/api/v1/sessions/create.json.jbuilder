json.session do
  json.token @token
end

json.user do
  json.id @user.id
  json.email @user.email
end
