FROM nginx:alpine

# Copy the custom nginx config file
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 9222

# Check for stream module
RUN nginx -V 2>&1 | grep -qF -- --with-stream && echo "stream module included"

CMD ["nginx", "-g", "daemon off;"]
