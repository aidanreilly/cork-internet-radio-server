FROM nginx:alpine

# Copy the custom nginx config file
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 9222

CMD ["nginx", "-g", "daemon off;"]
