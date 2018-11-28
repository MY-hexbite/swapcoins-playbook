limit_req_zone $binary_remote_addr zone=apilogin:10m rate=3r/s;
limit_req_zone $binary_remote_addr zone=apianon:10m rate=10r/s;

server {
    listen 80;

    server_name {{ swapcoins_app_api_nginx_server_name }};
    return 301 https://{{ swapcoins_app_api_nginx_server_name }}$request_uri;
}

server {
  listen 443;

  server_name {{ swapcoins_app_api_nginx_server_name }};

  ssl on;
  ssl_certificate     /etc/letsencrypt/live/swapcoins.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/swapcoins.com/privkey.pem;
  ssl_prefer_server_ciphers On;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_session_cache shared:SSL:10m;
  
  location /.well-known/acme-challenge {
    default_type "text/plain";
    allow all;
    root /home/{{ swapcoins_deploy_user }}/api/swapcoins.com/current/public;
  }

  location / {
    limit_req zone=apianon burst=8 nodelay;

    proxy_pass http://localhost:3001;
    proxy_http_version 1.1;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }
}
