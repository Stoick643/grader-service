# /graders/sql/Dockerfile

FROM alpine:latest

# Install SQLite3
RUN apk add --no-cache sqlite

# Create data directory
RUN mkdir -p /data

# Copy the company database
COPY company.db /data/company.db

# Set working directory
WORKDIR /data

# Ensure database is readable
RUN chmod 644 /data/company.db

# The environment is now ready to execute SQL commands via sqlite3