FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5043

ENV ASPNETCORE_URLS=http://+:5043

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["lilivet.csproj", "./"]
RUN dotnet restore "lilivet.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "lilivet.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "lilivet.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "lilivet.dll"]
