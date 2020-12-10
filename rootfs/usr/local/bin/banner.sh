#!/bin/bash
echo "
===

Componentes iniciados!
Em seu navegador, acesse (CTRL+Click do mouse aqui no terminal):

    http://localhost:6080/vnc_auto.html

O navegador dentro deste container será sempre reiniciado.

Para desligar definitivamente, lembre-se de parar o container docker-warsaw:

    docker stop docker-warsaw

" > /dev/pts/0
