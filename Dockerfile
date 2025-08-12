# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files first for restore caching
COPY Backend/Parent_Teacher_WEBAPI.sln ./
COPY Backend/ParentTeacherBridge.API/*.csproj ./ParentTeacherBridge.API/

# Restore dependencies
RUN dotnet restore ./Parent_Teacher_WEBAPI.sln

# Copy the rest of the source code
COPY Backend/ ./

# Publish the application
WORKDIR /src/ParentTeacherBridge.API
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy published output from build stage
COPY --from=build /app/publish .

# Render will inject PORT, default to 5000
ENV ASPNETCORE_URLS=http://+:5000

EXPOSE 5000
ENTRYPOINT ["dotnet", "ParentTeacherBridge.API.dll"]
