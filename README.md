# docker-warsaw-puppeteer

## Requisitos

- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Variáveis de ambiente

Crie um arquivo `.env` com base no `.env.example`:

```
cp .env.example .env
```

Preencha os valores no arquivo `.env`.

Veja a seguir uma descrição sobre as variáveis obrigatórias.

- `CAIXA_USERNAME`: Nome de usuário utilizado para fazer login no [site da Caixa](https://internetbanking.caixa.gov.br/sinbc/#!nb/login).

## Criar imagem e iniciar um container

1. Crie a imagem:

```
docker build -t docker-warsaw .
```

2. Inicie um container:

```
docker run -itd --privileged \
  --name=docker-warsaw \
  -e CAIXA_USERNAME=seu-usuario-aqui \
  -p 127.0.0.1:6080:6080 \
  docker-warsaw \
  && clear \
  && docker logs -f docker-warsaw
```

Aguarde todos os componentes serem iniciados e pronto! 🎉

Para visualizar o Chromium do container, em sua máquina acesse `http://localhost:6080/vnc_auto.html`.

## Parar e remover o container

Para parar e remover o container é necessário rodar o seguinte comando:

```
docker stop docker-warsaw && docker rm docker-warsaw
```

## Agradecimentos

Esse projeto é uma adaptação do @[juliohm1978/dockerbb](https://github.com/juliohm1978/dockerbb/).
