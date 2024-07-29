# Use the official Dart image as the base image
FROM dart:stable AS build

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable Flutter Web
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

# Set the working directory
WORKDIR /app

# Copy the pubspec file and install dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application code
COPY . .

# Build the Flutter web app
RUN flutter build web

# Use a lightweight web server to serve the Flutter app
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
