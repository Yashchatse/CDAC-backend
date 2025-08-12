# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only solution and project files first for caching restore layers
COPY *.sln ./
COPY Backend/*.csproj ./Backend/

# Restore dependencies
RUN dotnet restore

# Copy the rest of the source code
COPY . .

# Publish the application
WORKDIR /src/Backend
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy published files from build stage
COPY --from=build /app/publish .

# Set environment variables for ASP.NET Core
ENV ASPNETCORE_URLS=http://+:5000
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Expose port
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "ParentTeacherBridge.dll"]
