FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["WebFrontEnd/WebFrontEnd.csproj", "WebFrontEnd/"]
RUN dotnet restore "WebFrontEnd/WebFrontEnd.csproj"
COPY . .
WORKDIR "/src/WebFrontEnd"
RUN dotnet build "WebFrontEnd.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "WebFrontEnd.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "WebFrontEnd.dll"]
