
caddy fmt | caddy adapt > caddy.json

curl \
    -X POST 127.0.0.1:2019/load \
    -H "Content-Type: application/json" \
    -d @caddy.json
