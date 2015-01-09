json.session do
  json.token @session.public_token
end

json.user do
  json.id @user.id
  json.email @user.email
end
