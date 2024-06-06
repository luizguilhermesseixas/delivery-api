# Cria uma imagem a partir da imagem oficial do Ruby 3.2.2
FROM ruby:3.3.0-slim
# Atualiza o instalador de pacotes do Linux
# e instala algumas dependências "básicas" no S.O.
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y \
  build-essential git libvips pkg-config curl libsqlite3-0
# Cria um diretório na imagem onde vão viver os arquivos
# da aplicação Rails
WORKDIR /delivery
# Copia todos os arquivos (atuais) da aplicação rails para a Imagem
COPY . .
# Instala as dependências (atuais) da aplicação
RUN bundle install