# ------------------------------------------
# STAGE 1: Build the application
# ------------------------------------------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the source code
COPY . .

# Build the app in Release mode
RUN dotnet publish -c Release -o /app/publish

# ------------------------------------------
# STAGE 2: Run the application
# ------------------------------------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy published files from build stage
COPY --from=build /app/publish .

# Expose port (Render uses $PORT)
EXPOSE 8080

# Set the environment variable for Render
# Render will override this automatically
ENV ASPNETCORE_URLS=http://0.0.0.0:8080

# Start your application
ENTRYPOINT ["dotnet", "CodeSniffs.API.dll"]
