# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files from Backend
COPY ../Backend/ParentTeacherBridge.sln ./
COPY ../Backend/ParentTeacherBridge.API/*.csproj ./ParentTeacherBridge.API/

# Restore dependencies
RUN dotnet restore

# Copy the rest of the backend source code
COPY ../Backend/ ./

# Publish the application
WORKDIR /src/ParentTeacherBridge.API
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy published files
COPY --from=build /app/publish .

# Set environment variables
ENV ASPNETCORE_URLS=http://+:5000
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Expose port
EXPOSE 5000

# Run the app
ENTRYPOINT ["dotnet", "ParentTeacherBridge.dll"]
