FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["azcontainerapp-pug-demo.csproj", "./"]
RUN dotnet restore "azcontainerapp-pug-demo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "azcontainerapp-pug-demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "azcontainerapp-pug-demo.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "azcontainerapp-pug-demo.dll"]
