Apipie.configure do |config|
  config.app_name                = "MoroesBackend"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.validate                = false
  config.app_info = <<-MD
目前接口仅支持 JSON 格式，所有的接口路径都需要添加 `.json` 后缀。

除过认证接口，访问其他接口都需要认证信息。
 
两个方式：

1. 传参数


    ...api/v1/museums/1.json?user_email=admin@microwise-system.com&user_token=zmSt4WHAFFsAecsLXQDG

2. 传 Header

    X-User-Email admin@microwise-system.com
    X-User-Token zmSt4WHAFFsAecsLXQDG

上面的 user token 通过认证接口获取
  MD
end
