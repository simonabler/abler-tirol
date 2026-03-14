# ─────────────────────────────────────────────
#  abler.tirol — Static Frontend
#  Serves: index.html via nginx
#  Fonts:  fetched from api.abler.tirol at runtime
# ─────────────────────────────────────────────

FROM nginx:alpine

# Remove default nginx config and content
RUN rm /etc/nginx/conf.d/default.conf \
    && rm -rf /usr/share/nginx/html/*

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy static site files
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
