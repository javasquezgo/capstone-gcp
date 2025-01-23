FROM nginx:latest
ARG src="Europe-Travel-Website-html-css-js/Europe Travel"
ARG target="/usr/share/nginx/html"
COPY ${src} ${target}
